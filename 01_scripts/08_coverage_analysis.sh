#!/bin/bash
#cd $SLURM_SUBMIT_DIR

#coverage analysis, adapted from Q. Rougeux GATK scripts and advises

vcf=$1

output="98_sumstats"

module load vcftools/0.1.16
 
#on extrait les profondeurs pour voir les mean +-SD:
#Extracting SNP sequencing depth to explore the distribution
vcftools --gzvcf $vcf --out $output/$(basename ${vcf/.*}) --site-mean-depth

echo "canard"

#compute mean:
echo "mean mean depth:" >$output/mean_depth_sumstat

sed 1d $output/$(basename ${vcf/.*}).ldepth.mean |\
    awk '{sum +=$3 }END {print sum /NR}'>>$output/mean_depth_sumstat 
#compute SD:
echo "SD over mean depth:" >>$output/mean_depth_sumstat
sed 1d $output/$(basename ${vcf/.*}).ldepth.mean | \
    awk '{sum+=$3; sumsq+=$3*$3} END {print sqrt(sumsq/NR - (sum/NR)^2)}' >>$output/mean_depth_sumstat
