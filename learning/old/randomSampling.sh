#!/bin/bash
#Usage randomSampling.sh <CSV file> <num training items> <num testing items> <testing suffix> 
cat $1 | shuf | head -n $2 >> training_$4.csv
cat $1 | shuf | head -n $3 >> testing_$4.csv
