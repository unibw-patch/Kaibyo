#!/bin/bash

TIMEOUT=120

CSV=$DAT3M_HOME/output/klee.csv
[ -e $CSV ] && rm $CSV
echo benchmark, safe >> $CSV

KLEE=$KLEE_HOME/build/bin/klee
KLEEFLAGS="--search=randomsp --enable-speculative"

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    name=$version.none.o0
    log=$DAT3M_HOME/output/logs/klee/$name.log
    timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    to=$(grep "Spectre found" $log | wc -l)
    if [ $to -eq 0 ]; then
        echo $name, \VarClock >> $CSV
    else
        safe=$(grep "Spectre found: 0" $log | wc -l)
        if [ $safe -eq 0 ]; then
            echo $name, \redcross >> $CSV
        else
            echo $name, \gtick >> $CSV
        fi
    fi

    name=$version.none.o2
    log=$DAT3M_HOME/output/logs/klee/$name.log
    timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    to=$(grep "Spectre found" $log | wc -l)
    if [ $to -eq 0 ]; then
        echo $name, \VarClock >> $CSV
    else
        safe=$(grep "Spectre found: 0" $log | wc -l)
        if [ $safe -eq 0 ]; then
            echo $name, \redcross >> $CSV
        else
            echo $name, \gtick >> $CSV
        fi
    fi

    name=$version-cloop.none.o0
    log=$DAT3M_HOME/output/logs/klee/$name.log
    timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    to=$(grep "Spectre found" $log | wc -l)
    if [ $to -eq 0 ]; then
        echo $name, \VarClock >> $CSV
    else
        safe=$(grep "Spectre found: 0" $log | wc -l)
        if [ $safe -eq 0 ]; then
            echo $name, \redcross >> $CSV
        else
            echo $name, \gtick >> $CSV
        fi
    fi

    name=$version-cloop.none.o2
    log=$DAT3M_HOME/output/logs/klee/$name.log
    timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    to=$(grep "Spectre found" $log | wc -l)
    if [ $to -eq 0 ]; then
        echo $name, \VarClock >> $CSV
    else
        safe=$(grep "Spectre found: 0" $log | wc -l)
        if [ $safe -eq 0 ]; then
            echo $name, \redcross >> $CSV
        else
            echo $name, \gtick >> $CSV
        fi
    fi

    name=$version-sloop.none.o0
    log=$DAT3M_HOME/output/logs/klee/$name.log
    timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    to=$(grep "Spectre found" $log | wc -l)
    if [ $to -eq 0 ]; then
        echo $name, \VarClock >> $CSV
    else
        safe=$(grep "Spectre found: 0" $log | wc -l)
        if [ $safe -eq 0 ]; then
            echo $name, \redcross >> $CSV
        else
            echo $name, \gtick >> $CSV
        fi
    fi

    name=$version-sloop.none.o2
    log=$DAT3M_HOME/output/logs/klee/$name.log
    timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
    to=$(grep "Spectre found" $log | wc -l)
    if [ $to -eq 0 ]; then
        echo $name, \VarClock >> $CSV
    else
        safe=$(grep "Spectre found: 0" $log | wc -l)
        if [ $safe -eq 0 ]; then
            echo $name, \redcross >> $CSV
        else
            echo $name, \gtick >> $CSV
        fi
    fi

done
