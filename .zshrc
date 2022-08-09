export LANG=ja_JP.UTF-8
setopt print_eight_bit

# 色を使用出来るようにする
autoload -Uz colors
colors

# 補完機能を有効にする
autoload -Uz compinit
compinit

# デフォルトのエディタ
EDITOR=code

# ヒストリ
HISTSIZE=1000000
SAVEHIST=1000000

# --- Settings for each OS ---
if [ "$(uname)" = "Darwin" ]; then
  # MacOS

  # homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # ls
  export CLICOLOR='1'
  export LSCOLORS=Cxfxcxdxbxegedabagacad
  alias ls='ls -G'

elif [ "$(uname)" = "Linux" ]; then
  # Linux

  alias fd='fdfind'
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
'

# zsh-users/zsh-syntax-highlighting
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- fzf ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='-e --height 90% --reverse --border --preview-window right:50% --marker=o --ansi'
export FZF_COMPLETION_OPTS='-1 -0 -e --height 90% --reverse --border --preview-window right:50% --marker=o --ansi'
export FZF_COMPLETION_TRIGGER=''

# fzf custom completions
# https://github.com/junegunn/fzf/wiki/Examples-(completion)
# git
_fzf_complete_gsw() {
  local branches
  branches=$(git branch -a -vv --color=always)
  _fzf_complete --reverse +m -- "$@" < <(
    echo $branches
  )
}

_fzf_complete_gsw_post() {
  awk '{print $1}' | sed -e 's|^remotes/origin/||'
}

_fzf_complete_gr() {
  local branches
  branches=$(git branch -a -vv --color=always)
  _fzf_complete --reverse +m --ansi -- "$@" < <(
    echo $branches
  )
}

_fzf_complete_gr_post() {
  awk '{print $1}'
}

_fzf_complete_cd() {
  dirs=$(fd -t d -d 1 -H -I)
  _fzf_complete --reverse +m --ansi -- "$@" < <(
    echo $dirs
  )
}

_fzf_complete_cd_post() {
  awk '{print $1}'
}

# fzf custom functions
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

# オリジナルのブックマークスクリプト
source ~/.dotfiles/mark.sh


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

alias e="$EDITOR"

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
alias gl='fzf-git-log'
alias ggr='git log --oneline --graph --decorate --all'
alias gp='git push origin'
alias gf='git fetch'
alias gr='git rebase'

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
