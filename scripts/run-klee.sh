#!/bin/bash

timeout=60

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo =========================================================
    echo Running $version.none.o0.bc
    log=/$DAT3M_HOME/output/logs/klee/$version.none.o0.log
    timeout $timeout $KLEE_HOME/build/bin/klee --search=randomsp --enable-speculative $DAT3M_HOME/benchmarks/spectre/bc/$version.none.o0.bc 2> $log
    grep "KLEE: Total Spectre found" $log
    echo Running $version.none.o2.bc
    log=/$DAT3M_HOME/output/logs/klee/$version.none.o2.log
    timeout $timeout $KLEE_HOME/build/bin/klee --search=randomsp --enable-speculative $DAT3M_HOME/benchmarks/spectre/bc/$version.none.o2.bc 2> $log
    grep "KLEE: Total Spectre found" $log
    echo =========================================================
    echo Running $version-cloop.none.o0.bc
    log=/$DAT3M_HOME/output/logs/klee/$version-cloop.none.o0.log
    timeout $timeout $KLEE_HOME/build/bin/klee --search=randomsp --enable-speculative  $DAT3M_HOME/benchmarks/spectre/bc/$version-cloop.none.o0.bc 2> $log
    grep "KLEE: Total Spectre found" $log
    echo Running $version-cloop.none.o2.bc
    log=/$DAT3M_HOME/output/logs/klee/$version-cloop.none.o2.log
    timeout $timeout $KLEE_HOME/build/bin/klee --search=randomsp --enable-speculative  $DAT3M_HOME/benchmarks/spectre/bc/$version-cloop.none.o2.bc 2> $log
    grep "KLEE: Total Spectre found" $log
    echo =========================================================
    echo Running $version-sloop.none.o0.bc
    log=/$DAT3M_HOME/output/logs/klee/$version-sloop.none.o0.log
    timeout $timeout $KLEE_HOME/build/bin/klee --search=randomsp --enable-speculative  $DAT3M_HOME/benchmarks/spectre/bc/$version-sloop.none.o0.bc 2> $log
    grep "KLEE: Total Spectre found" $log
    echo Running $version-sloop.none.o2.bc
    log=/$DAT3M_HOME/output/logs/klee/$version-sloop.none.o2.log
    timeout $timeout $KLEE_HOME/build/bin/klee --search=randomsp --enable-speculative  $DAT3M_HOME/benchmarks/spectre/bc/$version-sloop.none.o2.bc 2> $log
    grep "KLEE: Total Spectre found" $log
    echo =========================================================
    echo
    echo
    echo
done
