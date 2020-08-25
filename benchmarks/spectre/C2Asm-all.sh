#!/bin/bash

for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    clang -S -fdeclspec -Dspectector spectre.c -o $flag.o0.s -D$flag
    clang -S -fdeclspec -Dspectector spectre.c -o $flag.o2.s -D$flag -O2
    clang -S -fdeclspec -Dspectector spectre-loop.c -o $flag-loop.o0.s -D$flag
    clang -S -fdeclspec -Dspectector spectre-loop.c -o $flag-loop.o2.s -D$flag -O2
done
