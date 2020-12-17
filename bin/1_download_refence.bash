#!/bin/bash

# Download genome assembly
if [ -n $GENOME ] && [ ! -f $GENOME ]
then
    curl -o $GENOME http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz
fi

# Download transcriptome
if [ -n TXTOME ] && [ ! -f $TXTOME ]
then
    curl -o $TXTOME
fi
