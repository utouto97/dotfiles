#!/bin/sh

DOTPATH=~/.dotfiles

# curl か wget でtarballを取得し展開
tarball="https://github.com/utouto97/dotfiles/archive/main.tar.gz"

if type "curl" > /dev/null 2>&1; then
  echo "curl"
  curl -L "$tarball" | tar zxv
# elif type "wget" > /dev/null 2>&1; then
#   echo "wget"
#   curl -O - "$tarball" | tar zxv
else
  die "curl required"
fi

# DOTPATHへ移動
mv -f dotfiles-main "$DOTPATH"

cd "$DOTPATH"
if [ $? -ne 0 ]; then
  die "not found: $DOTPATH"
fi

for f in .??*
do
  [ "$f" == ".git" ] && continue

  ln -snfv "$DOTPATH/$f" "$HOME/$f"
done
