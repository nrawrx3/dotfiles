# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH='/Users/soumikrakshit/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="rana"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: 
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"

alias mmb=micromamba

eval "$(/opt/homebrew/bin/brew shellenv)"

export HISTSIZE=10000
export HISTFILESIZE=10000

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Completion
 [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# binutils

export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
# export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
# NodeJS
# export PATH="/opt/homebrew/opt/node@12/bin:$PATH"

# export LDFLAGS="-L/opt/homebrew/opt/node@12/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/node@12/include"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export ANDROID_NDK_ROOT=$ANDROID_HOME/ndk/29.0.14206865
export PATH=$ANDROID_NDK_ROOT/shader-tools/darwin-x86_64:$PATH

# Homebrew path
export PATH=/opt/homebrew/bin:$PATH

# Go
export GOPATH=$HOME/werk/go
export PATH=$GOPATH/bin:$PATH

# ElixirLS
export PATH=$HOME/werk/elixirls_dir:$PATH

# Flutter
export PATH="/Users/soumikrakshit/werk/flutter/bin:$PATH"

# psql (keep this updated as per brew's libpq version)
export PATH=/opt/homebrew/Cellar/libpq/15.0/bin:$PATH

export PATH="$PATH:$HOME/.pub-cache/bin"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Jupyter
export JUPYTER_BROWSER=safari
export USE_JT_THEME=

# .local/bin
export PATH=$HOME/.local/bin:$PATH

# yarn global
export PATH=$HOME/.yarn/bin:$PATH

jt_theme() {
  if [ -z $USE_JT_THEME ]; then
    jt -r
  else
    echo "Using jupyter theme $1"
    jt -t $1 -f generic -fs 9 -cellw 90%
  fi
}

start_jupyter() {
	jt_theme chesterish
	detached jupyter-notebook --matplotlib=inline --port 9999
}

# Command line editor
export EDITOR=vim

# dtach
detached () {
	exe_name="$1"
	command_line="$@"
	sockname="/tmp/${exe_name}__$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)".sock
	echo "sockname=${sockname}"
	echo "dtach -n ${sockname} ${command_line}"
	dtach -n ${sockname} $@
}

alias dt=detached
alias ttn='tmux new -t'
alias tta='tmux a -t'
alias ls='ls --color=auto'

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

# LLVM
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# coreutils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# autoconf-2.69
export PATH="/opt/homebrew/opt/autoconf@2.69/bin:$PATH"

# LD
# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
#export LDFLAGS="-L/opt/homebrew/opt/erlang@23/lib"

# Erlang
# export PATH="/opt/homebrew/opt/erlang@23/bin:$PATH"

# gcloud
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"


# icloud drive

export ICLOUD_DIR="/Users/soumikrakshit/Library/Mobile\ Documents/com~apple~CloudDocs"

export PATH="/Users/soumikrakshit/.cargo/bin:$PATH"

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# zoxide
if [ -x "$(command -v zoxide)" ]; then
  eval "$(zoxide init bash)"
fi

git_uncommit_uwu() {
    last_commit_message=$(git log -1 --pretty=%B)

    if [ "$last_commit_message" = "UNCOMMIT PWEEEASE" ]; then
        git uncommit
        git unstage
        echo "Last commit was undone and changes were unstaged."
    else
        echo "Last commit message does not match, no action taken."
    fi
}

git_commit_uwu() {
    last_commit_message=$(git log -1 --pretty=%B)

    if [ "$last_commit_message" != "UNCOMMIT PWEEEASE" ]; then
        git add .
        git commit -m "UNCOMMIT PWEEEASE"
        echo "Changes were added and committed with the message 'UNCOMMIT PWEEEASE'."
    else
        echo "Last commit message matches, no action taken."
    fi
}

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/opt/homebrew/opt/micromamba/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/soumikrakshit/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
. "$HOME/.cargo/env"


alias mactivate="micromamba activate"
alias minfo="micromamba info"
alias mcreate="micromamba create"
alias minstall="micromamba install"export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export SRC_ACCESS_TOKEN="sgp_a1ecc26c7154ea77_7b4a14ee95a61b5f9e16cde1b3a7cac22d8ad285"
export SRC_ENDPOINT="https://efg.sourcegraphcloud.com"
alias src="/opt/homebrew/Cellar/src-cli/6.9.0/bin/src"

function docker_logs() {
        for c in $(docker ps -a --format="{{.Names}}")
        do
        docker logs -f $c > /tmp/$c.log 2> /tmp/$c.err &
        done
        tail -f /tmp/*.{log,err}
}

alias ws="windsurf"
alias cs="cursor"
alias nv="nvim"


# function android_studio_jbr() {
export PATH="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"
# }
