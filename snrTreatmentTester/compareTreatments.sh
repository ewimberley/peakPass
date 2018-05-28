#!/bin/bash
#Usage: compareTreatments.sh [data directory] [reads file]

#Run this command first:
export R_LIBS="~/R_libs"

#Rscript run_spp.R -c=chipSampleRep1.tagAlign.gz -i=controlSampleRep0.tagAlign.gz -npeak=300000 -odir=./peaks/reps -savr -savp -rf -out=./stats/phantomPeakStatsReps.tab
Rscript run_spp.R -c=$1/$2.bam -odir=./peaks/reps -savp -rf -out=./$2.tab
