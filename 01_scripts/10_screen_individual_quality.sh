#!/bin/bash
#cd $SLURM_SUBMIT_DIR

#usage: 10_relatedness_het'sh <in_file.vcf.gz>
in=$1
out=98_sumstats


module load vcftools
#estimates relatedness2 and het from vcftools 

vcftools --gzvcf $in --relatedness2 --out $out/$(basename ${in/.*})
vcftools --gzvcf $in --het --out $out/$(basename ${in/.*})
vcftools --gzvcf $in --missing-indv --out $out/$(basename ${in/.*})

echo "done"
