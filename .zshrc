export LANG=ja_JP.UTF-8
setopt print_eight_bit

EDITOR=code

# --- Settings for each OS ---
if [ "$(uname)" = "Darwin" ]; then
# MacOS

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# ls
export CLICOLOR='1'
export LSCOLORS=Cxfxcxdxbxegedabagacad
alias ls='ls -G'

export ZPLUG_HOME=/opt/homebrew/opt/zplug

elif [ "$(uname)" = "Linux" ]; then
# Linux
    export ZPLUG_HOME=$HOME/.zplug
fi

# load .zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# --- Prompt settings ---
setopt PROMPT_SUBST
source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

export PS1='%F{magenta}%n%f@%F{yellow}%m%f:%F{cyan}%~%f %F{red}($(__git_ps1 "%s" ))%f
> '

export PMY_TRIGGER_KEY='^i'
eval "$(pmy init)"

# --- Plugins (managed by zplug) ---
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "junegunn/fzf", from:gh-r, as:command

if ! zplug check --verbose; then
    printf "install?[y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# --- fzf ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='-e --height 90% --reverse --border --preview-window right:50% --ansi'

# fuzzy file finder
function fuzzy-file-finder() {
  BASE=.
  [ -n "$1" ] && BASE=$1
  echo $(find $BASE -type f -maxdepth 6 2>/dev/null | fzf --no-sort +m)
}

# fuzzy directory finder
function fuzzy-dir-finder() {
  BASE=.
  [ -n "$1" ] && BASE=$1
  echo $(find $BASE -type d -maxdepth 6 2>/dev/null | fzf --no-sort +m)
}

# fuzzy系便利コマンド
# fzh (fzf history)
function fzh() {
  hist=$(history -n -r 1 | fzf --no-sort +m)

  if [ -n "$hist" ]; then
    BUFFER=$hist
    zle accept-line
  fi

  zle reset-prompt
}
zle -N fzh
bindkey '^r' fzh

# fgl (fzf git log, and echo its hash)
function fzf-git-log() {
  git log -n1000 --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |\
    fzf -m --ansi --no-sort --tiebreak=index --preview \
    'f() {
      set -- $(echo "$@" | grep -o "[a-f0-9]\{7\}" | head -1);
      if [ $1 ]; then
        git show --color $1
      else
        echo "blank"
      fi
    }; f {}' |\
    grep -o "[a-f0-9]\{7\}" |
    tr '\n' ' '
}

# --- Alias ---
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'

# ls (exaに置き換え)
alias ls='ls -l'
if type "exa" >/dev/null 2>&1; then
  alias ls='exa -l --git'
fi
alias la='ls -la'

# e ($EDITOR)
alias e="$EDITOR"

# git
alias g='git'
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gb='git branch'
alias gsw='git switch'
alias grs="git restore"
# alias gco='git checkout'
alias gl='fzf-git-log'
alias ggr='git log --oneline --graph --decorate --all'
alias gf='git fetch'
alias grb='git rebase'
alias gst='git stash'
alias gpp='git stash pop'

# docker & docker-compose
alias d='docker'
alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcp="docker-compose ps"
alias dcu="docker-compose up -d"
alias dcub="docker-compose up -d --build"
alias dcl="docker-compose logs"
alias dcr="docker-compose run --rm"
alias dcd="docker-compose down"
alias dcrestart="docker-compose restart"

# nvm
if type "nvm" >/dev/null 2>&1; then
  alias nv='nvm use $(cat .node-version)'
fi
