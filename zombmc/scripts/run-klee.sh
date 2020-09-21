#!/bin/bash

TIMEOUT=120

CSV=$DAT3M_HOME/output/klee.csv

KLEE=$KLEE_HOME/build/bin/klee
KLEEFLAGS="--search=randomsp --enable-speculative"

[ -e $CSV ] && rm $CSV

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo =========================================================
    
    name=$version.none.o0
    echo Running $name.bc
    log=/$DAT3M_HOME/output/logs/klee/$name.log
    TIMEOUT $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    gadget=$(grep "Spectre found" $log | wc -l)
    echo $name, $gadget >> CSV
    
    NAME=$version.none.o2
    echo Running $name.bc
    log=/$DAT3M_HOME/output/logs/klee/$name.log
    TIMEOUT $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    gadget=$(grep "Spectre found" $log | wc -l)
    echo $name, $gadget >> CSV

    echo =========================================================
    
    NAME=$version-cloop.none.o0
    echo Running $name.bc
    log=/$DAT3M_HOME/output/logs/klee/$name.log
    TIMEOUT $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    gadget=$(grep "Spectre found" $log | wc -l)
    echo $name, $gadget >> CSV

    NAME=$version-cloop.none.o2
    echo Running $name.bc
    log=/$DAT3M_HOME/output/logs/klee/$name.log
    TIMEOUT $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    gadget=$(grep "Spectre found" $log | wc -l)
    echo $name, $gadget >> CSV

    echo =========================================================
    
    NAME=$version-sloop.none.o0
    echo Running $name.bc
    log=/$DAT3M_HOME/output/logs/klee/$name.log
    TIMEOUT $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    gadget=$(grep "Spectre found" $log | wc -l)
    echo $name, $gadget >> CSV

    NAME=$version-sloop.none.o2
    echo Running $name.bc
    log=/$DAT3M_HOME/output/logs/klee/$name.log
    TIMEOUT $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    gadget=$(grep "Spectre found" $log | wc -l)
    echo $name, $gadget >> CSV

    echo =========================================================
    echo
    echo
    echo
done
