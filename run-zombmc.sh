#!/bin/bash

timeout=60

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
        echo Running $version.o0.bpl
        timeout $timeout time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bpl/$version.o0.bpl $flag
        echo Running $version.o2.bpl
        timeout $timeout time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bpl/$version.o2.bpl $flag
        echo =========================================================
        echo Running $version-cloop.o0.bpl
        timeout $timeout time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bpl/$version-cloop.o0.bpl $flag
        echo Running $version-cloop.o2.bpl
        timeout $timeout time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bpl/$version-cloop.o2.bpl $flag
        echo =========================================================
        echo Running $version-sloop.o0.bpl
        timeout $timeout time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bpl/$version-sloop.o0.bpl $flag
        echo Running $version-sloop.o2.bpl
        timeout $timeout time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bpl/$version-sloop.o2.bpl $flag
        echo =========================================================
        echo
        echo
        echo
    done
done
