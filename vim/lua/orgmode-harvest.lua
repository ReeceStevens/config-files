_G.orgmode_harvest = _G.orgmode_harvest or {}

require('orgmode')
local curl = require('plenary.curl')

local Files = require('orgmode.parser.files')
local Table = require('orgmode.parser.table')
local Duration = require('orgmode.objects.duration')
local Date = require('orgmode.objects.date')

---@class HarvestClockReport
---@field total_duration Duration
---@field from Date
---@field to Date
---@field table Table
---@field entries table[]
local HarvestClockReport = {}

function HarvestClockReport:new(opts)
  opts = opts or {}
  local data = {}
  data.from = opts.from
  data.to = opts.to
  data.total_duration = opts.total_duration
  data.entries = opts.entries or {}
  data.table = opts.table
  setmetatable(data, self)
  self.__index = self
  return data
end

function HarvestClockReport.from_date_range(from, to)
  local total_duration = 0
  local entries = {}
  for _, orgfile in ipairs(Files.all()) do
    local file_clocks = orgfile:get_clock_report(from, to)
    if #file_clocks.headlines > 0 then
      for _, headline in ipairs(file_clocks.headlines) do
          for _, log_item in ipairs(headline.logbook.items) do
              table.insert(entries, {
                  name = orgfile.category .. '.org',
                  tags = headline.tags,
                  title = headline.title,
                  start_time = log_item.start_time,
                  end_time = log_item.end_time,
                  duration = log_item.duration,
              })
          end
      end
      total_duration = total_duration + file_clocks.total_duration.minutes
    end
  end
  return HarvestClockReport:new({
    from = from,
    to = to,
    total_duration = Duration.from_minutes(total_duration),
    entries = entries,
  })
end

-- TODO Implement printing of time entries
function HarvestClockReport:print_table(start_line)
  local data = {
    {'File', 'Headline', 'Start', 'End', 'Duration'},
    'hr',
  }
  -- TODO: Sort entries by start time
  for _, entry in ipairs(self.entries) do
    table.insert(data, { entry.name, entry.title, entry.start_time, entry.end_time, entry.duration })
  end

  -- local clock_table = Table.from_list(data, start_line, 0):compile()

end

local credentials = vim.fn.json_decode(vim.fn.readblob("/Users/reecestevens/.vim/harvest-creds.json"))
local harvest_token = credentials.token
local harvest_account = credentials.account

local lookup_map = vim.fn.json_decode(vim.fn.readblob("/Users/reecestevens/.vim/harvest-maps.json"))


-- TODO: Listing of projects and tasks isn't working due to Harvest permissions reasons-- seems like you need
-- admin permissions to even list projects and tasks.
-- function HarvestClockReport:get_harvest_projects()
--   local project_response = curl.get({
--       url = 'https://api.harvestapp.com/v2/projects',
--       raw = {'-H', 'Harvest-Account-ID: ' .. harvest_account, "-H", "Authorization: Bearer " .. harvest_token},
--   })
--   local projects = vim.fn.json_decode(project_response.body)

--   local task_response = curl.get({
--       url = 'https://api.harvestapp.com/v2/tasks',
--       raw = {'-H', 'Harvest-Account-ID: ' .. harvest_account, "-H", "Authorization: Bearer " .. harvest_token},
--   })
--   local tasks = vim.fn.json_decode(task_response.body)
--   return {
--       projects = projects,
--       tasks = tasks,
--   }
-- end

local function tag_exists_for_entry(tag, entry)
    for _, entry_tag in ipairs(entry.tags) do
        if entry_tag == tag then
            return true
        end
    end
    return false
end

function HarvestClockReport.determine_entry_project_and_task(entry)
    local key = nil
    if entry.name == "aimetrics.org" then
        key = "aimetrics"
    elseif entry.name == "huxley.org" then
        key = "huxley"
    elseif entry.name == "general.org" then
        if tag_exists_for_entry("10x", entry) then
            key = "10x-time"
        elseif tag_exists_for_entry("management", entry) then
            key = "management"
        elseif tag_exists_for_entry("ops", entry) then
            key = "ops"
        end
    end

    if key == nil then
        print("No project found for " .. entry.name)
        return nil, nil
    end

    local id_table = lookup_map[key]
    if (id_table == nil) then
        print("No project found for " .. key)
        return nil, nil
    end
    return id_table.project_id, id_table.task_id
end

function HarvestClockReport:export_entry_to_harvest(entry)
    local project_id, task_id =  HarvestClockReport.determine_entry_project_and_task(entry)
    if project_id == nil or task_id == nil then
        print("No project or task found for %s. Skipping.", entry.title)
        return
    end
    local response = curl.post({
        url = 'https://api.harvestapp.com/v2/time_entries',
        raw = {'-H', 'Harvest-Account-ID: ' .. harvest_account, "-H", "Authorization: Bearer " .. harvest_token},
        body = {
            project_id = project_id,
            task_id = task_id,
            spent_date = entry.start_time:format("%Y-%m-%d"),
            started_time = entry.start_time:format("%I:%M%p"),
            ended_time = entry.end_time:format_time("%I:%M%p"),
            notes = entry.title:gsub("%[#[ABC]%] ", "")
        }
    })
    print("Time entry successfully created for %s: %s to %s", entry.title, entry.start_time:to_string(), entry.end_time:to_string())
    return response
end

function HarvestClockReport:export_to_harvest()
  for _, entry in ipairs(self.entries) do
    HarvestClockReport.export_entry_to_harvest(self, entry)
  end
end


-- TODO: print a table showing the entries that will be created
-- TODO: future work: prevent duplicate time entries from being created
-- TODO: Add "Dry run" functionality to print out tasks that will be created before publishing to Harvest
-- TODO: Add custom date range arguments to harvest report export

-- TODO: Export works, but for some reason not all general tasks are working -- people management and operations in particular isn't working
function _G.orgmode_harvest.harvestreport()
    local report = HarvestClockReport.from_date_range(Date.today():adjust("-3d"), Date.today());
    report:export_to_harvest()
    return report;
end

return {
    HarvestClockReport
}
