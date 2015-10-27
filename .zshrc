#eval `opam config env`


source ~/dotfiles/set_envs.src.sh


# Alt+u to cd ..
bindkey -s '\eu' '^Ucd ..; ls^M'

alias k='tree'
alias ltr='ls -ltr'
alias ls='ls --color'
alias l='ls -lh'
alias ll='ls -la'

alias biggest='find -type f -printf '\''%s %p\n'\'' | sort -nr | head -n 40 | gawk "{ print \$1/1000000 \" \" \$2 \" \" \$3 \" \" \$4 \" \" \$5 \" \" \$6 \" \" \$7 \" \" \$8 \" \" \$9 }"'


bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

autoload -Uz compinit
compinit
PROMPT=" % :  "
RPROMPT="%~   "


# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/snyp/.zshrc'

# End of lines added by compinstall

export TERM=rxvt-unicode-256color

export PATH=$GOPATH/bin:$PATH
