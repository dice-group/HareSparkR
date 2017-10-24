# test parseRDF
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\parseRDF.R")
# fname='dbpedia_2015-10.xml'
fname='dailymed_dump.xml'
# fname='dbpedia100k.xml'

tic=proc.time()
rdfpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\KnowledgeBases\\'
matpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\Matrices\\'
respath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\Results\\'
parseRDF(name=fname,loadpath=rdfpath,savepath=matpath)
tac=proc.time()
print(tac-tic)
#######
## test getTransitionMatrices
tic2=proc.time()
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\getTransitionMatrices.R")
getTransitionMatrices(fname,loadpath=matpath,savepath=matpath)
tac2=proc.time()
print(tac2-tic2)

########
####test hare
repetitions=5
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\hare.R")
tic3=proc.time()


print(".....HARE.....")
runtimes_hare = NULL
for ( i in 1:repetitions){
	runtime = hare(fname,loadpath=matpath,savepath=respath, epsilon=10^-2, damping = .85, saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
	runtimes_hare = c(runtimes_hare,runtime)
}
	print(sprintf("Average Runtime HARE: %.3f", mean(runtimes_hare)))
tac3=proc.time()
print(tac3-tic3)
############## test pagerank ################
print(".....PAGERANK.....")
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\pageRank.R")
    tic4=proc.time()
runtimes_pagerank = NULL
for ( i in 1:repetitions){
    runtime = pagerank(fname,loadpath=matpath,savepath=respath,maxIterations=1000, epsilon=10**(-3), damping = .85,  saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
	runtimes_pagerank = c(runtimes_pagerank,runtime)
}
	print(sprintf("Average Runtime PAGERANK: %.3f", mean(runtimes_pagerank)))
	tac4=proc.time()
    print(tac4-tic4)
