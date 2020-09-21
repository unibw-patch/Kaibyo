#!/bin/bash

TIMEOUT=120

CSV=$DAT3M_HOME/output/zombmc.csv
[ -e $CSV ] && rm $CSV
echo benchmark, safe >> $CSV
            
ZOMBMC="java -jar $DAT3M_HOME/zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i"

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

        name=$version.o0
        result=$(timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag)
        echo $result > $DAT3M_HOME/output/logs/zombmc/$name.log
        to=$(grep "SAFE" $log | wc -l)
        if [ $to -eq 0 ]; then
            echo $name, -1 >> $CSV
        else
            unsafe=$(grep "UNSAFE" $log | wc -l)
            if [ $unsafe -eq 0 ]; then
                echo $name, 1 >> $CSV
            else
                echo $name, 0 >> $CSV
            fi
        fi

        name=$version.o2
        result=$(timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag)
        echo $result > $DAT3M_HOME/output/logs/zombmc/$name.log
        to=$(grep "SAFE" $log | wc -l)
        if [ $to -eq 0 ]; then
            echo $name, -1 >> $CSV
        else
            unsafe=$(grep "UNSAFE" $log | wc -l)
            if [ $unsafe -eq 0 ]; then
                echo $name, 1 >> $CSV
            else
                echo $name, 0 >> $CSV
            fi
        fi

        name=$version-cloop.o0
        result=$(timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag)
        echo $result > $DAT3M_HOME/output/logs/zombmc/$name.log
        to=$(grep "SAFE" $log | wc -l)
        if [ $to -eq 0 ]; then
            echo $name, -1 >> $CSV
        else
            unsafe=$(grep "UNSAFE" $log | wc -l)
            if [ $unsafe -eq 0 ]; then
                echo $name, 1 >> $CSV
            else
                echo $name, 0 >> $CSV
            fi
        fi

        name=$version-cloop.o2
        result=$(timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag)
        echo $result > $DAT3M_HOME/output/logs/zombmc/$name.log
        to=$(grep "SAFE" $log | wc -l)
        if [ $to -eq 0 ]; then
            echo $name, -1 >> $CSV
        else
            unsafe=$(grep "UNSAFE" $log | wc -l)
            if [ $unsafe -eq 0 ]; then
                echo $name, 1 >> $CSV
            else
                echo $name, 0 >> $CSV
            fi
        fi

        name=$version-sloop.o0
        result=$(timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag)
        echo $result > $DAT3M_HOME/output/logs/zombmc/$name.log
        to=$(grep "SAFE" $log | wc -l)
        if [ $to -eq 0 ]; then
            echo $name, -1 >> $CSV
        else
            unsafe=$(grep "UNSAFE" $log | wc -l)
            if [ $unsafe -eq 0 ]; then
                echo $name, 1 >> $CSV
            else
                echo $name, 0 >> $CSV
            fi
        fi

        name=$version-sloop.o2
        result=$(timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $flag)
        echo $result > $DAT3M_HOME/output/logs/zombmc/$name.log
        to=$(grep "SAFE" $log | wc -l)
        if [ $to -eq 0 ]; then
            echo $name, -1 >> $CSV
        else
            unsafe=$(grep "UNSAFE" $log | wc -l)
            if [ $unsafe -eq 0 ]; then
                echo $name, 1 >> $CSV
            else
                echo $name, 0 >> $CSV
            fi
        fi

    done
done
