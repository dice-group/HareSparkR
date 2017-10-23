# test parseRDF
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\parseRDF.R")

dd='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\'
parseRDF(name='dbpedia100k.xml',data_dir=dd)

#######
## test getTransitionMatrices

source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\getTransitionMatrices.R")
getTransitionMatrices(name='dbpedia100k.xml',data_dir=dd)
