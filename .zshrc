export LANG=ja_JP.UTF-8
setopt print_eight_bit

if [ "$(uname)" = "Darwin" ]; then
# MacOS

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# ls
export CLICOLOR='1'
export LSCOLORS=Cxfxcxdxbxegedabagacad
alias ls='ls -G'

# elif ["$(uname)" == "Linux"]; then 
# Linux
    # if [[ "$(uname -r)" == *microsoft* ]]; then
    # WSL
    # fi
fi

# prompt settings
setopt PROMPT_SUBST
source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

export PS1='%F{magenta}%n%f@%F{yellow}%m%f:%F{cyan}%~%f %F{red}($(__git_ps1 "%s" ))%f
> '

# Plugins (managed by zplug)
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
 
if ! zplug check --verbose; then
    printf "install?[y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
 
zplug load

# load .zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
