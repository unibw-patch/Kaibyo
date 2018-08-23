for file in $(find litmus/PPC -name '*.litmus' | sort);
do
   java -Xmx128m dartagnan/Dartagnan -t power -i $file > ./dart_power.out
   dart=$(grep -e 'No' dart_power.out | wc -l)
   herd7 -model cat/power.cat $file > ./herd_power.out
   herd=$(grep -e 'No' herd_power.out | wc -l)
   rm dart_power.out
   rm herd_power.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
   java -Xmx128m dartagnan/Dartagnan -t power -i $file -cat cat/power.cat > ./dart_power.out
   dart=$(grep -e 'No' dart_power.out | wc -l)
   rm dart_power.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
done