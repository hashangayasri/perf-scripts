#!/bin/bash

function printField(){
  echo -e $(echo "$2"|tr -s ' '|cut -d ' ' -f $1)
}

function printDetails(){
  echo -ne "$1-CPU"\\t
  printField 9 "$2"
}

while read line
do
  topHeaderRegex='^top - '
  topRecord='^[ 0-9]{3,}'

  if   [[ "$line" =~ $topHeaderRegex ]]; then
    timestamp=$(echo $line|sed -e 's#^[^0-9]*##' -e 's# up.*$##')
    timestampMills=$(date -d "$timestamp" +%s)
    echo -e
    echo -e timestamp\\t$timestampMills
  elif [[ "$line" =~ $topRecord ]]; then
    monitoredProg=false
    isName=true

    for pFilter in "$@"
    do
      if [ "$isName" = true ]; then
        name="$pFilter"
        isName=false
        continue
      fi
      if [[ "$line" =~ $pFilter ]]; then
        monitoredProg=true
        printDetails "$name" "$line"
      fi
      isName=true
    done

    if [ "$monitoredProg" = false ]; then
      printDetails "Unmonitored" "$line"
    fi
  fi
done
