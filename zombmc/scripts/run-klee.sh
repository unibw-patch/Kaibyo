#!/bin/bash

TIMEOUT=300

KLEE=$KLEE_HOME/build/bin/klee
KLEEFLAGS="--search=randomsp --enable-speculative"

LOGFOLDER=$DAT3M_HOME/output/logs/klee-$(date +%Y-%m-%d_%H:%M)
mkdir -p $LOGFOLDER

RESULT=$DAT3M_HOME/output/klee-results.csv
[ -e $RESULT ] && rm $RESULT
TIMES=$DAT3M_HOME/output/klee-times.csv
[ -e $TIMES ] && rm $TIMES
echo benchmark, o0-none, o2-none >> $RESULT
echo benchmark, o0-none, o2-none >> $TIMES

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    rline=$version
    tline=$version
    for opt in o0 o2
    do
        name=$version.none.$opt
        log=$LOGFOLDER/$name.log
        (time timeout $TIMEOUT $KLEE $KLEEFLAGS $DAT3M_HOME/benchmarks/spectre/bc/$name.bc) 2> $log 2> $log.time
        
        tline=$tline", "$(awk 'FNR == 2 {print $2}' $log.time | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"s"); print a[1]}')

        to=$(grep "Spectre found" $log | wc -l)
        if [ $to -eq 0 ]; then
            rline=$rline", \VarClock"
        else
            safe=$(grep "Spectre found: 0" $log | wc -l)
            if [ $safe -eq 0 ]; then
                rline=$rline", \redcross"
            else
                rline=$rline", \gtick"
            fi
        fi
    done
    echo $rline >> $RESULT
    echo $tline >> $TIMES
done
