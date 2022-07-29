#!/bin/sh

# apt等で次のツール類をインストールしておく
# 共通: curl, zsh

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

  # VSCode
  ln -snfv $DOTPATH/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
  ln -snfv $DOTPATH/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
  cat vscode/extensions | while read line
  do
    code --install-extension $line
  done

  # 必要なものをインストール
  brew install fd exa bat

elif [ "$(uname)" = "Linux" ]; then
  # Linux

  apt update -y

  # 必要なものをインストール
  apt install -y zsh git zplug exa bat fd-find

  # fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && yes | ~/.fzf/install

  # VSCode
  ln -snfv $DOTPATH/vscode/settings.json ~/.config/Code/User/settings.json
  ln -snfv $DOTPATH/vscode/keybindings.json ~/.config/Code/User/keybindings.json
  cat vscode/extensions | while read line
  do
    code --install-extension $line
  done
fi

# ドットから始まるファイルのシンボリックリンクをはる
cd "$DOTPATH"
for f in .??*
do
  # 除外
  [ "$f" = ".git" ] && continue
  [ "$f" = ".gitignore" ] && continue

  ln -snfv "$DOTPATH/$f" "$HOME"
done
