#!/bin/bash

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#generate pileup for a list of bam files using bcftools mpileup
#input: reference genome, bam list, specific region
#output: pileup file
#usage 01_mpileup.sh BAMlist_path REGION

# Global variables
LIST_BAM_PATH="$1"

REGION="$2"


if [ ! -f "$LIST_BAM_PATH" ]
then
        echo "error need input file"
        exit
fi

###Create default variable
GENOME="02_genome/genome.fasta"
OUTPUTPATH="03_pileup_file"


#verify that genome folder contains the genome:
#test if folder exists:
if [ ! -f $GENOME ]; then
   echo "no genome. genome.fasta should be in 02_genome"
   exit
fi

#check if output directory exist
if [ ! -d "$OUTPUTPATH" ]; then
	echo "creating output directory"
	mkdir $OUTPUTPATH
fi

###creating output file and command


# Load needed modules
module load bcftools/1.12

#run samtools mpileup with default setting

if [ -z "$REGION" ]; then
   bcftools mpileup\
	-f $GENOME\
    -a AD,DP,SP,ADF,ADR\
    -q 5\
    -b $LIST_BAM_PATH\
	-Ou\
    -d 20000\
	-o $OUTPUTPATH/pileup.ubcf
else

   bcftools mpileup\
	-f $GENOME\
    -q 5\
	-a AD,DP,SP,ADF,ADR\
	-b $LIST_BAM_PATH\
	-Ou\
	-r $REGION\
    -d 20000\
	-o $OUTPUTPATH/subpileup_${REGION}.ubcf
fi

echo "job end"
