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
    if [[ "$(uname -r)" = *microsoft* ]]; then
    # WSL
      export ZPLUG_HOME=$HOME/.zplug
      if type "fdfind" >/dev/null 2>&1; then
        alias fd='fdfind'
      fi
    fi
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

# --- Plugins (managed by zplug) ---
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
export FZF_DEFAULT_OPTS='-e --height 90% --reverse --border --preview-window right:50%'

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

# fbr (fzf git branch, can checkout)
function fzf-git-branch() {
    branch=$(git branch -vv | fzf --no-sort +m)
    [ -n "$branch" ] && git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

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

# ファイルオープン (ない場合は新規作成)
function op() {
  if type "fd" >/dev/null 2>&1; then
    if [ -z "$1" ]; then # 既存ファイル
      name=$(fd -t f -H -E ".git" 2>/dev/null | fzf --no-sort +m \
        --preview 'head -20 {}')
      [ -z "$name" ] && return
      $EDITOR "$name"
    else # 新規作成
      dir=$(fd -t d -H -E ".git" 2>/dev/null | fzf --no-sort +m)
      [ -z "$dir" ] && return
      $EDITOR "$dir/$1"
    fi
  else
    if [ -z "$1" ]; then # 既存ファイル
      name=$(find . -type f -maxdepth 6 2>/dev/null | grep -v "/\.git/" | fzf --no-sort +m)
      [ -z "$name" ] && return
      $EDITOR "$name"
    else # 新規作成
      dir=$(find . -type d -maxdepth 6 2>/dev/null | grep -v "\.git" | fzf --no-sort +m)
      [ -z "$dir" ] && return
      $EDITOR "$dir/$1"
    fi
  fi
}
zle -N op
bindkey '^o' op

alias gdf='(){ fuzzy-file-finder | xargs git diff $@ }' #git diff fuzzy

# ホームディレクトリ以下のディレクトリをfzfで検索->移動 (ctrl+tで起動)
function fd-fzf() {
  dir=$(fd -t d -H -E ".git" . $HOME | fzf --no-sort +m )

  if [ -n "$dir" ]; then
    BUFFER="cd $dir"
    zle accept-line
  fi

  zle reset-prompt
}
zle -N fd-fzf
bindkey "^g" fd-fzf

# メモ管理 (fzfを利用)
MEMO=~/.memo
function memo() {
  if [ -z "$1" ]; then # 既存ファイル
    name=$(find $MEMO -type f -maxdepth 6 2>/dev/null | grep -v "/\.git/" |\
      sed "s|$MEMO/||" | fzf --no-sort +m)
    [ -z "$name" ] && return
    $EDITOR "$MEMO/$name"
  else # 新規作成
    dir=$(find $MEMO -type d -maxdepth 6 2>/dev/null | grep -v "\.git" |\
      grep -v "^$MEMO$" | sed "s|$MEMO/||" | fzf --no-sort +m)
    [ -z "$dir" ] && return
    $EDITOR "$MEMO/$dir/$1"
  fi
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

# git
alias g='git'
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
#alias gb='git branch'
alias gb='fzf-git-branch'
alias gco='git checkout'
alias gl='fzf-git-log'
alias ggr='git log --oneline --graph --decorate --all'

# docker & docker-compose
alias d='docker'
alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcp="docker-compose ps"
alias dcu="docker-compose up -d --build"
alias dcl="docker-compose logs"
alias dcr="docker-compose restart"

# nvm
if type "nvm" >/dev/null 2>&1; then
  alias nv='nvm use $(cat .node-version)'
fi
