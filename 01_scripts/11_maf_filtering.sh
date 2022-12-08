#!/bin/bash
#cd $SLURM_SUBMIT_DIR

#usage: 11_maf_filtering.sh <in_file.vcf.gz>
#apply a maf filter of 10% to the dataset
#edit the q value to adjust to you context

in=$1
out="09_final_vcfs"


module load bcftools/1.12 
bcftools view -q 0.1:minor -Oz -o $out/MAF_$(basename $in)\
  $in
