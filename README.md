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

### Feature Pipeline Output

You should get output similar to the following in the data.csv file.

id,softmaskCount,monomerPercentA,monomerPercentT,monomerPercentC,monomerPercentG,uniqueKmers3,uniqueKmers4,monomerRepeats,twomerRepeats,alignabilityAvg,alignabilityBelowLowerThresh,alignabilityAboveUpperThresh,alignabilityMappingRatio,gapDistance,geneDistance,intersectingRepeats,classLabel
chr10_135499000_135500000,993,27.1,26.1,22.9,23.9,64,221,222,67,0.83733333331,0,678,0.0,24748,543,2,chr10_135498649_135502716
chr10_135500000_135501000,1000,29.8,23.0,23.3,23.9,62,182,196,66,0.70268333298,0,473,1.0,23748,1543,1,chr10_135498649_135502716
chr10_135501000_135502000,1000,30.3,21.5,24.8,23.4,61,164,191,57,0.62379999987,0,332,2.0,22748,2543,1,chr10_135498649_135502716
chr10_135502000_135502716,716,31.0055865922,21.6480446927,22.625698324,24.7206703911,62,165,134,41,0.692271880782,0,279,1.0,22032,3543,2,chr10_135498649_135502716
chr10_20036000_20037000,141,32.5,28.8,19.9,18.8,64,223,307,91,0.60516666665,0,213,3.0,2011326,0,2,chr10_20035661_20037171
chr10_36722282_36723000,0,29.2479108635,30.3621169916,13.3704735376,27.0194986072,61,206,212,61,0.0,0,0,718,2095836,671031,0,chr10_36722282_36723650
chr10_36723000_36723650,0,32.7692307692,34.3076923077,10.4615384615,22.4615384615,61,193,192,54,0.71,0,274,1.0,2095186,671749,0,chr10_36722282_36723650
chr10_38772277_38773000,642,40.2489626556,21.0235131397,8.8520055325,29.8755186722,56,128,253,42,1.0,0,723,0.0,45836,31197,5,chr10_38772277_38819357
chr10_38773000_38774000,957,38.4,22.5,7.0,32.1,53,128,322,36,1.0,0,1000,0.0,44836,31920,3,chr10_38772277_38819357
chr10_100000000_100001000,242,30.2,35.6,19.0,15.2,64,224,323,122,0.0,0,0,1000,25868473,0,3,normal
chr10_10000000_10001000,1000,36.0,16.4,22.4,25.2,64,218,286,98,0.37640726139,493,319,2.0,7973676,99685,1,normal
chr10_1000000_1001000,0,19.6,18.5,33.6,28.3,64,204,287,92,0.1165454537,908,23,42.0,940001,11418,0,normal
chr10_100000_101000,1000,24.2,36.9,22.8,16.1,64,222,290,107,0.56641260373,10,300,2.0,40001,4823,5,normal
chr10_100001000_100002000,334,24.1,39.8,19.1,17.0,63,214,306,114,0.0,0,0,1000,25867473,0,2,normal
chr10_100002000_100003000,361,27.5,33.8,20.8,17.9,63,216,300,91,0.97925000006,0,973,0.0,25866473,0,2,normal
chr10_100003000_100004000,0,33.2,32.2,14.9,19.7,60,208,292,84,0.0,0,0,1000,25865473,0,0,normal
chr10_100004000_100005000,0,27.9,27.1,20.8,24.2,64,221,252,68,0.0,0,0,1000,25864473,0,0,normal
chr10_100005000_100006000,0,25.2,32.4,23.0,19.4,62,218,269,67,0.0,0,0,1000,25863473,347,0,normal

## Dataset Creation

We need both a labeled training/testing set and an unlabeled whole genome dataset. To do this, run pipeline.sh in test mode and move data.csv to the learning dicrectory. Then run pipeline.sh in predict mode rename it to predict.csv, and move it to the learning directory.

Next we need to split this data.csv file into training and testing datasets. You can do this using a python script in the learning directory.

./splitDataset.py data.csv 0.5

This will create a training.csv and a testing.csv. Next we will switch the class labels from the ids of blacklist regions (e.g. "chrA_1000_2000") to simply "blacklist". You can do this with the mergeClassLabels python script.

./mergeClassLabels.py training.csv
./mergeClassLabels.py testing.csv

To make a managable final training set, down sample to 2000 blacklist items and 2000 normal items.

./downsample.py training.csv 2000 2000

## Blacklist Prediction

Once you have training and prediction datasets, you can simply run the classifyWholeGenome bash script to create a bedGraph file.

./classifyWholeGenome.sh training.csv predict.csv ../featurePipeline/genomeMaps/hg19.map

This will output a file named predicted_blacklist_sorted.bedGraph that contains a list of regions and the predicted probability that region is a blacklist region.
