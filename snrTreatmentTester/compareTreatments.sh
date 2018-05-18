#!/bin/bash

#Run this command first:
#export R_LIBS="/thesis/R_libs"

Rscript run_spp.R -c=chipSampleRep1.tagAlign.gz -i=controlSampleRep0.tagAlign.gz -npeak=300000 -odir=./peaks/reps -savr -savp -rf -out=./stats/phantomPeakStatsReps.tab
