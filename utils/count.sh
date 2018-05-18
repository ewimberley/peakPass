#!/bin/sh
for file in *.fastq; do
	FASTQ_LINES=$(wc -l $file | cut -d" " -f1)
	FOUR=4
	SEQ_LINES="$(($FASTQ_LINES / $FOUR))"
	REPEAT_LINES=$(grep -c "ATATATATATATATATATATATATATAT" $file)
	echo ""
	echo "$file:"
	echo "Total reads:                  $SEQ_LINES"
	echo "ATATATATATATATATATATATATATAT: $REPEAT_LINES"
done
