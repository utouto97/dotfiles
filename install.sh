#!/bin/sh

# デフォルトは ~/.dotfiles
: ${DOTPATH:=~/.dotfiles}

# --- 環境ごとのセットアップ
if [ "$(uname)" = "Darwin" ]; then
  # MacOS

  # homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # 必要なものをインストール
  brew install fd eza bat neovim sheldon

elif [ "$(uname)" = "Linux" ]; then
  if [ "$(uname -r)" = "*microsoft*" ]; then
    echo "WSL"

    # 必要なものをインストール
    # sudo apt install -y zsh git exa bat fd-find wget
    #
    # Cica font をインストール
    # https://github.com/miiton/Cica

  else
    # Linux

    # 必要なものをインストール
    apt update -y
    apt install -y zsh git exa bat fd-find curl

    # install neovim
    curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar zx --strip-components 1 -C ~/.local/
  fi
fi

# --- zshに切り替え
if [ "$SHELL" != "zsh" ]; then
  chsh -s /usr/bin/zsh
fi

# シンボリックリンク
ln -snf "$DOTPATH/.zshrc" "$HOME/.zshrc"
mkdir -p $HOME/.config/nvim
ln -snf "$DOTPATH/nvim/init.lua" "$HOME/.config/nvim/"
ln -snf "$DOTPATH/nvim/lua" "$HOME/.config/nvim/"
ln -snf "$DOTPATH/sheldon/" "$HOME/.config/sheldon"
ln -snf "$DOTPATH/starship.toml" "$HOME/.config/"
