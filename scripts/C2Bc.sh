#!/bin/bash

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    flags="-g -c -emit-llvm -fdeclspec -I\$KLEE_HOME/include/";

    clang-6.0 $flags -Dklee -D$version $DAT3M_HOME/benchmarks/spectre/spectre.c -o $DAT3M_HOME/benchmarks/spectre/bc/$version.none.o0.bc
    clang-6.0 $flags -Dklee -D$version -O2 $DAT3M_HOME/benchmarks/spectre/spectre.c -o $DAT3M_HOME/benchmarks/spectre/bc/$version.none.o2.bc

    clang-6.0 $flags -Dklee -D$version $DAT3M_HOME/benchmarks/spectre/spectre-cloop.c -o $DAT3M_HOME/benchmarks/spectre/bc/$version-cloop.none.o0.bc
    clang-6.0 $flags -Dklee -D$version -O2 $DAT3M_HOME/benchmarks/spectre/spectre-cloop.c -o $DAT3M_HOME/benchmarks/spectre/bc/$version-cloop.none.o2.bc

    clang-6.0 $flags -Dklee -D$version $DAT3M_HOME/benchmarks/spectre/spectre-sloop.c -o $DAT3M_HOME/benchmarks/spectre/bc/$version-sloop.none.o0.bc
    clang-6.0 $flags -Dklee -D$version -O2 $DAT3M_HOME/benchmarks/spectre/spectre-sloop.c -o $DAT3M_HOME/benchmarks/spectre/bc/$version-sloop.none.o2.bc
done
