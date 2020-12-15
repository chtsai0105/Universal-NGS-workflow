#!/bin/bash

CPU=4

# Download data by sra-tools
tail -n +2 $DIR/metadata.csv | while IFS="," read Accession Type Layout R1 R2 Strain Condition Replicate
do
    if [ -f $RAW/${Accession}* ]
    then
        echo $Accession is already downloaded
    else
        echo "Downloading $Accession ..."
        fasterq-dump $Accession -O $RAW -t /dev/shm -e $CPU
    fi
done
