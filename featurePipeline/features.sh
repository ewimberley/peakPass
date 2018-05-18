#!/bin/bash
function softmaskCount {
	echo "./softmaskCount.py $1 $2 >> softmaskCount_$2.dat"
}

function cgCount {
	echo "./cgCount.py $1 $2 >> cgCount_$2.dat"
}

function monomerPercent {
	echo "./monomerPercent.py $1 $2 >> monomerPercent_$2.dat"
}

function monomerRepeats {
	echo "./monomerRepeats.py $1 $2 >> monomerRepeats_$2.dat"
}

function twomerRepeats {
	echo "./twomerRepeats.py $1 $2 >> twomerRepeats_$2.dat"
}

function uniqueKmers {
	echo "./uniqueKmers.py $1 $2 $3 >> uniqueKmers_$2_$3.dat"
}

function alignability {
	echo "./alignability.py $SORTED_TILES $2 $1/$2.bedGraph 0.1 0.9 >> alignability_$2.dat"
}

function signal {
	echo "./signal.py $SORTED_TILES $2 $1/$2.bed >> signal_$2.dat"
}

