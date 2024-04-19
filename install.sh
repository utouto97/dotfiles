#!/bin/sh

## 初回セットアップ

# --- 環境ごとのセットアップ
if [ "$(uname)" = "Darwin" ]; then
  # MacOS

  # homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # 必要なものをインストール
  brew install fd eza bat neovim sheldon rg

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

    # sudo があれば sudo で実行
    SUDO=
    if [ -x "$(command -v sudo)" ]; then
      SUDO=sudo
    fi

    # 必要なものをインストール
    $SUDO apt update -y
    $SUDO apt install -y zsh git curl nodejs

    # install cargo
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    . "$HOME/.cargo/env"
    # install cargo-binstall
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    # install tools
    cargo binstall --no-confirm eza bat fd-find sheldon starship

    # install neovim
    curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | $SUDO tar zx --strip-components 1 -C /usr/local/
  fi

  # --- zshに切り替え
  if [ "$SHELL" != "zsh" ]; then
    $SUDO chsh -s /usr/bin/zsh
  fi
fi

./deploy.sh
