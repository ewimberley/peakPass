# PeakPass

## Feature Pipeline

### Configuration

There are two configuration files for the freature pipeline: config/pipeline_config.sh is used for general configuration, and is always loaded. The other configuration file is passed in as a parameter to pipeline.sh and can be used for run specific parameters. These are normally stored in featurePipeline/configurations.

config/pipeline_config.sh example:

#PROC_POOL_SIZE=12
FREE_PROCS=2
PROC_POOL_SIZE=$(nproc)
PROC_POOL_SIZE=$(($PROC_POOL_SIZE-$FREE_PROCS))

DATA_FILE="data.dat"
DATA_CSV="data.csv"
BLACKLIST_CLASS="blacklist"
NORMAL_CLASS="normal"
GAPS="gaps_sorted.bed"
GENES="genes_sorted.bed"
REPEATS="repeatMasker_sorted.bed"
ALIGNABILTY75="alignability75"
DATA_PATH="/thesis/ThesisData"
RAM_DISK="/media/ramdisk"
FASTA_AND_INDEX="combined"

Per-run configuration example:

#!/bin/bash
export GENOME_VERSION="hg19"
export BLACKLIST_BED="$BLACKLISTS/Anshul_Hg19UltraHighSignalArtifactRegions.bed"
export WINDOW_SIZE=1000
export OVERLAP_WINDOW=0.7
export NUM_SAMPLES=4000000

Make sure that there is a folder in DATA_PATH with the same name as GENOME_VERSION.

### Pipeline Execution

To run the pipline in training dataset gathering mode, use the test parameter.

./pipeline.sh test configurations/hg19_kundaje_1000bp.sh

If you are gathering unlabeled windows (without an existing blacklist) use the predict parameter instead.

./pipeline.sh predict configurations/hg19_kundaje_1000bp.sh
