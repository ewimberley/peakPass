#!/bin/bash
export EXCLUDED_LIST_BED="excludedlists/Anshul_Hg19UltraHighSignalArtifactRegions.bed"
export WINDOW_SIZE=2000
export GENOME_MAP="genomeMaps/hg19.map"
export GENOME_FASTA="/mnt/RAM_disk/hg19/hg19Combined/hg19.fa"
export ALIGNABILTY_BEDGRAPHS="/thesis/ThesisData/hg19/wgEncodeCrgMapabilityAlign36mer"
export GAP_BED="/thesis/ThesisData/hg19/gap_sorted.bed"
export GENE_BED="/thesis/ThesisData/hg19/genes_sorted.bed"
export REPEAT_BED="/thesis/ThesisData/hg19/repeatMasker_sorted.bed"
export OVERLAP_WINDOW=0.7
export NUM_SAMPLES=400

#We aren't using this because it doesn't exist in other organisms
export SIGNAL_BEDGRAPHS="/thesis/ThesisData/wgEncodeAllLabsHuvecPol2Std_5RepsSplit"
