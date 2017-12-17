# test parseRDF
# .xml ->parseRDF -[E2I,T2I]->getTrnsMat -[F,W]->hare -[S_N,S_T]->getRankedLists-[RankedLists]
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\parseRDF.R")
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\getTransitionMatrices.R")
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\hare.R")
rdfpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\KnowledgeBases\\'
matpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Matrices\\'
respath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Results\\'

# fname='obama.xml'
# fname='sec.xml'
# fname='lubm20fix.xml'
fname='lubm200fix.xml'
# fname='lubm50fix.xml'
# fname='uspto.xml'
# fname='airports.xml'
# fname='sider.xml'
# fname='dogfood.xml'

rdfpath='D:\\RDF\\'
matpath='D:\\RDF\\mats\\'

tic=proc.time()
parseRDF(name=fname,loadpath=rdfpath,savepath=matpath)
tac=proc.time()
print(tac-tic)
#######
## test getTransitionMatrices
tic2=proc.time()
getTransitionMatrices(fname,loadpath=matpath,savepath=matpath)
tac2=proc.time()
print(tac2-tic2)

########
####test hare
repetitions=5
tic3=proc.time()

print(".....HARE.....")
runtimes_hare = NULL
for ( i in 1:repetitions){
	runtime = hare(fname,loadpath=matpath,savepath=respath, epsilon=10^-3, damping = .85, saveresults=FALSE, printerror=FALSE, printruntimes=TRUE)
	runtimes_hare = c(runtimes_hare,runtime)
}
	print(sprintf("Average Runtime HARE: %.3f", mean(runtimes_hare)))
tac3=proc.time()
print(tac3-tic3)
############## test pagerank ################
print(".....PAGERANK.....")
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\pageRank.R")
    tic4=proc.time()
runtimes_pagerank = NULL
for ( i in 1:repetitions){
    runtime = pagerank(fname,loadpath=matpath,savepath=respath,maxIterations=1000, epsilon=10**(-3), damping = .85,  saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
	runtimes_pagerank = c(runtimes_pagerank,runtime)
}
	print(sprintf("Average Runtime PAGERANK: %.3f", mean(runtimes_pagerank)))
	tac4=proc.time()
    print(tac4-tic4)

	############### F&W
	load(paste(matpath,'F_sider.RData',sep=''))
	load(paste(matpath,'W_sider.RData',sep=''))
	Fn=F
	Wn=W
	load(paste(matpath,'F_siderOK.RData',sep=''))
	load(paste(matpath,'W_siderOK.RData',sep=''))
	all(F@i==Fn@i)
	all(F@p==Fn@p)
	all(F@x==Fn@x)
	########################################################
	