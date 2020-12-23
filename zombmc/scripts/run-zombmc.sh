#!/bin/bash

TIMEOUT=3600

ZOMBMC="java -jar $DAT3M_HOME/zombmc/target/zombmc-2.0.7-jar-with-dependencies.jar -i"

LOGFOLDER=$DAT3M_HOME/output/logs/zombmc-$(date +%Y-%m-%d_%H:%M)
mkdir -p $LOGFOLDER

RESULT=$DAT3M_HOME/output/zombmc-results.csv
[ -e $RESULT ] && rm $RESULT
TIMES=$DAT3M_HOME/output/zombmc-times.csv
[ -e $TIMES ] && rm $TIMES
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh, o0-ns, o2-ns >> $RESULT
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh, o0-ns, o2-ns >> $TIMES

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    rline=$version
    tline=$version
    for mitigation in none lfence slh ns
    do
        for opt in o0 o2
        do
            flag="";
            if [[ $mitigation != ns ]]; then
                flag+="-sleak ";
            fi
            if [[ $mitigation = ns ]]; then
                flag+="-nospeculation";
            fi
            if [[ $mitigation = lfence ]]; then
                flag+="-lfence";
            fi
            if [[ $mitigation = slh ]]; then
                flag+="-slh";
            fi

            name=$version.$opt
            
            # Some benchmarks require loop unrolling
            if [[ $name = v09.o2 || $version = v10 || $name = v11.o0 ]]; then
                flag+=" -unroll 2";
            fi

            log=$LOGFOLDER/$version.$mitigation.$opt.log
            (time timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag) > $log 2>> $log

            min=$(tail -3 $log | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[1]}')
            sec=$(tail -3 $log | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"."); print a[1]}')
            ms=$(tail -3 $log  | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"."); print a[2]}' | awk '{split($0,a,"s"); print a[1]}')
            tline=$tline", "$((60*min+sec)).$ms

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

