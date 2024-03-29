-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = {"~/innolitics/notes/org-notes/*.org", "~/innolitics/notes/org-notes/work/*.org"},
  org_default_notes_file = '~/innolitics/notes/org-notes/refile.org',
  org_todo_keywords = {'TODO', 'IN_PROGRESS', 'BLOCKED', 'DONE'},
  org_capture_templates = {
    t = { description = 'Task', template = '** TODO %?\n  %u' },
    m = {
      description = 'Meeting',
      template = '** %?\n  %u\n\n*** Notes\n\n\n*** Action Items\n\n\n' }
  },
  org_indent_mode = "indent",
  org_todo_keyword_faces = {
    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
    IN_PROGRESS = ':foreground orange', -- overrides builtin color for `TODO` keyword
    DONE = ':foreground green :weight bold', -- overrides builtin color for `TODO` keyword
  },
  calendar_week_start_day = 0,
})

-- Custom lua plugin for exporting to Harvest
require('orgmode-harvest')

vim.api.nvim_set_hl(0, 'OrgAgendaDeadline', {link = 'Error'})
vim.api.nvim_set_hl(0, 'OrgAgendaScheduled', {link = 'Function'})
vim.api.nvim_set_hl(0, 'OrgAgendaScheduledPast', {link = 'DiagnosticWarn'})

vim.api.nvim_set_hl(0, 'OctoEditable', {bg = "#1B1D1F"})

-- To conceal org hyperlinks, which can be somewhat verbose
vim.opt.conceallevel = 1
