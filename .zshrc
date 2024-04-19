export LANG=ja_JP.UTF-8
# setopt print_eight_bit

# 計測ツール
# zmodload zsh/zprof

# sheldon
eval "$(sheldon source)"

# cargo
source "$HOME/.cargo/env"

# 色を使用出来るようにする
autoload -Uz colors
colors
export TERM=xterm-256color

# --- Settings for each OS ---
if [ "$(uname)" = "Darwin" ]; then
  # MacOS
  eval "$(/opt/homebrew/bin/brew shellenv)"
  alias ls='ls -G'
  alias pbcopy="pbcopy;pbpaste"
  alias sed='gsed'
elif [ "$(uname)" = "Linux" ]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
  if [ "$(uname -r)" = "*microsoft*" ]; then
    echo "WSL"
  else
    # Linux
    alias fd='fdfind'
  fi
fi

# load .zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# --- Docker Default Platform ---
# export DOCKER_DEFAULT_PLATFORM=linux/amd64

# --- Alias ---
alias sudo='sudo '
alias xargs='xargs '

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'

# ls (ezaに置き換え)
alias ls='ls -l'
if type "eza" >/dev/null 2>&1; then
  alias ls='eza -l'
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
alias gsw2="git branch --list | cut -c 3- | fzf --preview \"git log --pretty=format:'%h %cd %s' --date=format:'%Y-%m-%d %H:%M' {}\" | xargs git switch"
alias gco='git restore'
# alias grs="git restore"
# alias gco='git checkout'
alias gl='git log'
alias glg='git log --oneline --graph --decorate -20'
alias gf='git fetch -p'
alias gr='git rebase'
alias gm='git merge'
alias gg='git grep'
alias gpush='git push -u'
alias gpushf='git push -u --force-with-lease'
alias gpull='git pull'
alias gcp='git cherry-pick'

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
alias lzd="lazydocker"

function ghq-fzf() {
  local src="$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")"
  if [ -n "$src" ]; then
    cd $(ghq root)/$src
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

# 計測ツール
# zprof
