#!/bin/bash

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    for mitigation in none lfence slh
    do
        if [[ $mitigation = none ]]; then
            flags="-S -fdeclspec";
        fi
        
        if [[ $mitigation = lfence ]]; then
            flags="-S -fdeclspec -mllvm -x86-speculative-load-hardening -mllvm -x86-slh-lfence";
        fi
        
        if [[ $mitigation = slh ]]; then
            flags="-S -fdeclspec -mllvm -x86-speculative-load-hardening";
        fi

        clang $flags -Dspectector spectre.c -o $version.$mitigation.o0.s -D$version
        clang $flags -Dspectector spectre.c -o $version.$mitigation.o2.s -D$version -O2

        clang $flags -Dspectector spectre-loop.c -o $version-loop.$mitigation.o0.s -D$version
        clang $flags -Dspectector spectre-loop.c -o $version-loop.$mitigation.o2.s -D$version -O2
    done
done
