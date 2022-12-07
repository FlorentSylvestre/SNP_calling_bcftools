#!/bin/bash
#cd $SLURM_SUBMIT_DIR

#usage: 09_DEPTH_NA_filtering.sh <in_file.vcf.gz>
#edit value before running, according to previous step

in=$1
out=08_COVMISS_Filter 


module load bcftools
#refilter by  replacing low coverage genotype by NA 

bcftools filter \
  -S . -e "(FORMAT/AD[*:0] + FORMAT/AD[*:1]) >35 |(FORMAT/AD[*:0] + FORMAT/AD[*:1]) <4" $in |\
  bcftools view -M2 -m 2 -i 'F_MISSING<0.2' -Oz -o $out/COV_MISS_$(basename $in)
bcftools index $out/COV_MISS_$(basename $in)

echo "done"
