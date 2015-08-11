export EDITOR=vim

export LLVM_CHECK_DIR=~/text/code_repos/llvm
export LLVM_BUILD_DIR=~/builds/llvm
export GOPATH=~/go

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
PATH="$HOME/text/scripts":$PATH
PATH=$PATH:$GOPATH/bin

export PATH=$HOME/.local/bin:$PATH

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export CSCOPE_EDITOR="vim"

export PACMAN_CACHE="/var/cache/pacman/pkg"

# Guile scheme extra libraries
export GUILE_LOAD_PATH="${HOME}/.local/share/my_guile_libs"

# Need to run python scripts but don't want to create .pyc files in the text
# dirs

export PYTHONDONTWRITEBYTECODE=1

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

# She eyes me like a Pisces when I am weak
# I've been locked inside your heart shaped box for weeks

export HSB=/run/media/snyp/f6a9fbcb-7440-4cd7-b60b-4dbf1200eaed/snyp
export HSB1=/run/media/snyp/18378179-adf3-4dad-8336-8388ff71d8c5

rsync_home() {
  dirname=$1
  rsync -aAXvu ~/$dirname $HSB/
}

rsync_paccache() {
  sudo bash -c "rsync -aAXvu ${PACMAN_CACHE}/* $HSB1/var/cache/pacman/pkg/"
}

remind_me() {
    cat ~/dotfiles/.remember.txt
    python ~/dotfiles/random_quote.py
}

# It's GITS_DIR not GIT_DIR!! Otherwise git will begin using this value in the commands
export GITS_DIR=gits
export INTERNAL_GITS_DIR=$HOME/$GITS_DIR
export EXTERNAL_GITS_DIR=$HSB/$GITS_DIR

# Pull **each** repo from the backup remote
git_backup_pull_all() {
  # $1 is the directory to backup
  for d in $(ls ${EXTERNAL_GITS_DIR}); do
    echo "Pulling remote of ${INTERNAL_GITS_DIR}/${d} at ${EXTERNAL_GITS_DIR}/${d}"
    echo "cd $EXTERNAL_GITS_DIR/$d"
    cd $EXTERNAL_GITS_DIR/$d
    echo "git pull backup master"
    git pull backup master
    #git pull backup master
    echo "---------------------"
  done
  cd $HOME
}

git_backup_init_one() {
  d=$1
  cd $EXTERNAL_GITS_DIR
  echo "Creating backup remote of ${INTERNAL_GITS_DIR}/${d} at ${EXTERNAL_GITS_DIR}/${d}"
  echo "git clone $INTERNAL_GITS_DIR/$d"
  git clone $INTERNAL_GITS_DIR/$d
  echo "cd $EXTERNAL_GITS_DIR/$d"
  cd $EXTERNAL_GITS_DIR/$d
  echo "pwd: " `pwd`
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
    echo "git remote add backup ${INTERNAL_GITS_DIR}/${d}"
    git remote add backup ${INTERNAL_GITS_DIR}/${d}
    # Just a test
    #git pull backup master
    cd $EXTERNAL_GITS_DIR
    echo "---------------------"
  done
  cd $HOME
}