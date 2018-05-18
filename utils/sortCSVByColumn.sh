#!/bin/bash
#Usage sortCSVByColumn.sh <file>.csv <column number>
head -n1 $1.csv > $1_sorted.csv
tail -n +2 $1.csv | sort --field-separator=',' -k $2,$2rn >> $1_sorted.csv
