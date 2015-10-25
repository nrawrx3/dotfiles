export EDITOR=vim

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
PATH="$HOME/text/scripts":$PATH
PATH=$PATH:$GOPATH/bin
PATH=$PATH:$HOME/text/scripts

export PATH

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export CSCOPE_EDITOR="vim"

export PACMAN_CACHE="/var/cache/pacman/pkg"

# Guile scheme extra libraries
export GUILE_LOAD_PATH="${HOME}/text/code/guile"
export GUILE_LOAD_COMPILED_PATH="${HOME}/mixed/misc/guile_compiled"

# Need to run python scripts but don't want to create .pyc files in the text
# dirs (NAH...)

##export PYTHONDONTWRITEBYTECODE=1

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

# Project names and upstream URLS

## KEEP THIS UPDATED YOU FOOL!

typeset -A name_to_url
name_to_url=(llvm "https://github.com/llvm-mirror/llvm.git"
       clang "https://github.com/llvm-mirror/clang.git"
       libjit "git://git.savannah.gnu.org/libjit.git"
       libbsd "git://anongit.freedesktop.org/git/libbsd"
       luajit-2.0 "http://luajit.org/git/luajit-2.0.git"
       toml "https://github.com/toml-lang/toml.git"
       cpython "https://github.com/python/cpython"
       gpm "https://github.com/pote/gpm.git"
       earnestly "https://github.com/Earnestly/pkgbuilds.git"
       scaffold "https://snyp@bitbucket.org/snyp/scaffold.git"
       regvm "https://snyp@bitbucket.org/snyp/regvm.git"
       musl "git://git.musl-libc.org/musl"
       llvm-clang-samples "https://github.com/eliben/llvm-clang-samples.git"
       termbox "https://github.com/nsf/termbox.git"
       llvm-leg "https://github.com/codeplaysoftware/llvm-leg"
)

# Removing some repositories

# ocaml-makefile "https://github.com/mmottl/ocaml-makefile.git"
# khinsider "https://github.com/obskyr/khinsider.git"
# Managing git repositories with 

# It's GITS_DIR not GIT_DIR!! Otherwise git will begin using this value in the commands
export GITS_DIR=gits
export INTERNAL_GITS_DIR=$HOME/$GITS_DIR
export EXTERNAL_GITS_DIR=$HSB/$GITS_DIR

# $HSB's $GITS_DIR/<PROJECT> have each a 'backup' remote which is set to
# $INTERNAL_GITS_DIR/<PROJECT>

# Pull **each** repo from the backup remote
git_backup_pull_all() {
  # $1 is the directory to backup
  for d in $(ls ${EXTERNAL_GITS_DIR}); do
    echo "Pulling remote of ${INTERNAL_GITS_DIR}/${d} at ${EXTERNAL_GITS_DIR}/${d}"
    echo "cd $EXTERNAL_GITS_DIR/$d"
    cd $EXTERNAL_GITS_DIR/$d
    echo "git pull backup master"
    git pull backup master
    echo "---------------------"
  done
  cd $HOME
}

# When cloning from $HSB/$GITS_DIR/<PROJECT>, the origin remote is set to
# $HSB/$GITS_DIR/<PROJECT>. So we need to restore origin remote

git_backup_init_one() {
  d=$1
  cd $EXTERNAL_GITS_DIR
  echo "Creating backup remote of ${INTERNAL_GITS_DIR}/${d} at ${EXTERNAL_GITS_DIR}/${d}"
  echo "git clone $INTERNAL_GITS_DIR/$d"
  git clone $INTERNAL_GITS_DIR/$d
  echo "cd $EXTERNAL_GITS_DIR/$d"
  cd $EXTERNAL_GITS_DIR/$d
  echo "pwd: " `pwd`
  git remote rm origin
  echo "git remote add origin $name_to_url[$d]"
  git remote add origin $name_to_url[$d]
  echo "git remote add backup ${INTERNAL_GITS_DIR}/${d}"
  git remote add backup ${INTERNAL_GITS_DIR}/${d}
  cd $EXTERNAL_GITS_DIR
  echo "---------------------"
  cd $HOME
}

# Create a backup remote for **each** directory in the $GITS_DIR for the first time
git_backup_init_all() {
  cd $EXTERNAL_GITS_DIR
  for d in $(ls ${INTERNAL_GITS_DIR}); do
    echo "Creating backup remote of ${INTERNAL_GITS_DIR}/${d} at ${EXTERNAL_GITS_DIR}/${d}"
    echo "git clone $INTERNAL_GITS_DIR/$d"
    git clone $INTERNAL_GITS_DIR/$d
    echo "cd $EXTERNAL_GITS_DIR/$d"
    cd $EXTERNAL_GITS_DIR/$d
    echo "pwd: " `pwd`
    git remote rm origin
    echo "git remote add origin $name_to_url[$d]"
    git remote add origin $name_to_url[$d]
    echo "git remote add backup ${INTERNAL_GITS_DIR}/${d}"
    git remote add backup ${INTERNAL_GITS_DIR}/${d}
    cd $EXTERNAL_GITS_DIR
    echo "---------------------"
  done
  cd $HOME
}



print_git_urls() {
  for k in "${(@k)name_to_url}"; do
      echo "$k -> $name_to_url[$k]"
  done
}

remove_default_origin_and_add_upstream_in_host_all() {
  for k in "${(@k)name_to_url}"; do
    echo "$k -> $name_to_url[$k]"
    echo "cd $INTERNAL_GITS_DIR/$k"
    cd $INTERNAL_GITS_DIR/$k
      echo "git remote rm origin"
      git remote rm origin

      echo "git remote add origin $name_to_url[$k]"
      git remote add origin $name_to_url[$k]

      cd $HOME
      echo "----------------------"
    done
}

remove_default_origin_and_add_upstream_in_hsb_all() {
  for k in "${(@k)name_to_url}"; do
    echo "$k -> $name_to_url[$k]"
    echo "cd $EXTERNAL_GITS_DIR/$k"
    cd $EXTERNAL_GITS_DIR/$k
      echo "git remote rm origin"
      git remote rm origin

      echo "git remote add origin $name_to_url[$k]"
      git remote add origin $name_to_url[$k]

      cd $HOME
      echo "----------------------"
    done
}

# The builds
export BUILD_DIR=$HOME/builds

# The checkouts
export CO_DIR=$HOME/co

export LLVM_BUILD_DIR=$BUILD_DIR/llvm

export LLVM_CO_DIR=$CO_DIR/llvm

export GOPATH=$HOME/go

export PATH=$GOPATH:$PATH

