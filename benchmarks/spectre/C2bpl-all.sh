#!/bin/bash

for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    smack -t spectre.c --no-memory-splitting --clang-options="-D"$flag" -fms-extensions -I../../include/" -bpl spectre_$flag.bpl --integer-encoding bit-vector
    smack -t spectre.c --no-memory-splitting --clang-options="-O2 -D"$flag" -fms-extensions -I../../include/" -bpl spectre_$flag-opt.bpl --integer-encoding bit-vector
done
