#!/bin/bash

DIR=$DAT3M_HOME/benchmarks/spectre

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15 and-mask dead-code
do
    for mitigation in none ns
    do
        flags="-g -c -Dklee -emit-llvm -fdeclspec -I $KLEE_HOME/include/ -D"$version;

        clang-6.0 $flags $DIR/spectre.c -o $DIR/bc/$version.$mitigation.o0.bc
        clang-6.0 $flags -O2 $DIR/spectre.c -o $DIR/bc/$version.$mitigation.o2.bc
    done
done
