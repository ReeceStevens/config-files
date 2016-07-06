" vim config TODO
" 1. Get virtualenv support working
" 2. Automatic switching between python2 and python3 semantic completion?
"	(may be taken care of if issue #1 is fixed)

" Typing preferences and asthetics
colo molokai
set tabstop=4
set shiftwidth=4
set softtabstop=4
set number
set rnu
set backspace=2
syntax on
set mouse=a
set background=dark
set scrolloff=5
set noexpandtab
set cursorline
let mapleader=","

" YCM preferences
let g:python_host_prog = '/usr/bin/python' " Virtualenv workaround
let g:ycm_python_binary_path = '/usr/local/bin/python3'

set laststatus=2
set encoding=utf-8
let g:airline_powerline_fonts = 1
filetype off

" vundle and associated bundles
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Extend Vim's default scripts
Plugin 'L9'

" Enable fuzzy searching
Plugin 'FuzzyFinder'

" The all-powerful completion engine
Plugin 'Valloric/YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Double-leader for suggested jumps instead of numbers
Plugin 'haya14busa/vim-easymotion'

" The all-powerful git plugin
Plugin 'tpope/vim-fugitive'

" Statusline
Plugin 'vim-airline/vim-airline'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#whitespace#enabled = 0

Plugin 'tpope/vim-commentary'
Plugin 'leafgarland/typescript-vim'

" Handle virtualenv gracefully
Plugin 'jmcantrell/vim-virtualenv'
let g:virtualenv_directory = '/Users/reecestevens/innolitics/dicom-standard-browser/'

"Handle syntax support and PEP8 compliance
Plugin 'scrooloose/syntastic'
let g:syntastic_stl_format = '[%E{Err: %e}%B{, }%W{Warn: %w}]'
Plugin 'nvie/vim-flake8'
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" Show the current working directory in a nice tree
Plugin 'scrooloose/nerdtree'
noremap <silent> <leader>1 :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\~$', '\.pyc', '__pycache__']
let NERDTreeMapHelp = '<f1>'

" Show the ctags in a file
Plugin 'majutsushi/tagbar.git'
let g:tagbar_iconchars = ['+', '-']
noremap <silent> <leader>2 :TagbarToggle<CR>

" View the current buffers
Plugin 'corntrace/bufexplorer'
noremap <silent> <leader>3 :BufExplorer<CR>
let g:bufExplorerDefaultHelp=0

" View the undo/redo tree in a graphical format
Plugin 'sjl/gundo.vim.git'
nnoremap <silent> <leader>4 :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_help  = 0

call vundle#end()
filetype plugin indent on

" Switch colon and semicolon
nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

" Move around long lines as break lines
nnoremap j gj
nnoremap k gk

" Remap ESC to jk in quick succession
inoremap jk <ESC>
inoremap kj <ESC>
inoremap <ESC> <nop>

" For finger fumbling (thanks pato)
command! W w
command! Wq wq
command! WQ wq
command! Q q
command! Wa wa
command! WA wa

" Eclim Settings
"let g:EclimCompletionMethod = 'omnifunc'

" Turn relative number on when scrolling
" and off while typing
autocmd InsertEnter * :set rnu!
autocmd InsertLeave * :set rnu

"" Filetype Specific Settings

"" GITCOMMIT Options
au FileType gitcommit setlocal tw=72

"" Python Options
autocmd FileType *.py set expandtab
autocmd Filetype *.py setlocal tw=79 "" For PEP8 compliance

" Compile and run python files by pressing <F9>
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

"" Markdown Options
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

au BufNewFile,BufFilePre,BufRead Jenkinsfile set filetype=groovy

"" Latex Options
autocmd BufNewFile,BufRead,BufFilePre *.tex set spell
" Fix constant redraw issue on Latex files
autocmd FileType *.tex setlocal nocursorline
" Compile Latex documents (Mac version, opens in Preview)
command Latex execute "silent !pdflatex % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!

" TODO: Is there a bettery way of detecting virtualenv besides
" running this python script with the call to execfile?
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
	project_base_dir = os.environ['VIRTUAL_ENV']
	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
	execfile(activate_this, dict(__file__=activate_this))
EOF

