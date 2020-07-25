#!/bin/bash
perf_base="$(dirname `readlink -f "$0"`)"

dateStr=""  #==current

if [[ $1 =~ ^-?-h || $(($# % 2)) != 0 ]]; then
    if ! [ -f "$1" ]; then
      echo "Illegal number of parameters ($#) and $1 is not a file to get the date from"
      echo "Parameters should be in the form 'name1 filter1 name2 filter2 ...'"
      echo 'Optionally, the first parameter can be a file to get the modification timestamp from'
      echo "The optional  environment variable 'capturedFields' decides which field should be included in the report"
      echo "Eg: capturedFields='%CPU %MEM' $0 "
      echo "If capturedFields is not set, only %CPU is reported by default"
      echo 'Example usage:'
      echo '  capturedFields="%CPU %MEM"'" $0 "'top top bash bash < captureFile | transpose.sh | tsv-pretty -u'
      echo 'Processes not matching any of the filters will be reported as "Unmonitored" which can be dropped by the trasnpose.sh script if necessary'
      exit 1
    fi
    #override date from timestamp
    dateStrFromFile=$(date -r "$1" +"%Y %m %d ")
    shift
fi

firstLine=$(head -1)

#override date from embedded magic string i.e: via #echo -ne "__DATE__ "; date +"%Y %m %d"
dateStr=$(echo "$firstLine"|grep -E '^__DATE__ *[12][0-9]{3} [01][0-9] [0123][0-9] *$'|sed  -e 's/^[^0-9]*//' -e 's/ *$//')
if [[ -z "$dateStr" ]]; then
    firstLine="$firstLine\n"
else
    firstLine=""
fi

[[ ! -z "${dateStrFromFile:-}" ]] && dateStr="$dateStrFromFile"

for arg in "$@"
do
  argsString+="$arg\t"
done

declare -a capturedFieldsVar
if [[ ! -z "${capturedFields:-}" ]]; then
  capturedFields=${capturedFields// /$'\t'}
  capturedFieldsVar=(-v capturedFields="$capturedFields")
fi

(echo -ne "$firstLine"; cat)|tr -s ' '|sed 's#^ ##'|awk -v args="$argsString" -v dPref="$dateStr" "${capturedFieldsVar[@]}" -f "$perf_base"/process-top.awk
