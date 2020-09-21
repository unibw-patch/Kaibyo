#!/bin/bash

TIMEOUT=120
ZOMBMC="java -jar $DAT3M_HOME/zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar"

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
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

        echo =========================================================
        
        name=$version.o0
        log=/$DAT3M_HOME/output/logs/zombmc/$name.log
        echo Running $name.bpl
        timeout $TIMEOUT $ZOMBMC -i $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag 2> $log
        unsafe=$(grep "UNSAFE" $log | wc -l)
        echo $name, $(1 - $unsafe) >> $CSV

        name=$version.o2
        log=/$DAT3M_HOME/output/logs/zombmc/$name.log
        echo Running $name.bpl
        timeout $TIMEOUT $ZOMBMC -i $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag 2> $log
        unsafe=$(grep "UNSAFE" $log | wc -l)
        echo $name, $(1 - $unsafe) >> $CSV

        echo =========================================================
        
        name=$version-cloop.o0
        log=/$DAT3M_HOME/output/logs/zombmc/$name.log
        echo Running $name.bpl
        timeout $TIMEOUT $ZOMBMC -i $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag 2> $log
        unsafe=$(grep "UNSAFE" $log | wc -l)
        echo $name, $(1 - $unsafe) >> $CSV

        name=$version-cloop.o2
        log=/$DAT3M_HOME/output/logs/zombmc/$name.log
        echo Running $name.bpl
        timeout $TIMEOUT $ZOMBMC -i $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag 2> $log
        unsafe=$(grep "UNSAFE" $log | wc -l)
        echo $name, $(1 - $unsafe) >> $CSV

        echo =========================================================
        
        name=$version-sloop.o0
        log=/$DAT3M_HOME/output/logs/zombmc/$name.log
        echo Running $name.bpl
        timeout $TIMEOUT $ZOMBMC -i $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag 2> $log
        unsafe=$(grep "UNSAFE" $log | wc -l)
        echo $name, $(1 - $unsafe) >> $CSV

        name=$version-sloop.o2
        log=/$DAT3M_HOME/output/logs/zombmc/$name.log
        echo Running $name.bpl
        timeout $TIMEOUT $ZOMBMC -i $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag 2> $log
        unsafe=$(grep "UNSAFE" $log | wc -l)
        echo $name, $(1 - $unsafe) >> $CSV

        echo =========================================================
        echo
        echo
        echo
    done
done
