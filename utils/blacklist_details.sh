#!/bin/bash

#sort -u -k4,4 blacklist.bed | awk '{print $4}' > blacklist_types.dat
sort -u -k4,4 $1 | awk '{print $4}' > blacklist_types_tmp.dat
declare -a types
let i=0
while IFS=$'\n' read -r line_data; do
    types[i]="${line_data}"
    ((++i))
done < blacklist_types_tmp.dat
rm blacklist_types_tmp.dat

echo "\dataTable{"
printf "\t\\dataTableRow{Region Type & Frequency & Description}\n"
for i in "${types[@]}"
do
	numItems=$(grep "$i" $1 | wc -l)
	printf "\t\\dataTableRow{ $i & $numItems & A description... }\n" 
done
totalItems=$(wc -l $1 | cut -d' ' -f1)
printf "\t\\dataTableRow{ Total & $totalItems & - }\n"
echo "}{ | \$p{0.2\textwidth} | ^p{0.2\textwidth}| ^p{0.6\textwidth} | }"
