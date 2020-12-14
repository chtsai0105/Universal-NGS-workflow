#!/bin/bash

CPU=4
INPUT_DIR=$DIR/fastq_trimmed
INDEX=$DIR/salmon_INDEX
OUTPUT_DIR=$DIR/salmon_output
mkdir -p $OUTPUT_DIR

# Generate decoy-aware salmon index
if [ ! -d $INDEX ]
then
    # Generate genomic decoy
    echo "Generate genomic decoy ..."
    grep "^>" <(gunzip -c $GENOME) | cut -d " " -f 1 > $REF/decoys.txt
    sed -i.bak -e 's/>//g' $REF/decoys.txt
    cat $TXTOME $GENOME > $REF/gentrome.fa.gz

    # Build index
    echo "Build index ..."
    salmon index -t $REF/gentrome.fa.gz -d $REF/decoys.txt -p $CPU -i $INDEX
fi

# Run salmon
tail -n +2 $DIR/metadata.csv | while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
do
    sample=`echo $Strain $Condition $Replicate | tr ' ' '_'`

    echo "Processing $sample ..."
    # Single-end mode
	if [ $Layout == "single" ]
	then
		salmon quant    -i $INDEX -l A -p $CPU --validateMappings\
                        -r $INPUT_DIR/$R1 -o $OUTPUT_DIR/$sample
	# Pair-end mode
	elif [ $Layout == "pair" ]
	then
		salmon quant    -i $INDEX -l A -p $CPU --validateMappings\
                        -1 $INPUT_DIR/$R1 -2 $INPUT_DIR/$R2 -o $OUTPUT_DIR/$sample
    # Layout error
    else
        echo "Error: Check column \"layout\" in metadata.csv"
	fi
done
