#!/bin/bash

#extract sumstats for filtering from vcf or bcf file
#Extract_sumstat.sh <path_to_file>


#mem 5Go

#cd $SLURM_SUBMIT_DIR


module load bcftools/1.8

file=$1
output="98_sumstats"

echo -e "CHROM\tPOS\tMQ\tQUAL\tMQB\tRPB\tSOR\tMQSB" >$output/$(basename ${file/.*}).sumstats
bcftools query -f "%CHROM\t%POS\t%MQ\t%QUAL\t%MQB\t%RPB\t%SOR\t%MQSB\n" $file >>$output/$(basename ${file/.*}).sumstats

echo done
