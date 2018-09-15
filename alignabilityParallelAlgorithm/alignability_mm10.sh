#!/bin/bash
declare -a CHR_MAP
PROC_POOL_SIZE=16
REQUIRED_PROCS=4
USER="cewimber"
GENOME_NAME="mm10"
GENOME_MAP="mm10.map"
FASTA_PATH="../mm10"
INDEX_PATH="../mm10/mm10Combined/mm10"
READ_LEN=36
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
	JOBS=$(($(squeue -u $USER | wc -l) - 1))
	while [ $JOBS -gt 0 ]
	do
		sleep 2
		JOBS=$(($(squeue -u $USER | wc -l) - 1))
	done
}

rm ./slurm-*
loadGenomeMap $GENOME_MAP

#Generate kmers
rm ./*.cmd.sh
for i in "${CHR_MAP[@]}"; do
	CHR_NAME=$(echo $i | awk '{ print $1 }')
	printf "#!/bin/sh\\n././alignabilityKmers.py $FASTA_PATH/$CHR_NAME.fa $INDEX_PATH $READ_LEN $CHR_NAME $PROC_POOL_SIZE" > "alignability_$CHR_NAME.cmd.sh"
	#sbatch --mem=12000 --distribution=cyclic --cpus-per-task=$REQUIRED_PROCS "alignability_$CHR_NAME.cmd.sh"
	sbatch --distribution=cyclic --cpus-per-task=$REQUIRED_PROCS "alignability_$CHR_NAME.cmd.sh"
done
waitForJobs

