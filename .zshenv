export EDITOR=vim

export THIRD_DIR=$HOME/code/third
export RAND_DIR=$HOME/code/rand
export NOTES_DIR=$HOME/code/notes

export GO_DIR=$RAND_DIR/go
export GOPATH=$GO_DIR
export GOSRC=$GOPATH/src

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
PATH=$PATH:$GO_DIR/bin

export PATH=$HOME/.local/bin:$PATH

export LLVM35=$RAND_DIR/llvm-src
export LLVM_WORK=$RAND_DIR/llvm_dir/live/work
export LLVM_SVN=$RAND_DIR/llvm_dir/live/llvm

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export CSCOPE_EDITOR="vim"

# Guile scheme extra libraries
export GUILE_LOAD_PATH="${HOME}/.local/share/my_guile_libs"


# For vte terminals
xvim () {
    export TERM=xterm-256color
    vim $1
}

# Functions

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

export PAGER=vimpager

#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

file_lowercase() {
    for f in `find`; do mv -v ./WORK/MAIN.C `echo ./WORK/MAIN.C | tr '[A-Z]' '[a-z]'`; done
}

echo "
                                                  /\\
                                                 /  \\ 
                                 /\\             /    \\
                                /  \\           /    /¯
           /\\_____   /\\_____   /    \\______   / ___/______   /\\_____
          /  \\_  ¬\\_/  \\_  ¬\\_/   ___\\___ ¬\\_/  \\__ ¬\\__ ¬\\_/  \\_  ¬\\_
         /____/    /    /    /    /    /    /    /    /    /    /____/
        /   ______/    /    /    /    /    /    /    /    /   ____/_
       /__  /    /__  /    /    /    /    /__  /    /    /__  /    /zS!
          \\_____/   \\_____/¯\\  /¯\\__/____/   \\_____/¯\\  /   \\_____/
                             \\/                       \\/

"

