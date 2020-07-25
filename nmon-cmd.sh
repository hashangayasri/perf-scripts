#!/bin/bash
#trap 'echo $nmonPID $catPID; kill -9 $nmonPID $catPID 2>/dev/null; wait $nmonPID $catPID 2>/dev/null; exit' SIGINT EXIT
#trap 'kill $(jobs -p)' EXIT
#trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT


#tmppipe=$(mktemp -u)
#mkfifo -m 600 "$tmppipe"
#nmon -F "$tmppipe" &
#nmonPID=$!
#cat  "$tmppipe" &
#catPID=$!
##(sleep 1 ;rm -f "x$tmppipe") &
#wait

trap "pkill nmon" EXIT

if [[ $# -ne 1 ]]; then
    echo "Illegal number of parameters"
    exit
fi

nmon -s 1 -T -U -F "$1"

sleep 366d
