#!/bin/bash
#Usage testingToTraining.sh [testing dataset] [blacklist file] [num blacklist items] [num normal items]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
printf "chr1_\nchr3_\nchr5_\nchr7_\nchr9_\nchr11_\nchr13_\nchr15_\nchr17_\nchr19_\nchr21_\nchrY_" > trainingFilter
grep "blacklist" $1 | shuf | grep -v -f trainingFilter | head -n $2 > trainingSorted.csv
grep "normal" $1 | shuf | grep -v -f trainingFilter | head -n $3 >> trainingSorted.csv
#Line below can be used to remove very similar items from the majority class
#grep "normal" $1 | shuf | grep -v -f trainingFilter | $SRC_DIR/reduceTrainingSimilarity.sh | head -n $3 >> trainingSorted.csv
head -n 1 $1 > training.csv
cat trainingSorted.csv | shuf >> training.csv
rm trainingSorted.csv
rm trainingFilter
