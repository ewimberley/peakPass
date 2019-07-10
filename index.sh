#!/bin/bash
PROC_POOL_SIZE=20

rm commands.txt
for f in *.bam
do
	NAME=$(basename $f .bam)
	echo "samtools sort $NAME.bam -o $NAME.sorted.bam" >> commands.txt
done

cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
rm commands.txt

for f in *.bam
do
	NAME=$(basename $f .bam)
	if [[ $NAME != *"sorted"* ]]; then
		echo "samtools index $NAME.sorted.bam" >> commands.txt
		#echo "$NAME.sorted.bam"
	fi
done

cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
rm commands.txt

for f in *.sorted.bam.bai
do
	NAME=$(basename $f .sorted.bam.bai)
	mv $NAME.sorted.bam.bai $NAME.bai
done
