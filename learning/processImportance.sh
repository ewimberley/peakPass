#!/bin/bash
head -n 1 importance.csv > importanceSorted.csv
tail -n +2 importance.csv | sort --field-separator=',' -k 4,4rn >> importanceSorted.csv
