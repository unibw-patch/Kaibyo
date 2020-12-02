#!/bin/bash

DIR=$DAT3M_HOME/benchmarks/spectre

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    for mitigation in none lfence slh
    do
        flags="-S -fdeclspec -D"$version" -Dspectector";

        if [[ $mitigation = lfence ]]; then
            flags+=" -mllvm -x86-speculative-load-hardening -mllvm -x86-slh-lfence";
        fi

        if [[ $mitigation = slh ]]; then
            flags+=" -mllvm -x86-speculative-load-hardening";
        fi

        clang $flags $DIR/spectre.c -o $DIR/asm/$version.$mitigation.o0.s
        clang $flags -O2 $DIR/spectre.c -o $DIR/asm/$version.$mitigation.o2.s
    done
done
