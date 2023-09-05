# .bash_profile -*- mode: sh -*-

export OSH_THEME="morris"

# Load login settings and environment variables
if [[ -f ~/.profile ]]; then
  source ~/.profile
fi

# Load interactive settings
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="/opt/homebrew/opt/micromamba/bin/micromamba";
export MAMBA_ROOT_PREFIX="/Users/soumikrakshit/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "/Users/soumikrakshit/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "/Users/soumikrakshit/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="/Users/soumikrakshit/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
