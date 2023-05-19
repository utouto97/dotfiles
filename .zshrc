export LANG=ja_JP.UTF-8
# setopt print_eight_bit

# 計測ツール
# zmodload zsh/zprof

# 色を使用出来るようにする
autoload -Uz colors
colors
export TERM=xterm-256color

# 補完機能を有効にする
autoload -Uz compinit
compinit

# --- Settings for each OS ---
if [ "$(uname)" = "Darwin" ]; then
  # MacOS
  eval "$(/opt/homebrew/bin/brew shellenv)"
  alias ls='ls -G'
  alias pbcopy="pbcopy;pbpaste"
  alias sed='gsed'
elif [ "$(uname)" = "Linux" ]; then
  if [ "$(uname -r)" = "*microsoft*" ]; then
    echo "WSL"
  else
    # Linux
    alias fd='fdfind'
  fi
fi

# load .zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

setopt PROMPT_SUBST
source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

export PS1='%F{magenta}%n%f@%F{yellow}%m%f:%F{cyan}%~%f %F{red}($(__git_ps1 "%s" ))%f
'

# --- Docker Default Platform ---

# export DOCKER_DEFAULT_PLATFORM=linux/amd64

# --- Alias ---
alias sudo='sudo '
alias xargs='xargs '

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'

# ls (exaに置き換え)
alias ls='ls -l'
if type "exa" >/dev/null 2>&1; then
  alias ls='exa -l'
fi
alias la='ls -la'

# git
alias g='git'
alias ga='git add'
alias gs='git status -s'
alias gc='git commit'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gsw='git switch'
alias gco='git restore'
# alias grs="git restore"
# alias gco='git checkout'
alias gl='git log'
alias glg='git log --oneline --graph --decorate -20'
alias gp='git push -u'
alias gf='git fetch -p'
alias gr='git rebase'
alias gm='git merge'
alias gg='git grep'

# docker & docker-compose
alias d='docker'
alias dc='docker compose'
alias dce='docker compose exec'
alias dcp="docker compose ps"
alias dcb="docker compose build"
alias dcu="docker compose up -d"
alias dcub="docker compose up -d --build"
alias dcl="docker compose logs"
alias dcr="docker compose run --rm"
alias dcd="docker compose down"
alias dcrestart="docker compose restart"

# 計測ツール
# zprof
