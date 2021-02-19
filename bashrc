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
alias rdesktop='rdesktop -g 2560x1440 -K'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log'
alias gp='git push'
alias gb='git branch'
alias gw='git worktree'
alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove'
alias gch='git checkout'
alias gcp='git cherry-pick'

# Autocomplete
source ~/config-files/bash/autocomplete/git_autocomplete.bash

if hash __git_complete 2>/dev/null; then
    __git_complete gc _git_commit
    __git_complete ga _git_add
    __git_complete gb _git_branch
    __git_complete gm _git_merge
    __git_complete gd _git_diff
    __git_complete gw _git_worktree
    __git_complete gch _git_checkout
    __git_complete gcp _git_cherry_pick
fi

source ~/config-files/bash/autocomplete/fzf-completion.bash
source ~/config-files/bash/autocomplete/tmux.bash

command nodenv rehash 2>/dev/null

export GTK_THEME=Adwaita:dark
export EDITOR="nvim"
# export PYENV_ROOT="/home/reece/.pyenv"
# export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
export PATH="/home/reece/.nodenv/shims":$PATH
export PATH=$PATH:"/home/reece/bin"
export PATH=$PATH:"/home/reece/.mutt/bin"
export PATH=$PATH:"/home/reece/.local/bin"
export PATH=$PATH:"/home/reece/.cargo/bin"
export PATH=$PATH:"/home/reece/innolitics/bin"
export PATH=$PATH:"/home/reece/.gem/ruby/2.6.0/bin"
export PATH=$PATH:"/home/reece/.nodenv/bin"
export PATH=$PATH:"/usr/local/bin/aarch64-none-elf/bin"
export PATH=$PATH:"/home/reece/innolitics/mobius/tools/coffeescript-1.9.3/bin"
export PATH=$PATH:"/home/reece/innolitics/bin/osxcross/target/bin"
export LD_PATH=$LD_PATH:"/opt/cuda/include"
export LIBRARY_PATH=$LIBRARY_PATH:"/opt/cuda/include"
# export PATH=$PATH:"$PYENV_ROOT/bin"
# export RUST_SRC_PATH=~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
# export PYTHONPATH=$PYTHONPATH:"/usr/lib/python3.6/"
export ICAROOT="/home/reece/innolitics/bin/ICAClient/linuxx64"
# Fix issues with swing-based UIs not rendering properly in Wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_CURRENT_DESKTOP=sway
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Workaround to fix issue with displays not activating properly on Thunderbolt 3 dock.
# See https://github.com/swaywm/sway/issues/5843 for details
export WLR_DRM_NO_MODIFIERS=1

# Allow root to display on Wayland server
alias allow_root_display='xhost +SI:localuser:root'

GPG_TTY=$(tty)
export GPG_TTY

# Substitution script
function sub (){(ag -l $1 | xargs sed -i'' "s/$1/$2/g")}

wd () {
 directory=$1
 shift
 command="$@"
 excludes=$(find . -exec git check-ignore {} \; -exec echo -e {} "|" \; -prune)
 fswatch -0 -r -e "$excludes" $directory | xargs -0 -L 1 $command || true
}

startenv_innolitics() {
    project=$1
    source "/home/reece/innolitics/$project/$project-venv/bin/activate"
}
