#!/bin/bash

DIR=/rhome/ctsai085/2020_project-chtsai0105
BIN=$DIR/bin
REF=$DIR/ref
RAW=$DIR/raw
# Genome reference (For ATAC-seq, ChIP-seq and DNase-seq pipeline)
GENOME=$REF/S288C_reference_sequence_R64-2-1_20150113.fsa
# Transcriptome reference (For RNA-seq pipeline)
# TXTOME=

export DIR=$DIR REF=$REF RAW=$RAW BIN=$BIN GENOME=$GENOME
