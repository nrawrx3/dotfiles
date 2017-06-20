# ~/.bashrc

export PS1="\[$(tput setaf 2)\]┌─╼ \[$(tput setaf 6)\][\w]\n\[$(tput setaf 1)\]\$(if [[ \$? == 0 ]]; then echo \"\[$(tput setaf 1)\]└────╼\"; else echo \"\[$(tput setaf 1)\]└╼\"; fi) \[$(tput setaf 7)\]"

# It's dangerous to go alone, take these aliases
alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
alias grep="grep --color=auto"
alias la="ls -a"
alias ll="ls -l"
alias ltr="ls -ltr"
alias cl="clear"
alias raxu="rsync -aAXu"
alias raxvu="rsync -aAXvu"
alias up="cd .."
alias upp="cd ../.."
alias uppp="cd ../../.."

source /etc/profile.d/vte.sh

export EDITOR=nvim
HISTSIZE=-1

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl":$PATH

# The builds
export BUILD_DIR=$HOME/builds

export GOPATH=$HOME/samples/go

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

# Replaces a string with another string in the given files
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

PACKAGE_LIST_FILE="package_list"

store_pacman_list() {
    pacman -Qtnq > $HSB/$PACKAGE_LIST_FILE
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

incr_all() {
	source $HOME/dotfiles/baklocs
	remove_and_backup config_dir
	incr_backup reads_dir
	incr_backup text_dir
	incr_backup pacaur_cache_dir
	incr_backup mixed_dir
	incr_backup build_dir
	incr_backup videos_dir
	incr_backup music_dir
	incr_backup samples_dir
	incr_backup rand_dir
	incr_backup fonts_dir
	incr_backup theming_dir
	rsync_paccache
}

install_pacman_list() {
    extra_args_to_pacman=$@

    pacman -Q > /tmp/installed_packages

    for PACKAGE in $(cat $HSB/$PACKAGE_LIST_FILE); do
        if ! grep -Fxq $PACKAGE /tmp/installed_packages; then
            sudo pacman -S $@ $PACKAGE
        fi
    done
}
