#!/bin/bash
perf_base="$(dirname `readlink -f "$0"`)"

tr -d '\0'|awk -f "$perf_base"/iostat-timestamp-and-header.awk|tr '\t' ' '|tr -s ' '|tr ' ' '\t'| sed -e 's#avg-cpu:#cpu#' -e 's#^Linux.*$##'|awk -f "$perf_base"/transpose-columns.awk|awk -v newLines=3 -f "$perf_base"/collapse-newlines.awk|tr -d '\0'
