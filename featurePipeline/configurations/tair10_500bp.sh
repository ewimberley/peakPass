#!/bin/bash
export GENOME_VERSION="tair10"
export EXCLUDED_LIST_BED="$EXCLUDED/Anshul_Hg19UltraHighSignalArtifactRegions.bed"
export WINDOW_SIZE=500
export OVERLAP_WINDOW=0.7
export NUM_SAMPLES=4000000

#We aren't using this because it doesn't exist in other organisms
#export SIGNAL_BEDGRAPHS="/thesis/ThesisData/wgEncodeAllLabsHuvecPol2Std_5RepsSplit"
