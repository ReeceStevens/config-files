require('dap')
require('dapui').setup({
    controls = {
        element = "repl",
        enabled = false,
    }
})
require('dap-python').setup('~/.vim/python-virtual-env/nvim-venv/bin/python')

-- map dap continue to leader dc
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require"dap".continue()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require"dap".step_into()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require"dap".step_over()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>di', ':lua require"dapui".toggle()<CR>', {noremap = true, silent = true})
