#!/bin/bash
#Usage testingToTraining.sh [testing dataset] [num blacklist items] [num normal items]
printf "chr1_\nchr3_\nchr5_\nchr7_\nchr9_\nchr11_\nchr13_\nchr15_\nchr17_\nchr19_\nchr21_\nchrY_" > trainingFilter
grep "blacklist" $1 | shuf | grep -f trainingFilter | head -n $2 > trainingSorted.csv
grep "normal" $1 | shuf | grep -f trainingFilter | head -n $3 >> trainingSorted.csv
head -n 1 $1 > testingPartial.csv
cat trainingSorted.csv | shuf >> testingPartial.csv
rm trainingSorted.csv
rm trainingFilter
