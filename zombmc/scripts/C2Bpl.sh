#!/bin/bash

SMACKFLAGS="-t --no-memory-splitting --integer-encoding bit-vector -q"
CLANGFLAGS="-fms-extensions -Dzombmc "
DIR=$DAT3M_HOME/benchmarks/spectre

for version in v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15
do
    smack $DIR/spectre-pht.c $SMACKFLAGS --clang-options="$CLANGFLAGS -D"$version -bpl $DIR/bpl/spectre-pht-$version.o0.bpl
    smack $DIR/spectre-pht.c $SMACKFLAGS --clang-options="$CLANGFLAGS -O2 -D"$version -bpl $DIR/bpl/spectre-pht-$version.o2.bpl
done

for version in v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13
do
    smack $DIR/spectre-stl.c $SMACKFLAGS --clang-options="$CLANGFLAGS -D"$version -bpl $DIR/bpl/spectre-stl-$version.bpl
done
