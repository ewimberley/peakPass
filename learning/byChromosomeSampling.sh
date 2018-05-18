#!/bin/bash
#Usage testingToTraining.sh [testing dataset] [blacklist file] [num blacklist items] [num normal items]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#printf "chr1_\nchr3_\nchr5_\nchr7_\nchr9_\nchr11_\nchr13_\nchr15_\nchr17_\nchr19_\nchr21_\nchrY_" > trainingFilter
$SRC_DIR/randomChromosomes.py $2 8 | sed 's/.*/\0_/' > trainingFilter_$7
grep "blacklist" $1 | shuf | grep -v -f trainingFilter_$7 | head -n $3 > trainingSorted_$7.csv
grep "normal" $1 | shuf | grep -v -f trainingFilter_$7 | head -n $4 >> trainingSorted_$7.csv
#Line below can be used to remove very similar items from the majority class
#grep "normal" $1 | shuf | grep -v -f trainingFilter | $SRC_DIR/reduceTrainingSimilarity.sh | head -n $4 >> trainingSorted.csv
head -n 1 $1 > training_$7.csv
cat trainingSorted_$7.csv | shuf >> training_$7.csv
rm trainingSorted_$7.csv

grep "blacklist" $1 | shuf | grep -f trainingFilter_$7 | head -n $5 > testingSorted_$7.csv
grep "normal" $1 | shuf | grep -f trainingFilter_$7 | head -n $6 >> testingSorted_$7.csv
head -n 1 $1 > testing_$7.csv
cat testingSorted_$7.csv | shuf >> testing_$7.csv
rm testingSorted_$7.csv

rm trainingFilter_$7
