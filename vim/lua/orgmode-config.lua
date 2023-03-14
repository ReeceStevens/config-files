-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = {"~/innolitics/notes/org-notes/*.org"},
  org_default_notes_file = '~/innolitics/notes/org-notes/work.org',
  org_todo_keywords = {'TODO', 'IN_PROGRESS', 'BLOCKED', 'DONE'},
  org_capture_templates = {
    t = { description = 'Task', template = '** TODO %?\n  %u' },
    m = {
      description = 'Meeting',
      template = '** %?\n  %u\n\n*** Agenda\n\n\n*** Notes\n\n\n*** Action Items\n\n\n' }
  },
  org_indent_mode = "noindent",
  org_todo_keyword_faces = {
    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
    IN_PROGRESS = ':foreground orange', -- overrides builtin color for `TODO` keyword
    DONE = ':foreground green :weight bold', -- overrides builtin color for `TODO` keyword
  },
  calendar_week_start_day = 0,
})

vim.api.nvim_set_hl(0, 'OrgAgendaDeadline', {link = 'Error'})
vim.api.nvim_set_hl(0, 'OrgAgendaScheduled', {link = 'Function'})
vim.api.nvim_set_hl(0, 'OrgAgendaScheduledPast', {link = 'DiagnosticWarn'})