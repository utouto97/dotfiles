export LANG=ja_JP.UTF-8
setopt print_eight_bit


# --- Settings for each OS ---
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

# --- Prompt settings ---
setopt PROMPT_SUBST
source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

export PS1='%F{magenta}%n%f@%F{yellow}%m%f:%F{cyan}%~%f %F{red}($(__git_ps1 "%s" ))%f
> '

# --- Plugins (managed by zplug) ---
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
 
if ! zplug check --verbose; then
    printf "install?[y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
 
zplug load

# --- fzf ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

function fzh() {
    BUFFER=$(history -n -r 1 | fzf --no-sort +m)
    CURSOR=$#BUFFER
}
zle -N fzh
bindkey '^r' fzh

function fbr() {
    branch=$(git branch -vv | fzf --no-sort +m)
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}


# --- Alias ---

alias ..2='cd ../..'
alias ..3='cd ../../..'

# git
alias g='git'
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# load .zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
