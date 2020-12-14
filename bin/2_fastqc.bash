#!/bin/bash

# fastqc function
function run_fastqc {
    cpu=$1
    input_dir=$2
    output_dir=$3

    mkdir -p $output_dir
    input=""
    while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
    do
        input+=" $input_dir/$R1 $input_dir/$R2"
    done <<< $(tail -n +2 $DIR/metadata.csv)

    fastqc -t $cpu -o $output_dir $input
}

# If execute this script then do fastqc on pre-trim fastq
if [ "${BASH_SOURCE[0]}" == "${0}" ]
then
    CPU=4
    INPUT_DIR=$RAW
    OUTPUT_DIR=$DIR/fastqc_output/pre_trim

    run_fastqc $CPU $INPUT_DIR $OUTPUT_DIR
fi
