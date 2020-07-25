#!/bin/bash
perf_base="$(dirname `readlink -f "$0"`)"

for arg in "$@"
do
  argsString+="$arg\t"
done
awk -v fields="$argsString" -f "$perf_base"/transpose.awk
