#!/bin/bash

DIR=/home/chtsai/2020_project-chtsai0105
BIN=$DIR/bin
REF=$DIR/ref
RAW=$DIR/raw
GENOME=$REF/S288C_reference_sequence_R64-2-1_20150113.fsa
# TXTOME=$REF/AaegL5.0_CDS.fa.gz

# Download genome assembly
# if [ ! -f $GENOME ]
# then
    # curl -o $GENOME https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/204/515/GCF_002204515.2_AaegL5.0/GCF_002204515.2_AaegL5.0_genomic.fna.gz
    # curl -o $GENOME http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz
# fi

# Download transcriptome
# if [ ! -f $TXTOME ]
# then
#     curl -o $TXTOME https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/204/515/GCF_002204515.2_AaegL5.0/GCF_002204515.2_AaegL5.0_cds_from_genomic.fna.gz
# fi

export DIR=$DIR REF=$REF RAW=$RAW BIN=$BIN GENOME=$GENOME
