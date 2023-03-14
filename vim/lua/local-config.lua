-- Allow project-specific vim configuration
vim.opt.secure = true
vim.opt.exrc = true

-- Source local project-specific vim configurations
local local_vimrc = vim.fn.getcwd()..'/.nvimrc'
if vim.loop.fs_stat(local_vimrc) then
  vim.cmd('source '..local_vimrc)
end

