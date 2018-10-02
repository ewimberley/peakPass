#!/bin/bash
#usage: classifyWholeGenome.sh [training CSV] [CSV to predict] [genome map]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -a CHR_MAP
source $SRC_DIR/../config/config.sh
source $SRC_DIR/../featurePipeline/pipelineUtils.sh

function classify {
	echo "Rscript learning.R predict randomForest $1 $2.csv $2"
}


GENOME_MAP=$3
loadGenomeMap
awk -F',' '{split($1,chr,"_"); print $0 >> chr[1]".csv.tmp"}' $2
FILES=*.csv.tmp
for f in $FILES
do
	CHROM=$(echo $f | cut -d "." -f 1)
	head -n 1 $2 > $CHROM.csv
	cat $f >> $CHROM.csv
done
rm commands.txt
rm id.csv
rm ./*.csv.tmp
loopOverChromosomes "classify $1" 
#cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD	

#echo "id, class, confidence" > predicted_blacklist.csv
#cat *_predicted_blacklist.csv >> predicted_blacklist.csv
#./csvToBedGraph.py predicted_blacklist.csv > predicted_blacklist.bedGraph
#sortBed -i predicted_blacklist.bedGraph > predicted_blacklist_sorted.bedGraph
