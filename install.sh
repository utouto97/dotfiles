#!/bin/sh

# デフォルトは ~/.dotfiles
: ${DOTPATH:=~/.dotfiles}

# tarball URL
tarball="https://github.com/utouto97/dotfiles/archive/main.tar.gz"

# ディレクトリが存在しなければ、curl か wget でtarballを取得し展開
if [ ! -d $DOTPATH ]; then
  if type "curl" > /dev/null 2>&1; then
    echo "curl"
    curl -L "$tarball" | tar zxv
  else
    die "curl required"
  fi

  # ディレクトリをDOTPATHへ移動
  mv -f dotfiles-main "$DOTPATH"
fi

# --- 環境ごとのセットアップ
if [ "$(uname)" = "Darwin" ]; then
  # MacOS

  # homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # 必要なものをインストール
  brew install fd exa bat neovim

elif [ "$(uname)" = "Linux" ]; then
  # Linux

  apt update -y

  # 必要なものをインストール
  apt install -y zsh git exa bat fd-find neovim
fi

# --- zshに切り替え
if [ "$SHELL" != "zsh" ]; then
  chsh -s /usr/bin/zsh
fi

# シンボリックリンク
mkdir -p $HOME/.config/nvim
ln -s "$DOTPATH/init.lua" "$HOME/.config/nvim/"
ln -s "$DOTPATH/.git-prompt.sh" "$HOME/.git-prompt.sh"

# packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
