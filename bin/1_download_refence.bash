#!/bin/bash

# Download genome assembly
if [ -n $GENOME ] && [ ! -f $GENOME ]
then
    curl -o $GENOME https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/204/515/GCF_002204515.2_AaegL5.0/GCF_002204515.2_AaegL5.0_genomic.fna.gz
    curl -o $GENOME http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz
fi

# Download transcriptome
if [ -n TXTOME ] && [ ! -f $TXTOME ]
then
    curl -o $TXTOME https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/204/515/GCF_002204515.2_AaegL5.0/GCF_002204515.2_AaegL5.0_cds_from_genomic.fna.gz
fi
