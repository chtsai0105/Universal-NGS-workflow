#!/bin/bash
#SBATCH --job-name=4_bowtie
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -c 4
#SBATCH --mem=64gb
#SBATCH --array=1-4
#SBATCH --output=sbatch_log/%x_%A_%a.out

CPU=4
INPUT_DIR=$DIR/fastq_trimmed
INDEX=$DIR/bowtie_INDEX/$(basename $GENOME)
OUTPUT_DIR=$DIR/alignment_output
mkdir -p $OUTPUT_DIR

# Generate decoy-aware salmon index
if [ ! -d $(dirname $INDEX) ]
then
    # Build index
    echo "Build index ..."
	mkdir $(dirname $INDEX)
    bowtie2-build --threads $CPU $GENOME $INDEX
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
		sorted_bam="$sample.sorted.bam"
		log="$sample.align.log"

		echo "Processing $sample ..."
		# Single-end mode
		if [ $Layout == "single" ]
		then
			bowtie2 -p $CPU --very-sensitive \
			-x $INDEX -U $INPUT_DIR/$R1 2> $OUTPUT_DIR/$log | \
			sambamba view -f bam -S -t $CPU /dev/stdin | \
			sambamba sort -m 6G -o $OUTPUT_DIR/$sorted_bam -t $CPU /dev/stdin
		# Pair-end mode
		elif [ $Layout == "pair" ]
		then
			bowtie2 -p $CPU -X 2000 --dovetail --very-sensitive \
			-x $INDEX -1 $INPUT_DIR/$R1 -2 $INPUT_DIR/$R2 2> $OUTPUT_DIR/$log | \
			sambamba view -f bam -S -t $CPU /dev/stdin | \
			sambamba sort -m 6G -o $OUTPUT_DIR/$sorted_bam -t $CPU /dev/stdin
		# Layout error
		else
			echo "Error: Check column \"layout\" in metadata.csv"
		fi
	fi
	let line+=1
done
