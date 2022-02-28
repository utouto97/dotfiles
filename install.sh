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

# --- 環境ごとのセットアップ
if [ "$(uname)" = "Darwin" ]; then
# MacOS

# VSCode
ln -snfv $DOTPATH/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -snfv $DOTPATH/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

cat vscode/extensions | while read line
do
  code --install-extension $line
done

# elif ["$(uname)" == "Linux"]; then
# Linux
    # if [[ "$(uname -r)" == *microsoft* ]]; then
    # WSL
    # fi
fi

DOTPATH=$DOTPATH ./deploy.sh
