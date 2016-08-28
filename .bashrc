# ~/.bashrc

PS1="┌─(\u@\h)(\w)\n└────$ "

alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
alias grep="grep --color=auto"
alias la="ls -a"
alias ll="ls -l"
alias ltr="ls -ltr"
alias cl="clear"
alias raxu="rsync -aAXu"
alias raxvu="rsync -aAXvu"

export EDITOR=nvim
HISTSIZE=-1

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl":$PATH

# The builds
export BUILD_DIR=$HOME/builds

export GOPATH=$HOME/go
export SBT_HOME=$HOME/sbt

PATH=$PATH:$GOPATH/bin
PATH=$HOME/.local/bin:$PATH
export PATH


export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export CSCOPE_EDITOR="vim"

export PACMAN_CACHE="/var/cache/pacman/pkg"

# Functions
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

replace_string () {
    from=$1
    to=$2
    shift
    shift
    files=("${@}")

    echo $files

    for f in $files;
        do perl -i -p -e "s/$from/$to/g" $f
    done
}


# Updates submodules in the repo
git_sub_update() {
  git submodule update --init --recursive
}

# XKCD searcher by @sudokode in #archlinux
xkcd() {
  local search=
  for w in "$@"; do
    search="$search+$w"
  done
  curl -sA Mozilla -i "http://www.google.com/search?hl=en&tbo=d&site=&source=hp&btnI=1&q=xkcd+$search" | awk '/Location: http/ {print $2}'
}

export HSB=/run/media/snyp/2763c3c1-08fe-4fcd-aaa7-7837b8cad829/snyp

rsync_home() {
  dirname=$1
  rsync -aAXvu $HOME/$dirname $HSB/
}

rsync_paccache() {
  sudo bash -c "rsync -aAXvu ${PACMAN_CACHE}/* $HSB/pacman_cache/"
}

rsync_all() {
  rsync_home text
  rsync_home reads
  rsync_home images
  rsync_home music
  rsync_home videos
  rsync_home .fonts
  rsync_home theming
  rsync ~/.config/llpp.conf $HSB/.config/llpp.conf -aAXvu
  if [[ $HOSTNAME -eq "mace" ]]; then
    rsync_paccache
  fi
}

bak_all() {
  rsync_all
  gits.py --pull_all
}

# Backup and shutdown
baksdown() {
	rsync_all
	gits.py --pull_all
	systemctl shutdown
}

remind_me() {
    cat $HOME/dotfiles/.remember.txt
    python $HOME/dotfiles/random_quote.py
}

