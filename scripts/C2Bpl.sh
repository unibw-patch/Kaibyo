#!/bin/bash

for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    flags0=--integer-encoding bit-vector --no-memory-splitting --clang-options="-D"$flag" -fms-extensions -I \$DAT3M_HOME/include/" -bpl
    flags2=--integer-encoding bit-vector --no-memory-splitting --clang-options="-O2 -D"$flag" -fms-extensions -I \$DAT3M_HOME/include/" -bpl
    
    smack -t $DAT3M_HOME/benchmarks/spectre/spectre.c $flags0 $DAT3M_HOME/benchmarks/spectre/bpl/$flag.o0.bpl
    smack -t $DAT3M_HOME/benchmarks/spectre/spectre.c $flags2 $DAT3M_HOME/benchmarks/spectre/bpl/$flag.o2.bpl

    smack -t $DAT3M_HOME/benchmarks/spectre/spectre-cloop.c $flags0 $DAT3M_HOME/benchmarks/spectre/bpl/$flag-cloop.o0.bpl
    smack -t $DAT3M_HOME/benchmarks/spectre/spectre-cloop.c $flags2 $DAT3M_HOME/benchmarks/spectre/bpl/$flag-cloop.o2.bpl

    smack -t $DAT3M_HOME/benchmarks/spectre/spectre-sloop.c $flags0 $DAT3M_HOME/benchmarks/spectre/bpl/$flag-sloop.o0.bpl
    smack -t $DAT3M_HOME/benchmarks/spectre/spectre-sloop.c $flags2 $DAT3M_HOME/benchmarks/spectre/bpl/$flag-sloop.o2.bpl
done
