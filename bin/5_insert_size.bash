#!/bin/bash

CPU=4
INPUT_DIR=$DIR/alignment_output
OUTPUT_DIR=$DIR/insert-size
MAX_INSERT_SIZE=800
mkdir -p $OUTPUT_DIR

tail -n +2 $DIR/metadata.csv | while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
do
	sample=`echo $Strain $Condition $Replicate | tr ' ' '_'`
	final_bam="$sample.final.bam"
	
	echo "Processing $sample ..."
	samtools stats -i $MAX_INSERT_SIZE -m 1 -@ $CPU $INPUT_DIR/$final_bam | grep ^IS | cut -f2- > $OUTPUT_DIR/$sample.tsv
	$BIN/insert_size.py $OUTPUT_DIR/$sample.tsv $OUTPUT_DIR $MAX_INSERT_SIZE
done
