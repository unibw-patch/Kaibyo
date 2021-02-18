#!/bin/bash

SMACKFLAGS="-t --no-memory-splitting --integer-encoding bit-vector -q"
DIR=$DAT3M_HOME/benchmarks/spectre

for version in v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15
do
    smack $DIR/spectre.c $SMACKFLAGS --clang-options="-D"$version" -fms-extensions -I../../include/" -bpl $DIR/bpl/$version.o0.bpl
    smack $DIR/spectre.c $SMACKFLAGS --clang-options="-O2 -D"$version" -fms-extensions -I../../include/" -bpl $DIR/bpl/$version.o2.bpl
done
