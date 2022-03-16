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

# elif ["$(uname)" == "Linux"]; then 
# Linux
    # if [[ "$(uname -r)" == *microsoft* ]]; then
    # WSL
    # fi
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

# fzh (fzf history)
function fzh() {
    BUFFER=$(history -n -r 1 | fzf --no-sort +m)
    CURSOR=$#BUFFER
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

# あいまい検索を利用したファイル検索 (ファイルを選択すると$EDITORで開く)
function fd() {
  startdir=$(pwd)

  [ -n "$1" ] && cd $1

  name=$(find . -type d -maxdepth 1 | sed 's!^.*/!!' | sed 's/^.$/.\n../' | fzf --no-sort +m --ansi --preview '\
    if [ -d {} ]; then
      (cd {} && ls -A)
    else
      head -20 {}
    fi
  ')
  while [ -d $name ]
  do
    [ -z "$name" ] && break
    [ "$name" = "." ] && break

    cd $name
    name=$(find . -type d -maxdepth 1 | sed 's!^.*/!!' | sed 's/^.$/.\n../' | fzf --no-sort +m --ansi --preview '\
      if [ -d {} ]; then
        (cd {} && ls -A)
      else
        head -20 {}
      fi
    ')
  done
  current=$(pwd)
  cd $startdir
  cd $current
}

# fuzzy open
function fop() {
  name=$(find . -type f | fzf --no-sort +m --ansi)
  [ -n "$name" ] && $EDITOR $name
}

# メモ管理 (fzfを利用)
MEMO=~/.memo
function memo() {
  if [ -z "$1" ]; then
    (
      cd $MEMO
      name=$(ls -1A | fzf --no-sort +m --ansi --preview '\
        if [ -d {} ]; then
          (cd {} && ls -A)
        else
          head -20 {}
        fi
      ')
      while [ -d $name ]
      do
        [ -z "$name" ] && return
        cd $name
        name=$(ls -1A | fzf --no-sort +m --ansi --preview '\
          if [ -d {} ]; then
            (cd {} && ls -A)
          else
            head -20 {}
          fi
        ')
      done
      $EDITOR $name
    )
  else
    $EDITOR $1
  fi
}

# --- Alias ---
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'

# ls
alias ls='ls -l'
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

# docker & docker-compose
alias d='docker'
alias dc='docker-compose'

# nvm
if type "nvm" >/dev/null 2>&1; then
  alias nv='nvm use $(cat .node-version)'
fi
