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

runtime viml/text-config.vim

" Use a controlled virtual environment for the host python
let g:python3_host_prog = $HOME . '/.vim/python-virtual-env/nvim-venv/bin/python'

runtime viml/plugins.vim
runtime viml/keybindings.vim

runtime lua/lsp.lua
runtime lua/orgmode-config.lua
runtime lua/autocomplete.lua

runtime lua/local-config.lua

let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

runtime viml/filetype-specific.vim
