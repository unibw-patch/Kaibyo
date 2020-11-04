#!/bin/bash

TIMEOUT=120

KLEE=$KLEE_HOME/build/bin/klee
KLEEFLAGS="--search=randomsp --enable-speculative"

CSV=$DAT3M_HOME/output/klee.csv
[ -e $CSV ] && rm $CSV
echo benchmark, o0-none, o2-none >> $CSV
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version
    for opt in o0 o2
    do
        name=$version.none.$opt
        log=$DAT3M_HOME/output/logs/klee/$name.log
        timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
        to=$(grep "Spectre found" $log | wc -l)
        if [ $to -eq 0 ]; then
            line=$line", \VarClock"
        else
            safe=$(grep "Spectre found: 0" $log | wc -l)
            if [ $safe -eq 0 ]; then
                line=$line", \gtick"
            else
                line=$line", \redcross"
            fi
        fi
    done
    echo $line >> $CSV
done

CSV=$DAT3M_HOME/output/klee-cloop.csv
[ -e $CSV ] && rm $CSV
echo benchmark, o0-none, o2-none >> $CSV
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version
    for opt in o0 o2
    do
        name=$version-cloop.none.$opt
        log=$DAT3M_HOME/output/logs/klee/$name.log
        timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
        to=$(grep "Spectre found" $log | wc -l)
        if [ $to -eq 0 ]; then
            line=$line", \VarClock"
        else
            safe=$(grep "Spectre found: 0" $log | wc -l)
            if [ $safe -eq 0 ]; then
                line=$line", \gtick"
            else
                line=$line", \redcross"
            fi
        fi
    done
    echo $line >> $CSV
done

CSV=$DAT3M_HOME/output/klee-sloop.csv
[ -e $CSV ] && rm $CSV
echo benchmark, o0-none, o2-none >> $CSV
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version
    for opt in o0 o2
    do
        name=$version-sloop.none.$opt
        log=$DAT3M_HOME/output/logs/klee/$name.log
        timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc 2> $log
        to=$(grep "Spectre found" $log | wc -l)
        if [ $to -eq 0 ]; then
            line=$line", \VarClock"
        else
            safe=$(grep "Spectre found: 0" $log | wc -l)
            if [ $safe -eq 0 ]; then
                line=$line", \gtick"
            else
                line=$line", \redcross"
            fi
        fi
    done
    echo $line >> $CSV
done
