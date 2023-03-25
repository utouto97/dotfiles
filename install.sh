#!/bin/sh
#
# デフォルトは ~/.dotfiles
: ${DOTPATH:=~/.dotfiles}

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
  apt install -y zsh git exa bat fd-find wget

  # install neovim
  wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
  tar zxf nvim-linux64.tar.gz
  cp -R nvim-linux64/* /usr/local/
fi

# --- zshに切り替え
if [ "$SHELL" != "zsh" ]; then
  chsh -s /usr/bin/zsh
fi

# シンボリックリンク
ln -s "$DOTPATH/.zshrc" "$HOME/.zshrc"
ln -s "$DOTPATH/.git-prompt.sh" "$HOME/.git-prompt.sh"
mkdir -p $HOME/.config/nvim
ln -s "$DOTPATH/init.lua" "$HOME/.config/nvim/"

# packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
