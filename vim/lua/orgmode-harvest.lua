_G.orgmode_harvest = _G.orgmode_harvest or {}

require('orgmode')
local curl = require('plenary.curl')

local Files = require('orgmode.parser.files')
local Duration = require('orgmode.objects.duration')
local Date = require('orgmode.objects.date')
local ClockReport = require('orgmode.clock.report')

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

  local clock_report = ClockReport:new({
    from = from,
    to = to,
    files = Files.loader(),
  })

  for _, orgfile in ipairs(clock_report.files:all()) do
    local file_clocks = clock_report:_get_clock_report_for_file(orgfile)
    if #file_clocks.headlines > 0 then
      for _, headline in ipairs(file_clocks.headlines) do
          for _, log_item in ipairs(headline:get_logbook().items) do
              -- If log entry date occurs within the from and to range, include it in the entries list
              if log_item.start_time >= from and log_item.start_time <= to then
                  table.insert(entries, {
                      name = orgfile:get_category() .. '.org',
                      tags = headline:get_tags(),
                      title = headline:get_title(),
                      start_time = log_item.start_time,
                      end_time = log_item.end_time,
                      duration = log_item.duration,
                  })
              end
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

function HarvestClockReport.get_harvest_clients()
  local clients_response = curl.get({
      url = 'https://api.harvestapp.com/v2/clients',
      raw = {'-H', 'Harvest-Account-ID: ' .. harvest_account, "-H", "Authorization: Bearer " .. harvest_token},
  })
  return vim.fn.json_decode(clients_response.body)
end


function HarvestClockReport.get_harvest_projects(client_id)
  local project_response = curl.get({
      url = 'https://api.harvestapp.com/v2/projects?client_id=' .. client_id,
      raw = {'-H', 'Harvest-Account-ID: ' .. harvest_account, "-H", "Authorization: Bearer " .. harvest_token},
  })
  return vim.fn.json_decode(project_response.body)
end


function HarvestClockReport.get_tasks_for_project(project_id)
  local task_response = curl.get({
      url = 'https://api.harvestapp.com/v2/projects/' .. project_id .. '/task_assignments',
      raw = {'-H', 'Harvest-Account-ID: ' .. harvest_account, "-H", "Authorization: Bearer " .. harvest_token},
  })
  return vim.fn.json_decode(task_response.body)
end


local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local task_picker = function(project_id, opts)
    local tasks = HarvestClockReport.get_tasks_for_project(project_id)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Select Harvest Task for project " .. project_id,
        finder = finders.new_table {
            results = tasks["task_assignments"],
            entry_maker = function(entry)
                return {
                    value = entry["task"]["id"],
                    display = entry["task"]["name"],
                    ordinal = entry["task"]["name"],
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            print(vim.inspect(selection))
            vim.api.nvim_put({ "{ \"project_id\": \"" .. project_id .. "\", \"task_id\": \"" .. selection.value .. "\" }" }, "", false, true)
          end)
          return true
        end,
  }):find()
end

local project_picker = function(client_id, opts)
    local projects = HarvestClockReport.get_harvest_projects(client_id)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Select Harvest Project for client " .. client_id,
        finder = finders.new_table {
            results = projects["projects"],
            entry_maker = function(entry)
                return {
                    value = entry["id"],
                    display = entry["name"],
                    ordinal = entry["name"],
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            task_picker(selection.value)
          end)
          return true
        end,
  }):find()
end



local client_picker = function(opts)
  local clients = HarvestClockReport.get_harvest_clients()
  opts = opts or {}
  local result = pickers.new(opts, {
    prompt_title = "Select Harvest Client",
    finder = finders.new_table {
      results = clients["clients"],
      entry_maker = function(entry)
        return {
          value = entry["id"],
          display = entry["name"],
          ordinal = entry["name"],
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        project_picker(selection.value)
      end)
      return true
    end,
  }):find()
end


local function tag_exists_for_entry(tag, entry)
    if entry.tags == nil then
        return false
    end
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
    else
        if tag_exists_for_entry("10x", entry) then
            key = "10x-time"
        elseif tag_exists_for_entry("management", entry) then
            key = "management"
        elseif tag_exists_for_entry("ops", entry) then
            key = "ops"
        elseif tag_exists_for_entry("sales", entry) then
            key = "sales"
        elseif tag_exists_for_entry("marketing", entry) then
            key = "marketing"
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

function HarvestClockReport:export_entry_dry_run(entry)
    local project_id, task_id =  HarvestClockReport.determine_entry_project_and_task(entry)
    if project_id == nil or task_id == nil then
        return {
            error = "No project or task found for " .. entry.title,
            spent_date = entry.start_time:format("%Y-%m-%d"),
            started_time = entry.start_time:format("%I:%M%p"),
            ended_time = entry.end_time:format_time("%I:%M%p"),
            name = entry.name,
            tags = entry.tags,
        }
    end
    local post_body = {
            project_id = project_id,
            task_id = task_id,
            spent_date = entry.start_time:format("%Y-%m-%d"),
            started_time = entry.start_time:format("%I:%M%p"),
            ended_time = entry.end_time:format_time("%I:%M%p"),
            notes = entry.title:gsub("%[#[ABC]%] ", "")
        }
    return post_body
end

function HarvestClockReport:export_to_harvest(dry_run)
  if dry_run == true then
    local all_requests = {}
    for _, entry in ipairs(self.entries) do
      local check = entry.title
      table.insert(all_requests, self:export_entry_dry_run(entry))
    end
    local bufnr = vim.fn.bufadd('harvest-export.json')
    vim.fn.setbufvar(bufnr, "&filetype", "json")
    vim.fn.bufload(bufnr)
    vim.bo[bufnr].buflisted = true
    vim.fn.setbufline(bufnr, 1, vim.fn.json_encode(all_requests))
    return all_requests
  end

  for _, entry in ipairs(self.entries) do
    HarvestClockReport.export_entry_to_harvest(self, entry)
  end
end

-- TODO: print a table showing the entries that will be created
-- TODO: future work: prevent duplicate time entries from being created

function _G.orgmode_harvest.harvest_export(dry_run, start_date_offset, end_date_offset)
    local start = Date.now():adjust(start_date_offset):set({hour=0, min=0, sec=0})
    local finish = Date.now():adjust(end_date_offset):set({hour=23, min=59, sec=59})
    local report = HarvestClockReport.from_date_range(start, finish);
    report:export_to_harvest(dry_run)
end

-- Define vim command to export to Harvest
vim.api.nvim_create_user_command(
    "HarvestExport",
    function(opts)
        local start_date_offset = opts.fargs[1] or '0d'
        local end_date_offset = opts.fargs[2] or '0d'
        orgmode_harvest.harvest_export(false, start_date_offset, end_date_offset)
    end,
    { nargs = "*" }
)
vim.api.nvim_create_user_command(
    "HarvestDryRunExport",
    function(opts)
        local start_date_offset = opts.fargs[1] or '0d'
        local end_date_offset = opts.fargs[2] or '0d'
        orgmode_harvest.harvest_export(true, start_date_offset, end_date_offset)
    end,
    { nargs = "*" }
)

vim.api.nvim_create_user_command(
    "HarvestAddProject",
    function(opts)
        client_picker()
    end,
    { nargs = 0 }
)


return {
    HarvestClockReport
}
