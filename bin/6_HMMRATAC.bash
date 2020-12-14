#!/bin/bash

CPU=4
INPUT_DIR=$DIR/alignment_output
OUTPUT_DIR=$DIR/HMMRATAC_output
mkdir -p $OUTPUT_DIR

GENOMEINFO=$GENOME.hmmratac.info

if [ ! -f $GENOMEINFO ]
then
	samtools faidx $GENOME -o $GENOME.fai
	cut -f1,2 $GENOME.fai > $GENOMEINFO
fi

tail -n +2 $DIR/metadata.csv | while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
do
	sample=`echo $Strain $Condition $Replicate | tr ' ' '_'`
	final_bam="$sample.final.bam"
    echo "Processing $sample ..."
	HMMRATAC	-b $INPUT_DIR/$final_bam \
				-i $INPUT_DIR/$final_bam.bai \
				-g $GENOMEINFO \
				-o $OUTPUT_DIR/$sample \
				--bedgraph true --bgscore true --trim 1 --window 1000000
done
