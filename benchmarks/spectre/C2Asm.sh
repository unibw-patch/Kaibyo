#!/bin/bash

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    for mitigation in none lfence slh
    do
        flags="-S -fdeclspec";
        
        if [[ $mitigation = lfence ]]; then
            flags+=" -mllvm -x86-speculative-load-hardening -mllvm -x86-slh-lfence";
        fi
        
        if [[ $mitigation = slh ]]; then
            flags+=" -mllvm -x86-speculative-load-hardening";
        fi

        clang $flags -Dspectector -D$version spectre.c -o asm/$version.$mitigation.o0.s
        clang $flags -Dspectector -D$version -O2 spectre.c -o asm/$version.$mitigation.o2.s

        clang $flags -Dspectector -D$version spectre-loop.c -o asm/$version-loop.$mitigation.o0.s
        clang $flags -Dspectector -D$version -O2 spectre-loop.c -o asm/$version-loop.$mitigation.o2.s
    done
done
