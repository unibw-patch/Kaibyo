#!/bin/bash

TIMEOUT=60

ZOMBMC="java -jar $DAT3M_HOME/zombmc/target/zombmc-2.0.7-jar-with-dependencies.jar -i"
CAT="-cat "$DAT3M_HOME/cat/sc.cat

LOGFOLDER=$DAT3M_HOME/output/logs/zombmc-$(date +%Y-%m-%d_%H:%M)
mkdir -p $LOGFOLDER

RESULT=$DAT3M_HOME/output/zombmc-spectre-pht-results.csv
[ -e $RESULT ] && rm $RESULT
TIMES=$DAT3M_HOME/output/zombmc-spectre-pht-times.csv
[ -e $TIMES ] && rm $TIMES
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh, o0-ns, o2-ns >> $RESULT
echo benchmark, o0-none, o2-none, o0-lfence, o2-lfence, o0-slh, o2-slh, o0-ns, o2-ns >> $TIMES

for version in v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15
do
    rline=$version
    tline=$version
    for mitigation in none lfence slh ns
    do
        for opt in o0 o2
        do
            flag="-secret secret ";
            if [[ $mitigation != ns ]]; then
                flag+="-branch_speculation -branch_speculation_error ";
            fi
            if [[ $mitigation = lfence ]]; then
                flag+="-lfence";
            fi
            if [[ $mitigation = slh ]]; then
                flag+="-slh";
            fi

            # Some benchmarks require loop unrolling
            if [[ $version.$opt = v5.o0 || $version.$opt = v9.o2 || $version = v10 || $version.$opt = v11.o0 ]]; then
                flag+=" -unroll 2";
            fi

            log=$LOGFOLDER/spectre-pht-$version.$mitigation.$opt.log
            (timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/spectre-pht-$version.$opt.bpl $CAT $flag) > $log 2>> $log

            min=$(tail -1 $log | awk 'FNR == 1 {print $3}' | awk '{split($0,a,":"); print a[1]}')
            min=${min#0}
            sec=$(tail -1 $log | awk 'FNR == 1 {print $3}' | awk '{split($0,a,":"); print a[2]}')
            sec=${sec#0}
            ms=$(tail -1 $log  | awk 'FNR == 1 {print $3}' | awk '{split($0,a,":"); print a[3]}')
            ms=${ms#0}

            if [ $(grep "SAFE" $log | wc -l) -eq 0 ]; then
                if [ $(grep "UNKNOWN" $log | wc -l) -eq 0 ]; then
                    rline=$rline", \VarClock"
                    tline=$tline", "$TIMEOUT
                else
                    rline=$rline", \$\mathtt{\qm}\$"
	            tline=$tline", "$((60*min+sec)).$ms
                fi
            else
                if [ $(grep "UNSAFE" $log | wc -l) -eq 0 ]; then
                    rline=$rline", \gtick"
                else
                    rline=$rline", \redcross"
                fi
                tline=$tline", "$((60*min+sec)).$ms
            fi
        done
    done
    echo $rline >> $RESULT
    echo $tline >> $TIMES
done

RESULT=$DAT3M_HOME/output/zombmc-spectre-stl-results.csv
[ -e $RESULT ] && rm $RESULT
TIMES=$DAT3M_HOME/output/zombmc-spectre-stl-times.csv
[ -e $TIMES ] && rm $TIMES
echo benchmark, sc, stl >> $RESULT
echo benchmark, sc, stl >> $TIMES

for version in v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13
do
    rline=$version
    tline=$version
    for mm in sc stl
    do
        CAT="-cat "$DAT3M_HOME/cat/$mm.cat
        flag="-secret secretarray ";
        name=spectre-stl-$version

        log=$LOGFOLDER/spectre-stl-$version.$mm.log
        (timeout $TIMEOUT $ZOMBMC $DAT3M_HOME/benchmarks/spectre/bpl/$name.bpl $CAT $flag) > $log 2>> $log

        min=$(tail -1 $log | awk 'FNR == 1 {print $3}' | awk '{split($0,a,":"); print a[1]}')
        min=${min#0}
        sec=$(tail -1 $log | awk 'FNR == 1 {print $3}' | awk '{split($0,a,":"); print a[2]}')
        sec=${sec#0}
        ms=$(tail -1 $log  | awk 'FNR == 1 {print $3}' | awk '{split($0,a,":"); print a[3]}')
        ms=${ms#0}

        if [ $(grep "SAFE" $log | wc -l) -eq 0 ]; then
            if [ $(grep "UNKNOWN" $log | wc -l) -eq 0 ]; then
                rline=$rline", \VarClock"
                tline=$tline", "$TIMEOUT
            else
                rline=$rline", \$\mathtt{\qm}\$"
	        tline=$tline", "$((60*min+sec)).$ms
            fi
        else
            if [ $(grep "UNSAFE" $log | wc -l) -eq 0 ]; then
                rline=$rline", \gtick"
            else
                rline=$rline", \redcross"
            fi
            tline=$tline", "$((60*min+sec)).$ms
        fi
    done
    echo $rline >> $RESULT
    echo $tline >> $TIMES
done

