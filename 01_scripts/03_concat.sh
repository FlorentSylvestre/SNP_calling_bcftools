##cd $SLURM_SUBMIT_DIR

#concatenate vcf/bcfs files
#output: merged.vcf.gz
#usage 02_bcftools_call.sh FILE
#FILE contain a list of all files to merge

# Global variables
INPUT_FILE="$1"
OUTPUT="05_vcf"

if [ ! -d $OUTPUT ]; then
	echo "creating ouput directory"
	mkdir $OUTPUT
fi

# Load needed modules
module load bcftools/1.8


#list path to input file
#run bcftools concat

bcftools concat\
  -f $INPUT_FILE \
 -Oz\
 -o $OUTPUT/merged.vcf.gz\

##building reference index for merging
echo "building index"
bcftools index\
 $OUTPUT/merged.vcf.gz
