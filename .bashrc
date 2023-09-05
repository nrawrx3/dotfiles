# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH='/Users/soumikrakshit/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="duru"

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

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

# To enable/disable display of Python virtualenv and condaenv
OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  composer
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

alias ls="ls --color=auto"
alias cls="clear"
alias up="cd .."
alias upp="cd ../.."
alias uppp="cd ../../.."
alias md="mkdir"

source "$OSH"/oh-my-bash.sh

# Time a process - requires the gnu time(1) command installed
xtime() {
	/usr/bin/time -f 'User=%U Kernel=%S Real=%e MaxMem=%MkB %C' "$@"
}

# ssh
export SSH_KEY_PATH="~/.ssh/id_ed25519.pub"


eval "$(/opt/homebrew/bin/brew shellenv)"

# Cloud SDK
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
source "$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"


# GOLANG
export GOPATH=$HOME/werk/go
export PATH=$GOPATH/bin:$PATH

# Android SDK
export ANDROID_SDK_PATH=$HOME/Library/Android/sdk
export PATH=$ANDROID_SDK_PATH/tools/bin:$ANDROID_SDK_PATH/platform-tools:$PATH

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

export SOSREPOS=$HOME/werk/sos
export PATH=$SOSREPOS/bin:$PATH

export PATH="/Users/soumikrakshit/werk/sos/flutter/flutter-3.7.11/bin":$PATH


# Gem for cocoapods mainly
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH
export PATH="/Users/soumikrakshit/.gem/ruby/2.6.0/bin":$PATH

export PATH=$HOME/.local/bin:$PATH

export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"

# zoxide
export PATH="/opt/homebrew/Cellar/zoxide/0.9.1/bin/":$PATH
eval "$(zoxide init bash)"

export ICLOUD_DIR="/Users/soumikrakshit/Library/Mobile Documents/com~apple~CloudDocs"

# Needed for mosh for some reason and I don't want to learn why, here's the article:
# http://pesin.space/posts/2020-10-05-mosh-macos/
export LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

# Stage the modified files
git_add_modified() {
	git ls-files --modified | xargs git add
}

# Stage the untracked but not ignored files. These are those files that you just
# created in the repo.
git_add_untracked() {
	git ls-files --others --exclude-standard | xargs git add
}

detached () {
	exe_name="$1"
	command_line="$@"
	sockname="/tmp/${exe_name}__$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)".sock
	echo "Starting ${exe_name} with command ${command_line}"
	dtach -n ${sockname} ${command_line}
}

alias dt=detached15

eval "$(direnv hook bash)"

lsdocker() {
        docker exec -ti $1 sh -c "ls -l $2"
}

git_commit_pweease() {
    last_commit_message=$(git log -1 --pretty=%B)

    if [ "$last_commit_message" != "UNCOMMIT PWEEEASE" ]; then
        git add .
        git commit -m "UNCOMMIT PWEEEASE"
        echo "Changes added and committed with message UNCOMMIT PWEEEASE"
    else
        echo "Last commit message matches 'UNCOMMIT PWEEEASE', no new commit made."
    fi
}

git_uncommit_pweease() {
    last_commit_message=$(git log -1 --pretty=%B)

    if [ "$last_commit_message" = "UNCOMMIT PWEEEASE" ]; then
        git uncommit
        git unstage
        echo "Last commit was undone and changes were unstaged."
    else
        echo "Last commit message does not match, no action taken."
    fi
}