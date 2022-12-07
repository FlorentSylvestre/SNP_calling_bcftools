args = commandArgs(trailingOnly = T)
library(data.table)
sumstats <- fread(args[1], header = T, stringsAsFactors = F,na.strings = ".")

str(sumstats)
pdf(paste(unlist(strsplit(args[1],".",fixed = T))[1],".meancov.pdf", sep =""))
hist(as.numeric(sumstats$MEAN_DEPTH), nclass = 50, xlab = "Mean per locus coverage",main ="")


#personnal zoom in data, hard to see the interesting range to plot

hist(as.numeric(sumstats$MEAN_DEPTH[sumstats$MEAN_DEPTH <=50]), nclass = 50, xlab = "Mean per locus coverage, zoom for coverage <50",main ="")

dev.off()
