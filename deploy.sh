#!/bin/sh
#
## 設定ファイルのリンク更新

ln -snf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config/nvim"
ln -snf "$HOME/dotfiles/nvim/init.lua" "$HOME/.config/nvim/"
ln -snf "$HOME/dotfiles/nvim/lua/" "$HOME/.config/nvim/"
ln -snf "$HOME/dotfiles/sheldon/" "$HOME/.config/sheldon"
ln -snf "$HOME/dotfiles/starship.toml" "$HOME/.config/starship.toml"
ln -snf "$HOME/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
ln -snf "$HOME/dotfiles/.wezterm.lua" "$HOME/.wezterm.lua"
ln -snf "$HOME/dotfiles/.gitconfig" "$HOME/.gitconfig"

