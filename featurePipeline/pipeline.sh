#!/bin/bash
declare -a CHR_MAP
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SRC_DIR/../config/constants.sh
source $SRC_DIR/../config/pipeline_config.sh
source features.sh
source pipelineUtils.sh

function setup {
	printMessage "Setting up BED and FASTA files"

	export ALIGNABILTY_BEDGRAPHS="$RAM_DISK/$GENOME_VERSION/$ALIGNABILTY_BEDGRAPHS_FOLDER"
	if [ ! -d "$RAM_DISK/$GENOME_VERSION" ]; then
		mkdir $RAM_DISK/$GENOME_VERSION
	fi
	if [ ! -d "$ALIGNABILTY_BEDGRAPHS" ]; then
		cp -R $DATA_ROOT/$ALIGNABILTY_BEDGRAPHS_FOLDER $RAM_DISK/$GENOME_VERSION
	fi

	sortBed -i $TILES_BED > $SORTED_TILES
	awk '{print $1"_"$2"_"$3}' $SORTED_TILES > ids.dat
	sort -u -k1,1 ids.dat > sorted_ids.dat
	sort -u -k1,1 ids.dat > $DATA_FILE

	#TODO get surrounding tiles and use their features as features for this tile (left/right)
	#awk '{print $1"\t"$2"\t"$3"\t"$1"_"$2"_"$3}' $SORTED_TILES > $TILES_ID_MAP
	#bedtools shift -i $TILES_BED -g $GENOME_MAP -b 100 $EXPANDED_TILES_BED &
	#only for generating alignability:
	#bedtools getfasta -fi $GENOME_FASTA -bed $EXPANDED_TILES_BED -fo expanded_training.fa
	
	bedtools getfasta -fi $GENOME_FASTA -bed $TILES_BED -fo $TILES_FASTA > /dev/null 2>&1 &
        GET_FASTA_ONE=$!
	wait $GET_FASTA_ONE

	loadGenomeMap
}

#usage:
#gatherFeatures <region length> <class labels true/false>
function gatherFeatures {
	printMessage "Gathering features..."
	
	printMessage "Running closest gap feature gathering"
	bedtools closest -d -a $SORTED_TILES -b $GAP_BED | awk '{print $1"_"$2"_"$3"\t"$NF"\t"$(NF-1)"\t"$(NF-2)"\t"$(NF-3)}' > gaps.dat &
        GAPS=$!
	
	printMessage "Running closest gene distance feature gathering"
	bedtools closest -d -a $SORTED_TILES -b $GENE_BED | awk '{print $1"_"$2"_"$3"\t"$NF}' > geneDistance.dat &
        GENE_DISTANCE=$!
	
	printMessage "Running number of repeat feature gathering"
	#TODO commented out commands can be used to calculate num overlapping repeats in 10kb area around region
	#bedtools slop -i sorted_tiles.bed -g $GENOME_MAPS/hg19.map -b 10000 > sorted_tiles_10kb_expand.bed &
	#TODO last line of repeatsInTiles.bed contains overlap bases, sum these up for every unique id and use that as a feature
	bedtools intersect -a sorted_tiles.bed -b $REPEAT_BED -wo > repeatsInTiles.bed &
        OVERLAPPING_REPEATS=$!
	
	wait $GAPS
	awk '{print $1"\t"$2}' gaps.dat > gapDistance.dat &
        GAP_DISTANCE=$!
	awk '{print $1"\t"$4}' gaps.dat > gapType.dat &
        GAP_TYPE=$!
	awk '{print $1"\t"$5}' gaps.dat > gapSize.dat &
        GAP_SIZE=$!
	wait $OVERLAPPING_REPEATS
	awk '{print $1"_"$2"_"$3}' repeatsInTiles.bed | uniq -c | awk '{print $2"\t"$1}' > intersectingRepeats.dat &
        REPEAT_COUNT=$!
	wait $GAP_DISTANCE
	wait $GAP_TYPE
	wait $GAP_SIZE
	wait $GENE_DISTANCE
	wait $REPEAT_COUNT

	rm commands.txt
	printMessage "Running softmask count feature gathering"
	loopOverChromosomes "softmaskCount $TILES_FASTA" #$PROC_POOL_SIZE

	printMessage "Running monomer percent feature gathering"
	loopOverChromosomes "monomerPercent $TILES_FASTA"

	printMessage "Running Unique 3-mers feature gathering"
	loopOverChromosomes "uniqueKmers $TILES_FASTA 3"
	printMessage "Running Unique 4-mers feature gathering"
	loopOverChromosomes "uniqueKmers $TILES_FASTA 4"

	printMessage "Running monomer repeat feature gathering"
	loopOverChromosomes "monomerRepeats $TILES_FASTA"

	printMessage "Running twomer repeat feature gathering"
	loopOverChromosomes "twomerRepeats $TILES_FASTA"

	printMessage "Running alignability content feature gathering"
	#To generate the alignability track for a new genome:
	#bedtools getfasta -fi hg19.fa -bed expanded_tiles.bed -fo expanded_tiles.fa
	#./alignabilityKmers.py expanded_training.fa /mnt/RAM_disk/hg19Combined/hg19 36 20
        loopOverChromosomes "alignability $ALIGNABILTY_BEDGRAPHS" #$PROC_POOL_SIZE

	cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD	

	cat softmaskCount_*.dat >> softmaskCount.dat
	cat monomerPercent_*.dat >> monomerPercent.dat
	awk '{print $1"\t"$2}' monomerPercent.dat > monomerPercentA.dat
	awk '{print $1"\t"$3}' monomerPercent.dat > monomerPercentT.dat
	awk '{print $1"\t"$4}' monomerPercent.dat > monomerPercentC.dat
	awk '{print $1"\t"$5}' monomerPercent.dat > monomerPercentG.dat
	cat uniqueKmers_3_*.dat >> uniqueKmers3.dat
	cat uniqueKmers_4_*.dat >> uniqueKmers4.dat
	cat monomerRepeats_*.dat >> monomerRepeats.dat
	cat twomerRepeats_*.dat >> twomerRepeats.dat
	cat alignability_*.dat >> alignability.dat
	awk '{print $1"\t"$2}' alignability.dat > alignabilityAvg.dat
	awk '{print $1"\t"$3}' alignability.dat > alignabilityBelowLowerThresh.dat
	awk '{print $1"\t"$4}' alignability.dat > alignabilityAboveUpperThresh.dat
	awk '{print $1"\t"$5}' alignability.dat > alignabilityMappingRatio.dat

	rm softmaskCount_*.dat
	rm monomerPercent_*.dat
	rm uniqueKmers_3_*.dat
	rm uniqueKmers_4_*.dat
	rm monomerRepeats_*.dat
	rm twomerRepeats_*.dat
	rm alignability_*.dat


	#########################################################################
	#Copy the class label, merge columns on all files, and add column names #
	#########################################################################
	joinFeature "softmaskCount"
	joinFeature "monomerPercentA"
	joinFeature "monomerPercentT"
	joinFeature "monomerPercentC"
	joinFeature "monomerPercentG"
	joinFeature "uniqueKmers3"
	joinFeature "uniqueKmers4"
	joinFeature "monomerRepeats"
	joinFeature "twomerRepeats"
	joinFeature "alignabilityAvg"
	joinFeature "alignabilityBelowLowerThresh"
	joinFeature "alignabilityAboveUpperThresh"
	joinFeature "alignabilityMappingRatio"
	joinFeature "gapDistance"
	joinFeature "geneDistance"
	joinFeatureDefaultValue "intersectingRepeats" '0'

	#true for training, false for making predictions on new genomes 
	if [ "$1" = true ] ; then
		./classLabel.py $TILES_BED >> classLabel.dat
		joinFeature "classLabel"
	#else ...
	fi
	echo $COLUMNS > $DATA_CSV

	#remove data items that are just hard-masked bases
	awk '(NR==1) || (($3!="-1.0") && ($4!="-1.0") && ($5!="-1.0") && ($6!="-1.0"))' $DATA_FILE > training_filtered.dat
	sed 's/ /,/g' training_filtered.dat >> $DATA_CSV
	NUM_FILTERED_SAMPLES=$(wc -l training_filtered.dat | cut -d " " -f 1)
	echo "Final $DATA_FILE points after filtering: $NUM_FILTERED_SAMPLES"
}

