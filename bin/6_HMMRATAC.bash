#!/bin/bash
#SBATCH --job-name=6_HMMRATAC
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=64gb
#SBATCH --array=1-4
#SBATCH --output=sbatch_log/%x_%A_%a.out

CPU=4
INPUT_DIR=$DIR/alignment_output
OUTPUT_DIR=$DIR/HMMRATAC_output
mkdir -p $OUTPUT_DIR

GENOMEINFO=$GENOME.hmmratac.info

# Generate GENOMEINFO, a two-column, tab delimited file with chromosome ID and length
if [ ! -f $GENOMEINFO ]
then
	samtools faidx $GENOME -o $GENOME.fai
	cut -f1,2 $GENOME.fai > $GENOMEINFO
fi

# [For sbatch job-array] line counter of metadata.csv
line=1
tail -n +2 $DIR/metadata.csv | while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
do
	# if not job-array scheduled then do while loop normally
	# if job-array scheduled then only execute the loop that line and SLURM_ARRAY_TASK_ID are matched
	if [ -z $SLURM_ARRAY_TASK_ID ] || [ $line -eq $SLURM_ARRAY_TASK_ID ]
	then
		sample=`echo $Strain $Condition $Replicate | tr ' ' '_'`
		final_bam="$sample.final.bam"
		echo $line
		echo "Processing $sample ..."
		HMMRATAC	-b $INPUT_DIR/$final_bam \
					-i $INPUT_DIR/$final_bam.bai \
					-g $GENOMEINFO \
					-o $OUTPUT_DIR/$sample \
					--bedgraph true --bgscore true --trim 1 --window 1000000
	fi
	let line+=1
done
