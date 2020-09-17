#!/bin/bash

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    flags="-g -c -emit-llvm -fdeclspec";

    clang-6.0 $flags -Dspectector -D$version spectre.c -o bc/$version.none.o0.bc
    clang-6.0 $flags -Dspectector -D$version -O2 spectre.c -o bc/$version.none.o2.bc

    clang-6.0 $flags -Dspectector -D$version spectre-loop.c -o bc/$version-loop.none.o0.bc
    clang-6.0 $flags -Dspectector -D$version -O2 spectre-loop.c -o bc/$version-loop.none.o2.bc
done
