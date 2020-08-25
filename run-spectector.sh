#!/bin/bash

timeout=60

for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo =========================================================
    echo Running $flag.o0.s
    timeout $timeout spectector $flag.o0.s -e [victim_function_$flag]
    echo Running $flag.o2.s
    timeout $timeout spectector $flag.o2.s -e [victim_function_$flag]
    echo =========================================================
    # Using fence mitigation
    echo Running $flag.lfence.o0.s with LFENCE mitigation
    timeout $timeout spectector $flag.lfence.o0.s -e [victim_function_$flag]
    echo Running $flag.lfence.o1.s with LFENCE mitigation
    timeout $timeout spectector $flag.lfence.o2.s -e [victim_function_$flag]
    echo =========================================================
    # Using slh mitigation
    echo Running $flag.slh.o0.s with LFENCE mitigation
    timeout $timeout spectector $flag.slh.o0.s -e [victim_function_$flag]
    echo Running $flag.slh.o1.s with LFENCE mitigation
    timeout $timeout spectector $flag.slh.o2.s -e [victim_function_$flag]
    echo =========================================================
    echo
    echo
    echo
done


for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo =========================================================
    echo Running $flag-loop.o0.s
    timeout $timeout spectector $flag-loop.o0.s -e [victim_function_$flag]
    echo Running $flag-loop.o2.s
    timeout $timeout spectector $flag-loop.o2.s -e [victim_function_$flag]
    echo =========================================================
    # Using fence mitigation
    echo Running $flag-loop.lfence.o0.s with LFENCE mitigation
    timeout $timeout spectector $flag-loop.lfence.o0.s -e [victim_function_$flag]
    echo Running $flag-loop.lfence.o1.s with LFENCE mitigation
    timeout $timeout spectector $flag-loop.lfence.o2.s -e [victim_function_$flag]
    echo =========================================================
    # Using slh mitigation
    echo Running $flag-loop.slh.o0.s with LFENCE mitigation
    timeout $timeout spectector $flag-loop.slh.o0.s -e [victim_function_$flag]
    echo Running $flag-loop.slh.o1.s with LFENCE mitigation
    timeout $timeout spectector $flag-loop.slh.o2.s -e [victim_function_$flag]
    echo =========================================================
    echo
    echo
    echo
done
