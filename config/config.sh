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