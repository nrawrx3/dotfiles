alias raxu="rsync -aAXu"
alias raxvu="rsync -aAXvu"

export EDITOR=nvim
HISTSIZE=8000

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl":$PATH

# The builds
export BUILD_DIR=$HOME/builds

export GOPATH=$HOME/go
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

# Time a process - requires the gnu time(1) command installed
timeit() {
    /usr/bin/time -f "Elapsed=%E, User=%U, Kernel=%S" $@
}

# Keep your heart-shaped-box updated!
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
    rsync_home .config
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
    systemctl poweroff
}

remind_me() {
    cat $HOME/dotfiles/.remember.txt
    python $HOME/dotfiles/random_quote.py
}

# The gits dir should be backed up using gits.py

remove_and_backup() {
    source $HOME/dotfiles/baklocs
    dir_path=${!1}
    if [ -z "$dir_path" ]; then
        echo "No such directory set"
        return
    fi
    home_dir_path=$HOME/$dir_path
    hsb_dir_path=$HSB/$dir_path
    echo "Removing - ${hsb_dir_path} and copying ${home_dir_path}"
    rm -rf $hsb_dir_path
    raxu $home_dir_path $HSB/
}

incr_backup() {
    source $HOME/dotfiles/baklocs
    dir_path=${!1}
    if [ -z "$dir_path" ]; then
        echo "No such directory set"
        return
    fi
    home_dir_path=$HOME/$dir_path
    hsb_dir_path=$HSB/$dir_path
    echo "Copying ${home_dir_path}"
    raxu $home_dir_path $HSB/
}

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
