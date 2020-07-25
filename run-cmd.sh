#!/bin/bash
perf_base="$(dirname `readlink -f "$0"`)"

#prefix=""
#if [ ! -z "$1" ]; then 
#    prefix="$1_-"
#fi

function killBackground(){
    if [ "$killed" = true ]; then
        return
    fi
    jobs -p | xargs kill -9
    jobs
    pkill top
    jobs
    killed=true
}

trap killBackground EXIT

"$perf_base"/top-cmd.sh > top.out &
"$perf_base"/iostat-cmd.sh > iostat.out &

#######################################
cd "$1"
shift
#run command
eval "$@" | tee process.out
#######################################

echo process exited...
