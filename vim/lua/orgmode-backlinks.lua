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
