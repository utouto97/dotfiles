#!/bin/zsh

function zsh-startuptime() {
  local total_msec=0
  local msec
  local i
  for i in $(seq 1 10); do
    msec=$((TIMEFMT='%mE'; time zsh -i -c exit) 2>/dev/stdout >/dev/null)
    msec=$(echo $msec | tr -d "ms")
    total_msec=$(( $total_msec + $msec ))
  done
  local average_msec
  average_msec=$(( ${total_msec} / 10 ))
  echo $average_msec
}

function nvim-startuptime() {
  local file=$1
  local total_msec=0
  local msec
  local i
  for i in $(seq 1 10); do
    msec=$({(TIMEFMT='%mE'; time nvim --headless -c q $file ) 2>&3;} 3>/dev/stdout >/dev/null)
    msec=$(echo $msec | tr -d "ms")
    total_msec=$(( $total_msec + $msec ))
  done
  local average_msec
  average_msec=$(( ${total_msec} / 10 ))
  echo $average_msec
}

zsh -i -c exit
nvim --headless "+Lazy! update" +qa

cat<<EOJ
[
  {
      "name": "zsh startup time",
      "unit": "msec",
      "value": $(zsh-startuptime)
  },
  {
      "name": "zsh startup time",
      "unit": "msec",
      "value": $(nvim-startuptime README.md)
  }
]
EOJ
