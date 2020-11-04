#!/bin/bash

TIMEOUT=120

CSV=$DAT3M_HOME/output/zombmc.csv
[ -e $CSV ] && rm $CSV

ZOMBMC="java -jar $DAT3M_HOME/zombmc/target/zombmc-2.0.7-jar-with-dependencies.jar -i"

echo benchmark, o0-none, o0-lfence, o0-slh, o2-none, o2-lfence, o2-slh >> $CSV
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version
    for opt in o0 o2
    do
        for mitigation in none lfence slh
        do
            flag="";
            if [[ $mitigation = lfence ]]; then
                flag+="-lfence";
            fi
            if [[ $mitigation = slh ]]; then
                flag+="-slh";
            fi

            name=$version.$opt
            log=$DAT3M_HOME/output/logs/zombmc/$name.log
            timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag > $log
            if [ $(grep "SAFE" $log | wc -l) -eq 0 ]; then
                line=$line", \VarClock"
            else
                if [ $(grep "UNSAFE" $log | wc -l) -eq 0 ]; then
                    line=$line", \gtick"
                else
                    line=$line", \redcross"
                fi
            fi
        done
    done
    echo $line >> $CSV
done

echo benchmark, o0-none, o0-lfence, o0-slh, o2-none, o2-lfence, o2-slh >> $CSV-cloop
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version-cloop
    for opt in o0 o2
    do
        for mitigation in none lfence slh
        do
            flag="";
            if [[ $mitigation = lfence ]]; then
                flag+="-lfence";
            fi
            if [[ $mitigation = slh ]]; then
                flag+="-slh";
            fi

            name=$version-cloop.$opt
            log=$DAT3M_HOME/output/logs/zombmc/$name.log
            timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag > $log
            if [ $(grep "SAFE" $log | wc -l) -eq 0 ]; then
                line=$line", \VarClock"
            else
                if [ $(grep "UNSAFE" $log | wc -l) -eq 0 ]; then
                    line=$line", \gtick"
                else
                    line=$line", \redcross"
                fi
            fi

        done
    done
    echo $line >> $CSV-cloop
done

echo benchmark, o0-none, o0-lfence, o0-slh, o2-none, o2-lfence, o2-slh >> $CSV-sloop
for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    line=$version-sloop
    for opt in o0 o2
    do
        for mitigation in none lfence slh
        do
            flag="";
            if [[ $mitigation = lfence ]]; then
                flag+="-lfence";
            fi
            if [[ $mitigation = slh ]]; then
                flag+="-slh";
            fi

            name=$version-sloop.$opt
            log=$DAT3M_HOME/output/logs/zombmc/$name.log
            timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag > $log
            if [ $(grep "SAFE" $log | wc -l) -eq 0 ]; then
                line=$line", \VarClock"
            else
                if [ $(grep "UNSAFE" $log | wc -l) -eq 0 ]; then
                    line=$line", \gtick"
                else
                    line=$line", \redcross"
                fi
            fi

        done
    done
    echo $line >> $CSV-sloop
done
