" settings for using Vim-Powerline
set nocompatible
set laststatus=2
set encoding=utf-8
set t_Co=256
filetype off

" vundle and associated bundles
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Lokaltog/vim-powerline'

filetype plugin indent on

" asthetic and typing preferences
colorscheme elflord
set tabstop=4
set number
set backspace=2

" final powerline configurations
let g:Powerline_symbols = 'fancy'

set guifont=Droid\ Sans\ Mono\ for\ Powerline

