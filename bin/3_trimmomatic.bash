#!/bin/bash

CPU=4
INPUT_DIR=$RAW
OUTPUT_DIR=$DIR/fastq_trimmed

mkdir -p $OUTPUT_DIR

# Check the existence of single-end or pair-end in column "layout"
declare -A Layout_arr
for layout in `cut -d , -f 3 $DIR/metadata.csv | sort -u`
do
	Layout_arr[$layout]=1
done

if [ ${Layout_arr["pair"]} ]
then
	UNPAIRED_DIR=$OUTPUT_DIR/unpaired
	mkdir -p $UNPAIRED_DIR
fi

# Run trimmomatic
tail -n +2 $DIR/metadata.csv | while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
do
	sample=`echo $Strain $Condition $Replicate | tr ' ' '_'`

	echo "Processing $sample ..."
	# Single-end mode
	if [ $Layout == "single" ]
	then
		trimmomatic SE	-threads $CPU \
						-summary $OUTPUT_DIR/$R1.summary \
						$INPUT_DIR/$R1 \
						$OUTPUT_DIR/$R1 \
						CROP:75 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:15
	# Pair-end mode
	elif [ $Layout == "pair" ]
	then
		trimmomatic PE	-threads $CPU \
						-summary $OUTPUT_DIR/$R1.summary \
						$INPUT_DIR/$R1 $INPUT_DIR/$R2 \
						$OUTPUT_DIR/$R1 $UNPAIRED_DIR/$R1 \
						$OUTPUT_DIR/$R2 $UNPAIRED_DIR/$R2 \
						CROP:75 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:15
	# Layout error
    else
        echo "Error: Check column \"layout\" in metadata.csv"
	fi
done

# Run fastqc again after trimming
source $BIN/2_fastqc.bash
INPUT_DIR=$OUTPUT_DIR
OUTPUT_DIR=$DIR/fastqc_output/post_trim

run_fastqc $CPU $INPUT_DIR $OUTPUT_DIR
