require('orgmode')

local OrgApi = require("orgmode.api")
local Files = require("orgmode.parser.files")

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

function OrgJumpToLink()
    Files.all()
    local line = vim.api.nvim_get_current_line()
    -- TODO handle multiple links on one line by jumping to the one the cursor is on
    local id = string.match(line, "%[%[id:([%d%a-]+)%]%[.*%]%]")
    local matching_headlines = Files.find_headlines_with_property_matching("ID", id)
    if #matching_headlines == 0 then
        print("No headline with ID " .. id .. " found")
        return
    end
    -- get the first headline with the matching ID
    local headline = matching_headlines[1]
    vim.cmd('edit ' .. headline.file.filename)
    vim.fn.cursor({headline:get_range().start_line, 1})
    vim.cmd([[normal! zv]])
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
vim.api.nvim_create_user_command(
    "OrgJumpToLink",
    function()
        return OrgJumpToLink()
    end,
    { nargs = 0 }
)
