#!/bin/bash

timeout=60

for version in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    for mitigation in none lfence slh
    do
        echo =========================================================
        echo Running $version.$mitigation.o0.s
        log=output/logs/$version.$mitigation.o0.log
        timeout $timeout spectector benchmarks/spectre/$version.$mitigation.o0.s -e [victim_function_$version] > $log
        if grep -q "[program is unsafe]" $log; then
            echo FAIL
        else
            echo PASS
        fi
        
        echo Running $version.$mitigation.o2.s
        log=output/logs/$version.$mitigation.o2.log
        timeout $timeout spectector benchmarks/spectre/$version.$mitigation.o2.s -e [victim_function_$version] > $log
        if grep -q "[program is unsafe]" $log; then
            echo FAIL
        else
            echo PASS
        fi
        
        echo =========================================================
        echo Running $version-loop.$mitigation.o0.s
        log=output/logs/$version-loop.$mitigation.o0.log
        timeout $timeout spectector benchmarks/spectre/$version-loop.$mitigation.o0.s -e [victim_function_$version] > $log
        if grep -q "[program is unsafe]" $log; then
            echo FAIL
        else
            echo PASS
        fi

        echo Running $version-loop.$mitigation.o2.s
        log=output/logs/$version-loop.$mitigation.o2.log
        timeout $timeout spectector benchmarks/spectre/$version-loop.$mitigation.o2.s -e [victim_function_$version] > $log
        if grep -q "[program is unsafe]" $log; then
            echo FAIL
        else
            echo PASS
        fi
    done
    echo =========================================================
    echo
    echo
    echo
done
