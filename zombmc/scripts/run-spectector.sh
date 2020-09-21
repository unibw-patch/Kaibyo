#!/bin/bash

TIMEOUT=120

CSV=$DAT3M_HOME/output/spectector.csv
[ -e $CSV ] && rm $CSV
echo benchmark, safe >> $CSV

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    for mitigation in none lfence slh
    do
        name=$version.$mitigation.o0
        log=$DAT3M_HOME/output/logs/spectector/$name.log
        timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
        safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
        echo $name, $safe >> $CSV

        name=$version.$mitigation.o2
        log=$DAT3M_HOME/output/logs/spectector/$name.log
        timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
        safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
        echo $name, $safe >> $CSV

        name=$version-cloop.$mitigation.o0
        log=$DAT3M_HOME/output/logs/spectector/$name.log
        timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
        safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
        echo $name, $safe >> $CSV

        name=$version-cloop.$mitigation.o2
        log=$DAT3M_HOME/output/logs/spectector/$name.log
        timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
        safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
        echo $name, $safe >> $CSV

        name=$version-sloop.$mitigation.o0
        log=$DAT3M_HOME/output/logs/spectector/$name.log
        timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
        safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
        echo $name, $safe >> $CSV

        name=$version-sloop.$mitigation.o2
        log=$DAT3M_HOME/output/logs/spectector/$name.log
        timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
        safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
        echo $name, $safe >> $CSV

    done
done
