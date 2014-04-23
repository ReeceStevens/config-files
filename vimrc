" settings for using Powerline
set nocompatible
set laststatus=2
set encoding=utf-8
set t_Co=256
filetype off

"setup for powerline
set rtp+=~/powerline/powerline/bindings/vim

" vundle and associated bundles
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'Valloric/YouCompleteMe'

filetype plugin indent on

" asthetic and typing preferences
colo molokai
set tabstop=4
set number
set backspace=2
syntax on
