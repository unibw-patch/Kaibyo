#!/bin/bash

TIMEOUT=120

LOGFOLDER=$DAT3M_HOME/output/logs/spectector-$(date +%Y-%m-%d_%H:%M)
mkdir $LOGFOLDER

CSV=$DAT3M_HOME/output/spectector.csv
[ -e $CSV ] && rm $CSV
echo benchmark, o0-none, o0-lfence, o0-slh, o2-none, o2-lfence, o2-slh >> $CSV
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version
    for mitigation in none lfence slh
    do
        for opt in o0 o2
        do
            name=$version.$mitigation.$opt
            log=$LOGFOLDER/$name.log
            timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
            to=$(grep "program is" $log | wc -l)
            if [ $to -eq 0 ]; then
                line=$line", \VarClock"
            else
                safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
                if [ $safe -eq 0 ]; then
                    line=$line", \redcross"
                else
                    line=$line", \gtick"
                fi
            fi
        done
    done
    echo $line >> $CSV
done

CSV=$DAT3M_HOME/output/spectector-cloop.csv
[ -e $CSV ] && rm $CSV
echo benchmark, o0-none, o0-lfence, o0-slh, o2-none, o2-lfence, o2-slh >> $CSV
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version
    for mitigation in none lfence slh
    do
        for opt in o0 o2
        do
            name=$version-cloop.$mitigation.$opt
            log=$LOGFOLDER/$name.log
            timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
            to=$(grep "program is" $log | wc -l)
            if [ $to -eq 0 ]; then
                line=$line", \VarClock"
            else
                safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
                if [ $safe -eq 0 ]; then
                    line=$line", \redcross"
                else
                    line=$line", \gtick"
                fi
            fi
        done
    done
    echo $line >> $CSV
done

CSV=$DAT3M_HOME/output/spectector-sloop.csv
[ -e $CSV ] && rm $CSV
echo benchmark, o0-none, o0-lfence, o0-slh, o2-none, o2-lfence, o2-slh >> $CSV
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version
    for mitigation in none lfence slh
    do
        for opt in o0 o2
        do
            name=$version-sloop.$mitigation.$opt
            log=$LOGFOLDER/$name.log
            timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version] > $log
            to=$(grep "program is" $log | wc -l)
            if [ $to -eq 0 ]; then
                line=$line", \VarClock"
            else
                safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
                if [ $safe -eq 0 ]; then
                    line=$line", \redcross"
                else
                    line=$line", \gtick"
                fi
            fi
        done
    done
    echo $line >> $CSV
done
