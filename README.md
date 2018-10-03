# PeakPass

## Feature Pipeline

### Configuration

There are two configuration files for the freature pipeline: config/pipeline_config.sh is used for general configuration, and is always loaded. The other configuration file is passed in as a parameter to pipeline.sh and can be used for run specific parameters. These are normally stored in featurePipeline/configurations.

```bash
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
```

Per-run configuration example:

```bash
#!/bin/bash
export GENOME_VERSION="hg19"
export BLACKLIST_BED="$BLACKLISTS/Anshul_Hg19UltraHighSignalArtifactRegions.bed"
export WINDOW_SIZE=1000
export OVERLAP_WINDOW=0.7
export NUM_SAMPLES=4000000
```

Make sure that there is a folder in DATA_PATH with the same name as GENOME_VERSION.

### Pipeline Execution

To run the pipline in training dataset gathering mode, use the test parameter.

`./pipeline.sh test configurations/hg19_kundaje_1000bp.sh`

If you are gathering unlabeled windows (without an existing blacklist) use the predict parameter instead.

`./pipeline.sh predict configurations/hg19_kundaje_1000bp.sh`

### Feature Pipeline Output

You should get output similar to the following in the data.csv file.

```
id,softmaskCount,monomerPercentA,monomerPercentT,monomerPercentC,monomerPercentG,uniqueKmers3,uniqueKmers4,monomerRepeats,twomerRepeats,alignabilityAvg,alignabilityBelowLowerThresh,alignabilityAboveUpperThresh,alignabilityMappingRatio,gapDistance,geneDistance,intersectingRepeats,classLabel
chr10_135499000_135500000,993,27.1,26.1,22.9,23.9,64,221,222,67,0.83733333331,0,678,0.0,24748,543,2,chr10_135498649_135502716
chr10_135500000_135501000,1000,29.8,23.0,23.3,23.9,62,182,196,66,0.70268333298,0,473,1.0,23748,1543,1,chr10_135498649_135502716
chr10_38773000_38774000,957,38.4,22.5,7.0,32.1,53,128,322,36,1.0,0,1000,0.0,44836,31920,3,chr10_38772277_38819357
chr10_100000000_100001000,242,30.2,35.6,19.0,15.2,64,224,323,122,0.0,0,0,1000,25868473,0,3,normal
chr10_10000000_10001000,1000,36.0,16.4,22.4,25.2,64,218,286,98,0.37640726139,493,319,2.0,7973676,99685,1,normal
```

## Dataset Creation

We need both a labeled training/testing set and an unlabeled whole genome dataset. To do this, run pipeline.sh in test mode and move data.csv to the learning dicrectory. Then run pipeline.sh in predict mode rename it to predict.csv, and move it to the learning directory.

Next we need to split this data.csv file into training and testing datasets. You can do this using a python script in the learning directory.

`./splitDataset.py data.csv 0.5`

This will create a training.csv and a testing.csv. Next we will switch the class labels from the ids of blacklist regions (e.g. "chrA_1000_2000") to simply "blacklist". You can do this with the mergeClassLabels python script.

```bash
./mergeClassLabels.py training.csv
./mergeClassLabels.py testing.csv
```

To make a managable final training set, down sample to 2000 blacklist items and 2000 normal items.

`./downsample.py training.csv 2000 2000`

## Blacklist Prediction

Once you have training and prediction datasets, you can simply run the classifyWholeGenome bash script to create a bedGraph file.

`./classifyWholeGenome.sh training.csv predict.csv ../featurePipeline/genomeMaps/hg19.map`

This will output file named predicted_blacklist.bedGraph and predicted_blacklist_sorted.bedGraph that contain lists of regions and their predicted probability that region is a blacklist region.

A more convenient format is a simple merged bed file that combines nearby blacklist regions from the bedGraph file and sets a probability threshold. The following command will take the output of classifyWholeGenome and produce a blacklist bed file containing regions with a predicted blacklist probability of 50% or higher, and merge any windows that are within 1000bp of each other (setting this to 0 will merge book-ended blacklist items).

`./createMergedBlacklist.sh predicted_blacklist 0.5 1000`

The output file from this command should be called "predicted_blacklist_sorted_merged.bed". You can filter your read files using a command similar to below:

`bedtools intersect -v -a reads.bam -b predicted_blacklist_sorted_merged.bed > filtered_reads.bam`
