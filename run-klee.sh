#!/bin/bash

timeout=60
whereisklee=~/git/kleespectre/klee/

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo =========================================================
    echo Running $version.none.o0.s
    log=output/logs/klee/$version.none.o0.log
    timeout $timeout $whereisklee/build/bin/klee --search=randomsp --enable-speculative benchmarks/spectre/bc/$version.none.o0.bc 2> $log
    tail -n 1 "$log" | grep "KLEE: Total Spectre found"
    echo Running $version.none.o2.s
    log=output/logs/klee/$version.none.o2.log
    timeout $timeout $whereisklee/build/bin/klee --search=randomsp --enable-speculative benchmarks/spectre/bc/$version.none.o2.bc 2> $log
    tail -n 1 "$log" | grep "KLEE: Total Spectre found"
    echo =========================================================
    echo Running $version-loop.none.o0.s
    log=output/logs/klee/$version-loop.none.o0.log
    timeout $timeout $whereisklee/build/bin/klee --search=randomsp --enable-speculative  benchmarks/spectre/bc/$version-loop.none.o0.bc 2> $log
    tail -n 1 "$log" | grep "KLEE: Total Spectre found"
    echo Running $version-loop.none.o2.s
    log=output/logs/klee/$version-loop.none.o2.log
    timeout $timeout $whereisklee/build/bin/klee --search=randomsp --enable-speculative  benchmarks/spectre/bc/$version-loop.none.o2.bc 2> $log
    tail -n 1 "$log" | grep "KLEE: Total Spectre found"
    echo =========================================================
    echo
    echo
    echo
done
