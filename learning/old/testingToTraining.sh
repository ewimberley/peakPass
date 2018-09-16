#!/bin/bash
#Usage testingToTraining.sh [testing dataset] [num blacklist items] [num normal items]
grep "blacklist" $1 | shuf | head -n $2 > trainingSorted.csv
grep "normal" $1 | shuf | head -n $3 >> trainingSorted.csv
head -n 1 $1 > training.csv
cat trainingSorted.csv | shuf >> training.csv
rm trainingSorted.csv
