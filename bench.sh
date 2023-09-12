#!/bin/sh

os=$(uname -s | tr '[:upper:]' '[:lower:]')

case $os in
    darwin)
        TIME_COMMAND=gtime
    ;;
    linux)
        TIME_COMMAND="time"
    ;;
esac

$TIME_COMMAND --format="%e" zsh -i -c exit > /dev/null 2>&1

ZSH_STARTUPTIME=$({ for _ in $(seq 1 10); do $TIME_COMMAND --format="%e" zsh -i -c exit; done } 2>&1 | awk '{ total += $1 } END { print total/NR*1000 }')

cat<<EOJ
{
    "name": "zsh startup time",
    "unit": "msec",
    "value": ${ZSH_STARTUPTIME}
}
EOJ
