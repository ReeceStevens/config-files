#! /usr/bin/env bash

# TODO Make these configurations resilient in the event that files already exist
ln -s ~/config-files/bashrc ~/.bashrc
ln -s ~/config-files/bash ~/.bash
ln -s ~/config-files/tmux.conf ~/.tmux.conf
ln -s ~/config-files/gdbinit ~/.gdbinit
ln -s ~/config-files/alacritty.yml ~/.config/alacritty/alacritty.yml

ln -s ~/config-files/vim ~/.config/nvim

# TODO: Install vim plug

vim +PlugUpgrade +qall
vim +PlugInstall +qall
