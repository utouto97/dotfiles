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
  # elif type "wget" > /dev/null 2>&1; then
  #   echo "wget"
  #   curl -O - "$tarball" | tar zxv
  else
    die "curl required"
  fi

  # ディレクトリをDOTPATHへ移動
  mv -f dotfiles-main "$DOTPATH"
fi

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