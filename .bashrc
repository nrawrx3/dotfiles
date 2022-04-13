# ~/.bashrc

alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
alias grep="grep --color=auto"
alias la="ls -a"
alias ll="ls -l --block-size=M"
alias ltr="ls -ltr"
alias cl="clear"
alias raxu="rsync -aAu"
alias raxvu="rsync -aAvu"
alias up="cd .."
alias upp="cd ../.."
alias uppp="cd ../../.."
alias cls="clear"
alias md="mkdir"
alias tnvim="nvim -c terminal"
alias tta="tmux a -t"
alias ttn="tmux new -t"
alias ncipython="CUDA_VISIBLE_DEVICES=-1 ipython"

source /etc/profile.d/vte.sh

export EDITOR=vim
HISTSIZE=-1

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl":$PATH

export BUILD_DIR=$HOME/build

PATH=$HOME/.local/bin:$PATH
# PATH=$HOME/Android/Sdk/tools/bin:$PATH

export PATH

export GUI_EDITOR=nvim-qt

export PYTHONPATH=$HOME/.local/python_modules:$PYTHONPATH

export NVIM_YCMD_REPO="${HOME}/.config/nvim/plugged/YouCompleteMe"
export NVIM_YCMD_ROOT="${HOME}/.config/nvim/plugged/YouCompleteMe/third_party/ycmd"

export GOPATH=/home/rksht/werk/gj/go
export PATH=${GOPATH}/bin:$PATH

export PREFERRED_TE=urxvt

export ERL_AFLAGS="-kernel shell_history enabled"

export USE_JT_THEME=

export JUPYTER_BROWSER=firefox

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

python_source() {
	dir=$1
# source $dir/bin/activate  # commented out by conda initialize
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
xtime() {
	/usr/bin/time -f 'User=%U Kernel=%S Real=%e MaxMem=%MkB %C' "$@"
}

export EXTERNAL_HDD=/run/media/rksht/BackupPlus

PACKAGE_LIST_FILE="package_list"

store_pacman_list() {
	pacman -Qtnq > $EXTERNAL_HDD/$PACKAGE_LIST_FILE
}

export NOTES_DIR=${HOME}/werk/patient_boy

takenotes() {
	EDITOR=$1
	cd $NOTES_DIR
	firefox http://localhost:1313
	detached hugo server -D
}
	
newnote() {
	notename=$1
	cd $NOTES_DIR
	${GUI_EDITOR}
	chromium --incognito http://localhost:1313
	hugo new posts/$notename
	hugo server -D
}

# Trims the given string and prints it
cpstdin() {
	read INPUT
	xargs "${INPUT}" | xclip -se c
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

	for PACKAGE in $(cat $EXTERNAL_HDD/$PACKAGE_LIST_FILE); do
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
export BASH_IT_THEME='cooperkid'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='weechat'

# Set this to false to turn off version control status checking within the
# prompt for all themes
export SCM_CHECK=true


# Load Bash It
source "$BASH_IT"/bash_it.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"

export TERM="xterm-256color"

source /usr/share/z/z.sh

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh


detached () {
	exe_name="$1"
	command_line="$@"
	sockname="/tmp/${exe_name}__$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)".sock
	echo "Starting ${exe_name} with command ${command_line}"
	dtach -n ${sockname} ${command_line}
}

alias dt=detached

function jt_theme() {
  if [ -z $USE_JT_THEME ]; then
    jt -r
  else
    echo "Using jupyter theme $1"
    jt -t $1 -f firacode -fs 14 -cellw 90%
  fi
}

function start_jupyter() {
	SAVED_BROWSER=$BROWSER
	export BROWSER=$JUPYTER_BROWSER
	mamba_init &&  micromamba activate ${CONDA_ENV_NAME}
	jt_theme chesterish
	detached jupyter-notebook --matplotlib=inline --port 9999
	export BROWSER=$SAVED_BROWSER
}

function startwork() {
	export CONDA_ENV_NAME=$1
	start_jupyter
	detached nvim-qt
	subl
	detached firefox
	export BROWSER=$SAVED_BROWSER
}

function newterm() {
	sockname="/tmp/${PREFERRED_TE}__$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)".sock
	dtach -n ${sockname} ${PREFERRED_TE}
}

# Use `xrandr` to get this
export MAIN_HDMI_OUTPUT=HDMI-A-0

function set_res() {
	res_name=$1

	case $res_name in
		"4k")
			xrandr --output ${MAIN_HDMI_OUTPUT} --mode 3840x2160 --rate 60
			;;
		"2k")
			xrandr --output ${MAIN_HDMI_OUTPUT} --mode 2560x1440
			;;
		"1k")
			xrandr --output ${MAIN_HDMI_OUTPUT} --mode 1920x1080 --rate 60
			;;
		*)
			echo "usage - set_res [4k|2k|1k]"
			;;
	esac
}

# source ~/.ipsec.include.sh


function tmuxswitch() {
  sessname=$1
  tmux detach
  tmux a -t $sessname
}


# function mamba_init() {
# 	# >>> mamba initialize >>>
# 	# !! Contents within this block are managed by 'mamba init' !!
# 	export MAMBA_EXE="/usr/bin/micromamba";
# 	export MAMBA_ROOT_PREFIX="/home/rksht/werk/micromamba";
# 	__mamba_setup="$('/usr/bin/micromamba' shell hook --shell bash --prefix '/home/rksht/werk/micromamba' 2> /dev/null)"
# 	if [ $? -eq 0 ]; then
# 		eval "$__mamba_setup"
# 	else
# 		if [ -f "/home/rksht/werk/micromamba/etc/profile.d/mamba.sh" ]; then
# 			. "/home/rksht/werk/micromamba/etc/profile.d/mamba.sh"
# 		else
# 			export PATH="/home/rksht/werk/micromamba/bin:$PATH"
# 		fi
# 	fi
# 	unset __mamba_setup
# 	# <<< mamba initialize <<<
# }

function conda_init() {
	[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
}

export GOPRIVATE="source.golabs.io/*"
GOPROXY="direct"
