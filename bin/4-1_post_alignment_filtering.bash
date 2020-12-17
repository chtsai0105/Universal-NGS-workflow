#!/bin/bash
#SBATCH --job-name=4-1_post_alignment_filtering
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -c 1
#SBATCH --mem=64gb
#SBATCH --array=1-4
#SBATCH --output=sbatch_log/%x_%A_%a.out

CPU=1
INPUT_DIR=$DIR/alignment_output
OUTPUT_DIR=$DIR/alignment_output
mkdir -p $OUTPUT_DIR

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
		final_bam="$sample.final.bam"
		log="$sample.markdup.log"

		echo "Processing $sample ..."
		# markup duplicates from BAM
		sambamba markdup -t $CPU $INPUT_DIR/$sorted_bam /dev/stdout 2> $OUTPUT_DIR/$log | \

		# Filter the reads with conditions in braket
		sambamba view -F "ref_id != 16 and proper_pair and not duplicate and mapping_quality >= 30" \
		-f bam -o $OUTPUT_DIR/$final_bam -t $CPU /dev/stdin

		# Build index for BAM
		sambamba index -t $CPU $OUTPUT_DIR/$final_bam
	fi
	let line+=1
done
