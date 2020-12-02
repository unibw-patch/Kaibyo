#!/bin/bash

TIMEOUT=300

LOGFOLDER=$DAT3M_HOME/output/logs/spectector-$(date +%Y-%m-%d_%H:%M)
mkdir -p $LOGFOLDER

RESULT=$DAT3M_HOME/output/spectector-results.csv
[ -e $RESULT ] && rm $RESULT
TIMES=$DAT3M_HOME/output/spectector-times.csv
[ -e $TIMES ] && rm $TIMES
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh >> $RESULT
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh >> $TIMES

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    rline=$version
    tline=$version
    for mitigation in none lfence slh
    do
        for opt in o0 o2
        do
            name=$version.$mitigation.$opt
            log=$LOGFOLDER/$name.log
            (time timeout $TIMEOUT spectector $DAT3M_HOME/benchmarks/spectre/asm/$name.s -e [victim_function_$version]) > $log 2> $log.time
            
            tline=$tline", "$(awk 'FNR == 2 {print $2}' $log.time | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"s"); print a[1]}')

            to=$(grep "program is" $log | wc -l)
            if [ $to -eq 0 ]; then
                rline=$rline", \VarClock"
            else
                safe=$(tail -n 1 "$log" | grep "program is safe" | wc -l)
                if [ $safe -eq 0 ]; then
                    rline=$rline", \redcross"
                else
                    rline=$rline", \gtick"
                fi
            fi
        done
    done
    echo $rline >> $RESULT
    echo $tline >> $TIMES
done
