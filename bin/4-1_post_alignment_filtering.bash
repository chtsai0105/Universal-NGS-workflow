#!/bin/bash

CPU=4
INPUT_DIR=$DIR/alignment_output
OUTPUT_DIR=$DIR/alignment_output
mkdir -p $OUTPUT_DIR

tail -n +2 $DIR/metadata.csv | while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
do
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
done
