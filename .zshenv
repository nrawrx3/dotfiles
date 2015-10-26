source ~/dotfiles/set_envs.src.sh

typeset -U path
path=(~/bin $GOPATH/bin $path[@])
