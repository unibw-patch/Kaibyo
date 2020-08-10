#!/bin/bash

for flag in v01 v02 v03 v04 v05 v06 v07 v08 v09 v10 v11 v12 v13 v14 v15
do
    echo Running spectre_$flag.bpl
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bv-spectre_$flag.bpl
    echo Running spectre_$flag-opt.bpl
    timeout 60 time java -jar zombmc/target/zombmc-2.0.6-jar-with-dependencies.jar -i benchmarks/spectre/bv-spectre_$flag-opt.bpl
done
