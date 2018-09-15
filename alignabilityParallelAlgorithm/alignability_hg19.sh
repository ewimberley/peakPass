#!/bin/bash
declare -a CHR_MAP
PROC_POOL_SIZE=8
REQUIRED_PROCS=4
USER="cewimber"
GENOME_NAME="hg19"
GENOME_MAP="hg19.map"
FASTA_PATH="../hg19"
INDEX_PATH="../hg19/hg19Combined/hg19"
READ_LEN=36
#READ_LEN=75
NUM_SPLITS=20

function loadGenomeMap {
        onChr=0
        while IFS= read -r line
        do
                chr=${line%     *}
                CHR_MAP[$onChr]="$chr"
                onChr=$onChr+1
        done < $1
}

function waitForJobs {
	#Wait for sbatch jobs to finish
	JOBS=$(($(squeue -u $USER | grep "R" | wc -l) - 1))
	while [ $JOBS -gt 0 ]
	do
		sleep 2
		JOBS=$(($(squeue -u $USER | grep "R" | wc -l) - 1))
	done
}

rm ./slurm-*
loadGenomeMap $GENOME_MAP

#Generate kmers
rm ./*.cmd.sh
for i in "${CHR_MAP[@]}"; do
	CHR_NAME=$(echo $i | awk '{ print $1 }')
	printf "#!/bin/sh\\n././alignabilityKmers.py $FASTA_PATH/$CHR_NAME.fa $INDEX_PATH $READ_LEN $CHR_NAME $PROC_POOL_SIZE" > "alignability_$CHR_NAME.cmd.sh"
	sbatch --job-name=$CHR_NAME --distribution=cyclic --cpus-per-task=$REQUIRED_PROCS "alignability_$CHR_NAME.cmd.sh"
	sleep 3
done
waitForJobs

