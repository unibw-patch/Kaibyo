#!/bin/bash

TIMEOUT=60

ZOMBMC="java -jar $DAT3M_HOME/zombmc/target/zombmc-2.0.7-jar-with-dependencies.jar -input"
CAT="-cat "$DAT3M_HOME/cat/inorder.cat
FLAGS="-secret secretarray -branch_speculation -branch_speculation_error"

LOGFOLDER=$DAT3M_HOME/output/logs/zombmc-$(date +%Y-%m-%d_%H:%M)
mkdir -p $LOGFOLDER

for version in v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15
do
    # Some benchmarks require loop unrolling
    if [[ $version = v5 ]]; then
        FLAGS+=" -unroll 2";
    fi

    log=$LOGFOLDER/spectre-pht-$version.log
    (timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre-pht/spectre-pht.s $CAT $FLAGS -entry victim_function_$version) > $log 2>> $log

    log=$LOGFOLDER/spectre-pht-lfence-$version.log
    (timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre-pht/spectre-pht-lfence.s $CAT $FLAGS -entry victim_function_$version) > $log 2>> $log
done

CAT="-cat "$DAT3M_HOME/cat/stl.cat
FLAGS="-secret secretarray"
for version in v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13
do
    log=$LOGFOLDER/spectre-stl-$version.log
    (timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre-stl/spectre-stl.s $CAT $FLAGS -entry victim_function_$version) > $log 2>> $log

    log=$LOGFOLDER/spectre-pht-lfence-$version.log
    (timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre-stl/spectre-stl-lfence.s $CAT $FLAGS -entry victim_function_$version) > $log 2>> $log
done
