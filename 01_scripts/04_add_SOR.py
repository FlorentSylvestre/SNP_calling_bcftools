#!/usr/bin/env python3
#-*- coding: utf-8 -*-


"""Take bcftools vcf and add GATK SOR calculation
Usage <script> vcf_in vcf_out
"""
import re
import sys
import gzip
from math import log
from collections import defaultdict




def myopen(_file, mode="rt"):
    if _file.endswith(".gz"):
        return gzip.open(_file, mode=mode)

    else:
        return open(_file, mode=mode)

def SOR(reads_distrib):

    R = (reads_distrib["REF_FOR"] * reads_distrib["ALT_REV"]) / (reads_distrib["ALT_FOR"] * reads_distrib["REF_REV"])
    inv_R = (reads_distrib["ALT_FOR"] * reads_distrib["REF_REV"]) / (reads_distrib["REF_FOR"] * reads_distrib["ALT_REV"])


    refRatio = min(reads_distrib["REF_FOR"], reads_distrib["REF_REV"]) / max(reads_distrib["REF_FOR"], reads_distrib["REF_REV"])

    altRatio = min(reads_distrib["ALT_FOR"], reads_distrib["ALT_REV"]) / max(reads_distrib["ALT_FOR"], reads_distrib["ALT_REV"])

    return(float(log( R + inv_R) + log(refRatio) - log(altRatio)))


# Parsing user input
try:
    vcf_path = sys.argv[1]
except:
    print(__doc__)
    sys.exit(1) 

#Defining generic variable:
vcf_out = "06_biallelic/autosome.sor.vcf.gz"


### parsing first 4 column
with myopen(vcf_path) as inputfile:
    with myopen(vcf_out,"wt") as outputfile:

        for line in inputfile:
            l = line.strip().split("\t")

            if line.startswith("#"):
                if line.startswith("##INFO=<ID=MQ0F"):
                    outputfile.write('##INFO=<ID=SOR,Number=1,Type=Float,Description=" Strand bias estimated by the Symmetric Odds Ratio test,cumstom annotation">\n')
                    outputfile.write('##INFO=<ID=QD,Number=1,Type=Float,Description=" QualByDepth GATk annotation, custom annotation">\n')
                    outputfile.write(line)
                else:
                    outputfile.write(line)

            elif len(l[4].split(',')) > 1:
                continue
            else:
                new_line = "\t".join(l[0:3])
                INFOS = l[7]

                ###Estimating SOR
                DP4 = defaultdict(float)

                for field in INFOS.split(";"):
                    if field.split("=")[0] == "DP4":
                        dp4 = field.split("=")[1].split(",")
                        DP4["REF_FOR"] = float(dp4[0]) + 1
                        DP4["REF_REV"] = float(dp4[1]) + 1
                        DP4["ALT_FOR"] = float(dp4[2]) + 1
                        DP4["ALT_REV"] = float(dp4[3]) + 1
                     
                    
                infosSOR = ";SOR={}".format(SOR(DP4))

                INFOS += infosSOR
                    

                ##Output
                NewLine = "\t".join(l[0:7]) + "\t" + INFOS + "\t" + "\t".join(l[8:])
                outputfile.write(NewLine + "\n")
