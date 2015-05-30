#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman='pacman --color auto'
alias liteide='liteide -style=gtk'
alias qpdfview='qpdfview -style=gtk'
alias tmux='tmux -2'
PS1='┌─(\u@\h \w)\n└─\$ '


# Colored man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# git bash completion script
. /usr/share/git/completion/git-completion.bash

export HISTSIZE=-1
export HISTFILESIZE=-1

export EDITOR=vim

export THIRD_DIR=$HOME/code/third
export RAND_DIR=$HOME/code/rand
export NOTES_DIR=$HOME/code/notes
export TOOLS_DIR="${HOME}/code/tools"

export GO_DIR=$RAND_DIR/go
export GOPATH=$GO_DIR
export GOROOT=/usr/lib/go

PATH=${PATH}:$GO_DIR/bin
PATH=$HOME/.local/bin:$PATH
export PATH

# For vte terminals
xvim () {
    export TERM=xterm-256color
    vim $1
}

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export CSCOPE_EDITOR="vim"

# Guile scheme extra libraries
export GUILE_LOAD_PATH="${HOME}/.local/share/my_guile_libs"

xkcd() {
  local search=
  for w in "$@"; do 
    search="$search+$w"
  done
  curl -sA Mozilla -i "http://www.google.com/search?hl=en&tbo=d&site=&source=hp&btnI=1&q=xkcd+$search" | awk '/Location: http/ {print $2}'
}
