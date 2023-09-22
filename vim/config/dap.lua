local dap = require('dap')
require('dapui').setup({
    controls = {
        element = "repl",
        enabled = false,
    }
})
require('dap-python').setup('~/.vim/python-virtual-env/nvim-venv/bin/python')
-- Disabling virtualtext since it seems to be interfering with copilot plugin
require("nvim-dap-virtual-text").setup()

dap.adapters.firefox = {
  type = 'executable',
  command = '/Users/reecestevens/.nodenv/versions/16.13.2/bin/node',
  args = {os.getenv('HOME') .. '/.vim/vscode-firefox-debug/dist/adapter.bundle.js'},
}

vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require"dap".continue()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dB', ':lua require"dap".toggle_breakpoint(vim.fn.input(\'Breakpoint condition: \'))<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require"dap".step_into()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require"dap".step_over()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>di', ':lua require"dapui".toggle()<CR>', {noremap = true, silent = true})


-- Example configuration for firefox debugging. Project-specific configurations should
-- go in their local .nvimrc file.
--
-- dap.configurations["typescript.tsx"] = {
--   {
--     name = 'Debug with Firefox',
--     type = 'firefox',
--     request = 'launch',
--     reAttach = true,
--     url = 'http://localhost:3000',
--     firefoxExecutable = '/Applications/Firefox.app/Contents/MacOS/firefox',
--     webRoot = '${workspaceFolder}',
--   }
-- }
