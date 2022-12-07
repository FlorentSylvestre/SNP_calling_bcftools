#!/bin/bash
#usage : ./07_filtergin_QUAL.sh <file>

cd $SLURM_SUBMIT_DIR
infile=$1
outfile="07_QUAL_Filter"
module load bcftools/1.12
bcftools filter -M 2 -m 2 -v snps \
        -i "QUAL >250  && RPB >=0.001 && MQB>=0.001 && SOR <= 4 && MQ>=30 && MQSB >= 0.001"\
        -Oz -o ${outfile}/QUAL_$(basename $infile) $infile
