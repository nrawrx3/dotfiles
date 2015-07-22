export EDITOR=vim

export LLVM_CHECK_DIR=~/text/code_repos/llvm
export LLVM_BUILD_DIR=~/builds/llvm
export GOPATH=~/go

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
PATH=$PATH:$GOPATH/bin

export PATH=$HOME/.local/bin:$PATH

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export CSCOPE_EDITOR="vim"

# Guile scheme extra libraries
export GUILE_LOAD_PATH="${HOME}/.local/share/my_guile_libs"

# Need to run python scripts but don't want to create .pyc files in the text
# dirs

export PYTHONDONTWRITEBYTECODE=1

export PAGER=vimpager


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

# My dear Toshiba hard drive
# You make it easier for me
# Without you grace
# Where would I fucking be
# Can you keep my knowledge with you
# I only do it for us both
# So take my heart for now too
# Rest of me will follow through

export HSB=/run/media/snyp/f6a9fbcb-7440-4cd7-b60b-4dbf1200eaed/snyp
export HSB1=/run/media/snyp/18378179-adf3-4dad-8336-8388ff71d8c5

remind_me() {
    cat ~/dotfiles/.remember.txt
    python ~/dotfiles/random_quote.py
}

