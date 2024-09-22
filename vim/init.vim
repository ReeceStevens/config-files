" Use a controlled virtual environment for the host python
let g:python3_host_prog = $HOME . '/.vim/python-virtual-env/nvim-venv/bin/python'

colo molokai
syntax on
set mouse=a
set laststatus=2
set encoding=utf-8
if has("termguicolors")
    set termguicolors
endif
" Make search case-insensitive, unless searching with upper-case characters
set ignorecase
set smartcase

runtime config/text-config.vim
runtime config/plugins.vim
runtime config/keybindings.vim

runtime config/lsp.lua
runtime config/orgmode-config.lua
" runtime config/autocomplete.lua
runtime config/dap.lua

runtime config/local-config.lua

let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

runtime config/filetype-specific.vim
