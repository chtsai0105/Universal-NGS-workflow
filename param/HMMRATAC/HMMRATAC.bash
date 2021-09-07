#!/bin/bash
{% if use_slurm == True %}
#SBATCH --job-name={{ program }}
#SBATCH --ntasks={{ ntasks }}
#SBATCH --cpus-per-task={{ threads }}
#SBATCH --mem={{ mem }}
#SBATCH --array=1-{{ total_tasks }}%{{ ntasks }}
#SBATCH --output=sbatch_log/%x_%A_%a.out
{% endif %}

CPU=4
INPUT_DIR=$DIR/alignment_output
OUTPUT_DIR=$DIR/HMMRATAC_output
mkdir -p $OUTPUT_DIR

GENOMEINFO=$GENOME.hmmratac.info

# Generate GENOMEINFO, a two-column, tab delimited file with chromosome ID and length
if [ ! -f $GENOMEINFO ]
then
	samtools faidx $GENOME -o $GENOME.fai
	cut -f1,2 $GENOME.fai > $GENOMEINFO
fi

sed -n '{{ line_start }},$p' $METADATA | \
{% if use_slurm == True %}sed -n '$SLURM_ARRAY_TASK_ID{p;q;}' $METADATA | \{% endif %}
while IFS="," read Accession R1 R2 Strain Condition Replicate
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