if [ "$#" -eq 2 ] || [ "$#" -eq 3 ] ; then
	printMessage "Cleaning up previously generated files."
	./cleanup.sh > /dev/null 2>&1 
	source $2
	#Common configuration
	DATA_ROOT="$DATA_PATH/$GENOME_VERSION/"
	GENOME_MAP="$GENOME_MAPS/$GENOME_VERSION.map"
	GENOME_FASTA="$DATA_ROOT/$FASTA_AND_INDEX/$GENOME_VERSION.fa"
	GAP_BED="$DATA_ROOT/$GAPS"
	GENE_BED="$DATA_ROOT/$GENES"
	REPEAT_BED="$DATA_ROOT/$REPEATS"
	ALIGNABILTY_BEDGRAPHS_FOLDER="$ALIGNABILTY75"

	printMessage "Data is located at $DATA_ROOT"
	printMessage "Genome map is located at $GENOME_MAP"
	printMessage "Genome FASTA is located at $GENOME_FASTA"
	printMessage "Gaps BED is located at $GAP_BED"
	printMessage "Genes BED is located at $GENE_BED"
	printMessage "Repeat BED is located at $REPEAT_BED"
	printMessage "Alignability BED Graph is located at $ALIGNABILTY_BEDGRAPHS_FOLDER"

	OVERSAMPLE=false
	if [ "$3" = "oversample" ] ; then
		OVERSAMPLE=true
	fi
        
	#whole genome testing data
	if [ "$1" = "test" ] ; then
		printMessage "Running in test data mode."
		tileWholeGenome $WINDOW_SIZE true $OVERSAMPLE
		setup
		gatherFeatures true
	#process whole genome for blacklist prediction
	elif [ "$1" = "predict" ] ; then
		printMessage "Running in prediction mode."
		tileWholeGenome $WINDOW_SIZE false $OVERSAMPLE
		setup
		gatherFeatures false
	fi

else
        echo "Usage pipeline.sh <mode: test|train|predict> <config bash file> <oversample (optional)>" 
fi
