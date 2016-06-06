"set nocompatible
set laststatus=2
set encoding=utf-8
let g:airline_powerline_fonts = 1
filetype off

"setup for powerline
"set rtp+=~/.vim/powerline/powerline/bindings/vim
set rtp+=~/.config/nvim/powerline/bindings/vim

" vundle and associated bundles
set rtp+=~/.config/nvim/bundle/Vundle.vim

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'Valloric/YouCompleteMe'
Plugin 'haya14busa/vim-easymotion'
Plugin 'tpope/vim-fugitive'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'vim-airline/vim-airline'
call vundle#end()

filetype plugin indent on


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
au Filetype *.py setlocal tw=79 "" For PEP8 compliance
" Compile and run python files by pressing <F9>
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

"" Markdown Options
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

"" C/C++ Options
"autocmd BufNewFile,BufRead,BufFilePre *.c let g:ycm_global_ycm_extra_conf="~/.vim/.ycm_extra_conf.py"
"autocmd BufNewFile,BufRead,BufFilePre *.cpp let g:ycm_global_ycm_extra_conf="~/.vim/.ycm_extra_conf.py"
"autocmd BufNewFile,BufRead,BufFilePre *.h let g:ycm_global_ycm_extra_conf="~/.vim/.ycm_extra_conf.py"

"" Latex Options
autocmd BufNewFile,BufRead,BufFilePre *.tex set spell 
" Fix constant redraw issue on Latex files
autocmd FileType *.tex setlocal nocursorline
" Compile Latex documents (Mac version, opens in Preview)
command Latex execute "silent !pdflatex % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!
