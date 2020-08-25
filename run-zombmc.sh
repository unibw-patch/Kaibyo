#!/bin/bash

for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo =========================================================
    echo Running $flag.o0.bpl
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag.o0.bpl
    echo Running $flag.o2.bpl
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag.o2.bpl
    echo =========================================================
    # Using fence mitigation
    echo Running $flag.o0.bpl with LFENCE mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag.o0.bpl -lfence
    echo Running $flag.o1.bpl with LFENCE mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag.o2.bpl -lfence
    echo =========================================================
    # Using slh mitigation
    echo Running $flag.o0.bpl with SLH mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag.o0.bpl -slh
    echo Running $flag.o2.bpl with SLH mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag.o2.bpl -slh
    echo =========================================================
    echo
    echo
    echo
done


for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo Running $flag-loop.o0.bpl
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag-loop.o0.bpl
    echo Running $flag-loop.o2.bpl
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag-loop.o2.bpl
    echo =========================================================
    # Using fence mitigation
    echo Running $flag-loop.o0.bpl with LFENCE mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag-loop.o0.bpl -lfence
    echo Running $flag-loop.o1.bpl with LFENCE mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag-loop.o2.bpl -lfence
    echo =========================================================
    # Using slh mitigation
    echo Running $flag-loop.o0.bpl with SLH mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag-loop.o0.bpl -slh
    echo Running $flag-loop.o2.bpl with SLH mitigation
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/$flag-loop.o2.bpl -slh
    echo =========================================================
    echo
    echo
    echo
done
