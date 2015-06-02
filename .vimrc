" settings for using Vim-Powerline
set nocompatible
set laststatus=2
set encoding=utf-8
set t_Co=256
filetype off

"setup for powerline
set rtp+=~/powerline/powerline/bindings/vim

" vundle and associated bundles
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'Valloric/YouCompleteMe'
Plugin 'haya14busa/vim-easymotion'
Plugin 'tpope/vim-fugitive'
Plugin 'terryma/vim-multiple-cursors'

call vundle#end()

filetype plugin indent on

" Compile Latex documents (Mac version, opens in Preview)
command Latex execute "silent C!pdflatex % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!


" asthetic and typing preferences
colo molokai
set tabstop=4
set number
set backspace=2
syntax on
set mouse=a
set background=dark
set scrolloff=5
set expandtab


" Turn relative number on when scrolling
" and off while typing
autocmd InsertEnter * :set rnu!
autocmd InsertLeave * :set rnu
