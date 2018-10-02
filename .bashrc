# ~/.bashrc

# export PS1="\[$(tput setaf 2)\]┌─╼ \[$(tput setaf 6)\][\w]\n\[$(tput setaf 1)\]\$(if [[ \$? == 0 ]]; then echo \"\[$(tput setaf 1)\]└────╼\"; else echo \"\[$(tput setaf 1)\]└╼\"; fi) \[$(tput setaf 7)\]"
# export PS1="\n\[$(tput sgr0)\]\[\033[38;5;208m\][\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;33m\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;202m\]]\[$(tput sgr0)\]\[\033[38;5;15m\]\n \[$(tput sgr0)\]\[\033[38;5;200m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;34m\]>>\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

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
alias cl="clear"

source /etc/profile.d/vte.sh

export EDITOR=nvim
HISTSIZE=-1

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl":$PATH

export BUILD_DIR=$HOME/build

PATH=$HOME/.local/bin:$PATH

export PATH

export PACMAN_CACHE="/var/cache/pacman/pkg"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export CSCOPE_EDITOR="nvim"

export PYTHONPATH=$HOME/.local/python_modules:$PYTHONPATH

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

# Stage the modified files
git_add_modified() {
    git ls-files --modified | xargs git add
}

# Stage the untracked but not ignored files. These are those files that you just
# created in the repo.
git_add_untracked() {
    git ls-files --others --exclude-standard | xargs git add
}

# Prettier log
git_pretty_log() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
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

# Extract archive
function extract {
    if [ -z "$1" ]; then
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        if [ -f $1 ] ; then
            case $1 in
                *.tar.bz2)   tar xvjf ./$1    ;;
                *.tar.gz)    tar xvzf ./$1    ;;
                *.tar.xz)    tar xvJf ./$1    ;;
                *.lzma)      unlzma ./$1      ;;
                *.bz2)       bunzip2 ./$1     ;;
                *.rar)       unrar x -ad ./$1 ;;
                *.gz)        gunzip ./$1      ;;
                *.tar)       tar xvf ./$1     ;;
                *.tbz2)      tar xvjf ./$1    ;;
                *.tgz)       tar xvzf ./$1    ;;
                *.zip)       unzip ./$1       ;;
                *.Z)         uncompress ./$1  ;;
                *.7z)        7z x ./$1        ;;
                *.xz)        unxz ./$1        ;;
                *.exe)       cabextract ./$1  ;;
                *)           echo "extract: '$1' - unknown archive method" ;;
            esac
        else
            echo "$1 - file does not exist"
        fi
    fi
}

include () {
    [[ -f "$1" ]] && source "$1"
}

include "${HOME}/dotfiles/android_sdk_paths.source.sh"


# Path to the bash it configuration
export BASH_IT="/home/rksht/.bash_it"

# Lock and Load a custom theme file location /.bash_it/themes/
export BASH_IT_THEME='demula'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='weechat'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the
# prompt for all themes
export SCM_CHECK=true


# Load Bash It
source "$BASH_IT"/bash_it.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
