#!/bin/sh

# デフォルトは ~/.dotfiles
: "${DOTPATH:=~/.dotfiles}"

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
    apt install -y zsh git curl

    # install cargo
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    . "$HOME/.cargo/env"
    # install cargo-binstall
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    # install tools
    cargo binstall --no-confirm eza bat fd-find sheldon starship

    # install neovim
    curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar zx --strip-components 1 -C /usr/local/
  fi

  # --- zshに切り替え
  if [ "$SHELL" != "zsh" ]; then
    chsh -s /usr/bin/zsh
  fi
fi


# シンボリックリンク
ln -snf "$DOTPATH/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config/nvim"
ln -snf "$DOTPATH/nvim/init.lua" "$HOME/.config/nvim/"
ln -snf "$DOTPATH/nvim/lua" "$HOME/.config/nvim/"
ln -snf "$DOTPATH/sheldon/" "$HOME/.config/sheldon"
ln -snf "$DOTPATH/starship.toml" "$HOME/.config/"

