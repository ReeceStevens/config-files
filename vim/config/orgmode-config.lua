require('orgmode').setup({
  org_agenda_files = {
    "~/innolitics/notes/org-notes/*.org",
    "~/innolitics/notes/org-notes/work/*.org",
    "~/innolitics/notes/org-notes/org-roam/**/*",
    "~/innolitics/notes/org-notes/work/management/*.org",
  },
  org_default_notes_file = '~/innolitics/notes/org-notes/refile.org',
  org_todo_keywords = {'TODO', 'IN_PROGRESS', 'BLOCKED', 'DONE'},
  org_capture_templates = {
    t = {
        description = 'Task',
        template = '* TODO %?\nSCHEDULED: %t\n:PROPERTIES:\n:CREATED_ON: %u\n:END:',
        properties = { empty_lines = 1 } },
  },
  org_startup_indented = false,
  org_startup_folded = 'showeverything',
  org_adapt_indentation = false,
  org_todo_keyword_faces = {
    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
    IN_PROGRESS = ':foreground orange', -- overrides builtin color for `TODO` keyword
    DONE = ':foreground green :weight bold', -- overrides builtin color for `TODO` keyword
  },
  calendar_week_start_day = 0,
})

require("org-roam").setup({
  directory = "~/innolitics/notes/org-notes/org-roam",
  bindings = {
    prefix = "<LocalLeader>n",
  },
})

-- Custom lua plugin for exporting to Harvest
require('orgmode-harvest')
require('orgmode-backlinks')

vim.api.nvim_set_hl(0, '@org.agenda.deadline', {link = 'Error'})
vim.api.nvim_set_hl(0, '@org.agenda.scheduled', {link = 'Function'})
vim.api.nvim_set_hl(0, '@org.agenda.scheduled_past', {link = 'DiagnosticWarn'})
vim.api.nvim_set_hl(0, 'OctoEditable', {bg = "#1B1D1F"})

-- To conceal org hyperlinks, which can be somewhat verbose
--autocmd BufRead,BufNewFile *.txt setfiletype text
vim.api.nvim_create_autocmd(
    {"BufRead", "BufNewFile"}, {
        pattern = {"*.org"},
        command = "setlocal conceallevel=1",
    }
)

vim.cmd [[highlight Headline1 guibg=#1e2718]]
vim.cmd [[highlight Headline2 guibg=#21262d]]
vim.cmd [[highlight CodeBlock guibg=#242424]]
vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]

-- `headlines` is disabled due to significant performance issues
-- when viewing and editing large org files
-- require("headlines").setup {
--     org = {
--         headline_highlights = { "Headline1", "Headline2" },
--         codeblock_highlight = "CodeBlock",
--         fat_headlines = false,
--         bullets = {},
--     },
-- }

-- vim.opt.conceallevel = 1
