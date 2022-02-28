#!/bin/sh

# デフォルトは ~/.dotfiles
: ${DOTPATH:=~/.dotfiles}

# DOTPATH に移動
cd "$DOTPATH"
if [ $? -ne 0 ]; then
  die "not found: $DOTPATH"
fi

# シンボリックリンクをはる
for f in .??*
do
  [ "$f" == ".git" ] && continue

  ln -snfv "$DOTPATH/$f" "$HOME/$f"
done
