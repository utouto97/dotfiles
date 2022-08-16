#!/bin/sh

markpath=${BOOKMARK_FILE_PATH:-~/.mark}

function mark() {
  files=$(grep "^$(pwd)$" $markpath)
  if [ -z "$files" ]; then
    pwd >> $markpath
    echo "Marked here."
  else
    echo "Already exists."
  fi
}

function jm() {
  dir=$(cat $markpath | fzf +m --preview 'ls -la')
  if [ -n "$dir" ]; then
    cd $dir
  fi
}
