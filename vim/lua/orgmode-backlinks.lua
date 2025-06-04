require('orgmode')

local OrgApi = require("orgmode.api")

function GetOrCreateIdForCurrentHeadline()
    local current_file = OrgApi.current()
    local current_headline = current_file:get_closest_headline(vim.api.nvim_win_get_cursor(0))
    return current_headline:id_get_or_create()
end

function OrgStoreLink()
    local current_file = OrgApi.current()
    local current_headline = current_file:get_closest_headline(vim.api.nvim_win_get_cursor(0))
    local id = current_headline:id_get_or_create()
    local link = "[[id:" .. id .."][" .. current_headline.title .. "]]"
    -- copy link to register
    vim.fn.setreg("+", link)
end

vim.api.nvim_create_user_command(
    "GetOrCreateIdForCurrentHeadline",
    function()
        return GetOrCreateIdForCurrentHeadline()
    end,
    { nargs = 0 }
)
vim.api.nvim_create_user_command(
    "OrgStoreLink",
    function()
        return OrgStoreLink()
    end,
    { nargs = 0 }
)

-- pass the selected range of text into pandoc to convert it to markdown, then save to
-- clipboard
vim.api.nvim_create_user_command(
    "PandocConvertToMarkdown",
    function(opts)
        -- Get the start and end positions of the range
        local start_line = opts.line1
        local end_line = opts.line2

        -- Get the selected text from the buffer
        local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        local selected_text = table.concat(selected_lines, '\n')

        -- Escape single quotes in the text to prevent shell interpretation issues
        selected_text = selected_text:gsub("'", "'\\''")

        local pandoc_command = "echo '" .. selected_text .. "' | pandoc -f org -t markdown"
        local markdown_text = vim.fn.system(pandoc_command)
        vim.fn.setreg("+", markdown_text)
    end,
    { range = true }
)

vim.api.nvim_set_keymap('v', '<leader>cp', ':PandocConvertToMarkdown<CR>', { noremap = true, silent = true })

local function determine_refile_location(headline)
    -- Determine destination based on tags
    local refile_map = vim.fn.json_decode(vim.fn.readblob("/Users/reecestevens/.vim/harvest-maps.json"))
    local tags = headline.tags
    if not tags or #tags == 0 then
        print("No tags found for the current headline.")
        return
    end

    local key = nil
    for _, entry_tag in ipairs(tags) do
        if refile_map[entry_tag] ~= nil then
            key = entry_tag
            break
        end
    end

    -- Manual overrides
    if headline.title == "Josh Sync" and key == "management" then
        return "work/management/josh-tzucker.org"
    elseif headline.title == "Matt Sync" and key == "management" then
        return "work/management/matt-hancock.org"
    elseif headline.title == "Ethan Sync" and key == "management" then
        return "work/management/ethan-ulrich.org"
    elseif headline.title == "Bimba Sync" and key == "management" then
        return "work/management/bimba-shrestha.org"
    elseif headline.title == "Kris Sync" and key == "management" then
        return "work/management/kris-huang.org"
    elseif not key or not refile_map[key].refile then
        return "work/general.org"
    else
        -- Use the refile map to determine the destination file
        return refile_map[key].refile
    end
end

function OrgAutoRefile()
    local current_file = OrgApi.current()
    local current_headline = current_file:get_closest_headline(vim.api.nvim_win_get_cursor(0))
    local refile_destination = determine_refile_location(current_headline)

    local destination_file = OrgApi.load(refile_destination)

    if not destination_file then
        print("Could not load destination file: " .. refile_destination)
        return
    end

    OrgApi.refile({
        source = current_headline,
        destination = destination_file,
    }):next(function(success)
        if success then
            print("Refiled successfully to " .. refile_destination)
        else
            print("Refile failed.")
        end
    end)

end

vim.api.nvim_create_user_command(
    "OrgAutoRefile",
    function()
        return OrgAutoRefile()
    end,
    { nargs = 0 }
)

vim.api.nvim_set_keymap('n', '<leader>oR', ':OrgAutoRefile<CR>', { noremap = true, silent = true })
