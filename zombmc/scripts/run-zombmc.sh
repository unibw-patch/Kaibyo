#!/bin/bash

TIMEOUT=180

ZOMBMC="java -jar $DAT3M_HOME/zombmc/target/zombmc-2.0.7-jar-with-dependencies.jar -i"

LOGFOLDER=$DAT3M_HOME/output/logs/zombmc-$(date +%Y-%m-%d_%H:%M)
mkdir -p $LOGFOLDER

RESULT=$DAT3M_HOME/output/zombmc-results.csv
[ -e $RESULT ] && rm $RESULT
TIMES=$DAT3M_HOME/output/zombmc-times.csv
[ -e $TIMES ] && rm $TIMES
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh, o0-np, o2-np >> $RESULT
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh, o0-np, o2-np >> $TIMES

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    rline=$version
    tline=$version
    for mitigation in none lfence slh nospeculation
    do
        for opt in o0 o2
        do
            flag="";
            if [[ $mitigation = nospeculation ]]; then
                flag+="-nospeculation";
            fi
            if [[ $mitigation = lfence ]]; then
                flag+="-lfence";
            fi
            if [[ $mitigation = slh ]]; then
                flag+="-slh";
            fi

            name=$version.$opt
            log=$LOGFOLDER/$version.$mitigation.$opt.log
            (time timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag) > $log 2> $log.time

            tline=$tline", "$(awk 'FNR == 2 {print $2}' $log.time | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"s"); print a[1]}')

            if [ $(grep "SAFE" $log | wc -l) -eq 0 ]; then
                if [ $(grep "UNKNOWN" $log | wc -l) -eq 0 ]; then
                    rline=$rline", \VarClock"
                else
                    rline=$rline", \$\mathtt{\qm}\$"
                fi
            else
                if [ $(grep "UNSAFE" $log | wc -l) -eq 0 ]; then
                    rline=$rline", \gtick"
                else
                    rline=$rline", \redcross"
                fi
            fi
        done
    done
    echo $rline >> $RESULT
    echo $tline >> $TIMES
done

