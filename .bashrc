#
# ~/.bashrc
#

# Map caps lock to control
setxkbmap -option ctrl:nocaps

# Enable vi-like editing bindings
set -o vi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\[\e[0;32m\][\u@\h \[\e[1;34m\]\W\[\e[0;32m\]]\$\[\e[0m\] '

# PS1='\[\e]0;\w\a\]\[\033[01;34m\]\w\[\033[00m\]\$ '

alias vim='nvim'
alias tmux='tmux -2'
alias pcbartist='wine /home/reece/.wine/drive_c/Program\ Files\ \(x86\)/Advanced\ Circuits/PCB\ Artist/PCBArtist.exe'
alias open='xdg-open'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log'
alias gp='git push'
alias gb='git branch'
alias gch='git checkout'

# Autocomplete
source ~/.config/bash/autocomplete/git_autocomplete.bash

if hash __git_complete 2>/dev/null; then
    __git_complete gc _git_commit
    __git_complete ga _git_add
    __git_complete gb _git_branch
    __git_complete gm _git_merge
    __git_complete gd _git_diff
    __git_complete gch _git_checkout
    __git_complete gcp _git_cherry_pick
fi

export EDITOR="nvim"
export PATH=$PATH:"/home/reece/programs/MATLAB/bin"
export PATH=$PATH:"/home/reece/bin"
export PATH=$PATH:"/home/reece/.local/bin"
export RUST_SRC_PATH=~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
# export PYTHONPATH=$PYTHONPATH:"/usr/lib/python3.6/"

# Substitution script
function sub (){(ag -l $1 | xargs sed -i'' "s/$1/$2/g")}

wd () {
 directory=$1
 shift
 command="$@"
 # excludes=$(find . -exec git check-ignore {} \; -prune | while read line; do echo "-e $line"; done)
 excludes=$(find . -exec git check-ignore {} \; -exec echo -e {} \; -prune)
 fswatch -0 -r -o $directory $excludes | xargs -0 -L 1 $command || true
}

