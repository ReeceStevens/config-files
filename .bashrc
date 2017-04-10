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


export EDITOR="nvim"
export PATH=$PATH:"/home/reece/programs/MATLAB/bin"
export PATH=$PATH:"/home/reece/bin"
export PATH=$PATH:"/home/reece/.local/bin"
export RUST_SRC_PATH=~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src

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

