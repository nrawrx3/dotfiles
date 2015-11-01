#PS1="\[\e[01;35m\]┌─(\u@\h)(\w)\[\e[01;35m\]\n\[\e[01;35m\]└──\[\e[01;35m\]──$\[\e[0m\] "
PS1="┌─(\u@\h)(\w)\n└────$ "

alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
alias grep="grep --color=auto"
alias la="ls -a"
alias ltr="ls -ltr"

export EDITOR=vim

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"

# The builds
export BUILD_DIR=$HOME/builds

# The checkouts
export CO_DIR=$HOME/co

export LLVM_BUILD_DIR=$BUILD_DIR/llvm

export LLVM_CO_DIR=$CO_DIR/llvm

export GOPATH=$HOME/go
PATH="$HOME/text/scripts":$PATH
PATH=$PATH:$GOPATH/bin
PATH=$PATH:$HOME/dotfiles

export PATH


export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export CSCOPE_EDITOR="vim"

export PACMAN_CACHE="/var/cache/pacman/pkg"

# Functions

# The sounds of silence often soothe
# Shapes and colors shift with mood
# Pupils widen change their hue
# Rapid brown avoids clear blue (Frogs - Alice in Chains)
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

# XKCD searcher by @sudokode in #archlinux
xkcd() {
  local search=
  for w in "$@"; do
    search="$search+$w"
  done
  curl -sA Mozilla -i "http://www.google.com/search?hl=en&tbo=d&site=&source=hp&btnI=1&q=xkcd+$search" | awk '/Location: http/ {print $2}'
}

# She eyes me like a Pisces when I am weak
# I've been locked inside your heart shaped box for weeks (Heart Shaped Box - Nirvana)

export HSB=/run/media/snyp/f6a9fbcb-7440-4cd7-b60b-4dbf1200eaed/snyp
export HSB1=/run/media/snyp/18378179-adf3-4dad-8336-8388ff71d8c5

rsync_home() {
  dirname=$1
  rsync -aAXvu $HOME/$dirname $HSB/
}

rsync_paccache() {
  sudo bash -c "rsync -aAXvu ${PACMAN_CACHE}/* $HSB1/var/cache/pacman/pkg/"
}

remind_me() {
    cat $HOME/dotfiles/.remember.txt
    python $HOME/dotfiles/random_quote.py
}

