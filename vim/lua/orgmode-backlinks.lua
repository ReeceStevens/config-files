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
