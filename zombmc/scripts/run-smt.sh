#!/bin/bash

TIMEOUT=3600

TOOL=$1
THISPATH="/Users/ponce/eclipse-workspace/zombmc/Dat3M/output/"
FILES=`ls /Users/ponce/eclipse-workspace/zombmc/Dat3M/output/*.smt2 | sort -V`

LOGFOLDER=$DAT3M_HOME/output/logs/$TOOL-$(date +%Y-%m-%d_%H:%M)
mkdir -p $LOGFOLDER

RESULT=$DAT3M_HOME/output/$TOOL-results.csv
[ -e $RESULT ] && rm $RESULT
TIMES=$DAT3M_HOME/output/$TOOL-times.csv
[ -e $TIMES ] && rm $TIMES
echo benchmark, o0-none, o0-lfence >> $RESULT
echo benchmark, o0-none, o0-lfence >> $TIMES

for file in $FILES
do
    if [[ $file =~ "fence" ]]; then
      continue
    fi

    shortname=$(basename $file)
    rline=$shortname
    tline=$shortname

    echo "Testing "$shortname" with "$TOOL
    log=$LOGFOLDER/$shortname.log
    (time timeout $TIMEOUT $TOOL $THISPATH$shortname) > $log 2>> $log

    min=$(tail -3 $log | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[1]}')
    sec=$(tail -3 $log | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"."); print a[1]}')
    ms=$(tail -3 $log  | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"."); print a[2]}' | awk '{split($0,a,"s"); print a[1]}')

    if [ $(grep "sat" $log | wc -l) -eq 0 ]; then
      rline=$rline", \VarClock"
      tline=$tline", "$TIMEOUT
    else
      if [ $(grep "unsat" $log | wc -l) -eq 0 ]; then
        rline=$rline", \redcross"
      else
        rline=$rline", \gtick"
      fi
      tline=$tline", "$((60*min+sec)).$ms
    fi

    ## Repeat the same for the version having fences
    shortname="${shortname%.*}"-lfence.smt2
    
    if [ -f "$THISPATH$shortname" ]; then
      echo "Testing "$shortname" with "$TOOL
      log=$LOGFOLDER/$shortname.log
      (time timeout $TIMEOUT $TOOL $THISPATH$shortname) > $log 2>> $log

      min=$(tail -3 $log | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[1]}')
      sec=$(tail -3 $log | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"."); print a[1]}')
      ms=$(tail -3 $log  | awk 'FNR == 1 {print $2}' | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"."); print a[2]}' | awk '{split($0,a,"s"); print a[1]}')

      if [ $(grep "sat" $log | wc -l) -eq 0 ]; then
        rline=$rline", \VarClock"
        tline=$tline", "$TIMEOUT
      else
        if [ $(grep "unsat" $log | wc -l) -eq 0 ]; then
          rline=$rline", \redcross"
        else
          rline=$rline", \gtick"
        fi
        tline=$tline", "$((60*min+sec)).$ms
      fi
    else
      ## The file does not exists
      rline=$rline", N/S"
      tline=$tline", "$TIMEOUT
    fi

    echo $rline >> $RESULT
    echo $tline >> $TIMES
done

