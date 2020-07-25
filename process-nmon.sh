#!/bin/bash
perf_base="$(dirname `readlink -f "$0"`)"

#$1 == abbriviation descriptions
(echo -e "\n\nZZZZ,TimeCode,Time,Date"; grep -Ev '^([^Z])\1\1|^TOP|^UARG|^CPUUTIL[^_]') | tr ',' '\t' | awk -f "$perf_base"/map-rows.awk | sed 's#^\t*##' | awk -f "$perf_base"/process-nmon.awk -v descriptions="$1" | sed 's#^\t##' | awk -f "$perf_base"/transpose-columns.awk | awk -v newLines=2 -f "$perf_base"/collapse-newlines.awk | "$perf_base"/transpose.sh
