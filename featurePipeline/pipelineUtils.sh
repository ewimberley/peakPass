#!/bin/bash

function printMessage {
	printf '\e[1;34m%s\e[m\n' "$1"
}

#usage:
#tileWholeGenome <region length> <class labels true/false> <oversample true/false>
function tileWholeGenome {
	printMessage "Tiling whole genome for feature gathering."
	./wholeGenomeTile.py $GENOME_MAP $1 > $TILES_BED
	if [ "$3" = true ] ; then
		TWO=2
		FOUR=4
		OFFSET=$(($1/$TWO))
		OFFSET2=$(($1/$FOUR))
		OFFSET3=$(($OFFSET+$OFFSET2))
		#Oversampling
		printMessage "Oversampling with window shifts of $OFFSET2 $OFFSET and $OFFSET3"
		./wholeGenomeTile.py $GENOME_MAP $1 $OFFSET >> $TILES_BED
		./wholeGenomeTile.py $GENOME_MAP $1 $OFFSET2 >> $TILES_BED
		./wholeGenomeTile.py $GENOME_MAP $1 $OFFSET3 >> $TILES_BED
	fi

	if [ "$2" = true ] ; then
		TILES_TMP_BED="tiles_tmp.bed"
		bedtools intersect -a $TILES_BED -b $BLACKLIST_BED -f 0.6 -wo | awk '{print $1"\t"$2"\t"$3}' > blacklisted_tiles.bed
		bedtools intersect -a $TILES_BED -b $BLACKLIST_BED -f 0.6 -wo | awk '{print $1"_"$2"_"$3"\t"$7-$6"\t"$NF}' > blacklisted_tiles_metadata.bed &
		bedtools intersect -a $TILES_BED -b $BLACKLIST_BED -v -f 0.6 | awk '{print $1"\t"$2"\t"$3}' > non_blacklisted_tiles.bed
		rm $TILES_BED
		./addColumn.py blacklisted_tiles.bed $BLACKLIST_CLASS > $TILES_TMP_BED
		./addColumn.py non_blacklisted_tiles.bed $NORMAL_CLASS >> $TILES_TMP_BED
		shuf $TILES_TMP_BED > $TILES_BED
		rm $TILES_TMP_BED
	fi
}

#usage:
#joinFeature <feature name>
function joinFeature {
	printMessage "Joining feature $1"
	sort -u -k1,1 $1.dat -o $1.dat
	join $DATA_FILE $1.dat >> tmp_data.dat
	mv tmp_data.dat $DATA_FILE
	COLUMNS="$COLUMNS,$1"
}

#usage:
#joinFeature <feature name>
function joinFeatureDefaultValue {
	printMessage "Joining feature $1"
	sort -u -k1,1 $1.dat -o $1.dat
	join -a 1 -a 2 -e$2 -o 0,2.2 sorted_ids.dat $1.dat >> $1.default_value.dat 
	join $DATA_FILE $1.default_value.dat >> tmp_data.dat
	mv tmp_data.dat $DATA_FILE
	COLUMNS="$COLUMNS,$1"
}

#usage:
#loopOverChromosomes <command> <max number of processes>
function loopOverChromosomes {
	#rm commands.txt
	for i in "${CHR_MAP[@]}"; do
                COMMAND_STRING=$(eval "$1 $i")
                echo "$COMMAND_STRING" >> commands.txt
		#TODO consider something like this to prevent memory starvation (then run all features at once?)
		#TODO add Slurm cluster support
		#echo "while [ `cat /proc/meminfo |grep MemFree|awk '{ print $2 }'` -lt 6000000 ]; do echo \"Not enough memory\"; sleep 1; done" >> commands.txt
        done
	#cat commands.txt | xargs -t -I CMD --max-procs=$2 bash -c CMD
}

function loadGenomeMap {
	onChr=0
	while IFS= read -r line
	do
		chr=${line%	*} 
		CHR_MAP[$onChr]="$chr"
	        onChr=$onChr+1
	done < $GENOME_MAP
}
