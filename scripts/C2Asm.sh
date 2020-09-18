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

        clang $flags $DAT3M_HOME/benchmarks/spectre/spectre.c -o $DAT3M_HOME/benchmarks/spectre/asm/$version.$mitigation.o0.s
        clang $flags -Dspectector -D$version -O2 $DAT3M_HOME/benchmarks/spectre/spectre.c -o $DAT3M_HOME/benchmarks/spectre/asm/$version.$mitigation.o2.s

        clang $flags -Dspectector -D$version $DAT3M_HOME/benchmarks/spectre/spectre-cloop.c -o $DAT3M_HOME/benchmarks/spectre/asm/$version-cloop.$mitigation.o0.s
        clang $flags -Dspectector -D$version -O2 $DAT3M_HOME/benchmarks/spectre/spectre-cloop.c -o $DAT3M_HOME/benchmarks/spectre/asm/$version-cloop.$mitigation.o2.s

        clang $flags -Dspectector -D$version $DAT3M_HOME/benchmarks/spectre/spectre-sloop.c -o $DAT3M_HOME/benchmarks/spectre/asm/$version-sloop.$mitigation.o0.s
        clang $flags -Dspectector -D$version -O2 $DAT3M_HOME/benchmarks/spectre/spectre-sloop.c -o $DAT3M_HOME/benchmarks/spectre/asm/$version-sloop.$mitigation.o2.s
    done
done
