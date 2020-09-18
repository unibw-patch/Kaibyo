#!/bin/bash

 for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
 do
     smack -t spectre.c --no-memory-splitting --clang-options="-D"$flag" -fms-extensions -I../../include/" -bpl bpl/$flag.o0.bpl --integer-encoding bit-vector
     smack -t spectre.c --no-memory-splitting --clang-options="-O2 -D"$flag" -fms-extensions -I../../include/" -bpl bpl/$flag.o2.bpl --integer-encoding bit-vector

     smack -t spectre-cloop.c --no-memory-splitting --clang-options="-D"$flag" -fms-extensions -I../../include/" -bpl bpl/$flag-cloop.o0.bpl --integer-encoding bit-vector
     smack -t spectre-cloop.c --no-memory-splitting --clang-options="-O2 -D"$flag" -fms-extensions -I../../include/" -bpl bpl/$flag-cloop.o2.bpl --integer-encoding bit-vector

     smack -t spectre-sloop.c --no-memory-splitting --clang-options="-D"$flag" -fms-extensions -I../../include/" -bpl bpl/$flag-sloop.o0.bpl --integer-encoding bit-vector
     smack -t spectre-sloop.c --no-memory-splitting --clang-options="-O2 -D"$flag" -fms-extensions -I../../include/" -bpl bpl/$flag-sloop.o2.bpl --integer-encoding bit-vector
 done
