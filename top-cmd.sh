#!/bin/bash

echo -ne "__DATE__ "; date +"%Y %m %d" #optional

#test args option
top -b -n 1 -c  |grep -q this_is_my_unique_argument && enableArgs="-c"

COLUMNS=512 top -b -d 1 "$enableArgs"
