# test parseRDF
# .xml ->parseRDF -[E2I,T2I]->getTrnsMat -[F,W]->hare -[S_N,S_T]->getRankedLists-[RankedLists]
source("~/hare/HARE/HareSparkR/HareSparkR/parseRDF.R")
source("~/hare/HARE/HareSparkR/HareSparkR/getTransitionMatrices.R")
source("~/hare/HARE/HareSparkR/HareSparkR/hare.R")
# fname='obama.xml'
# fname='dogfood.xml'
fname='lubm100fix.xml'
# fname='lubm50fix.xml'
# fname='uspto.xml'

# rdfpath='~/hare/HARE/HareSparkR/Data/KnowledgeBases/'
# matpath='~/hare/HARE/HareSparkR/Data/Matrices/'
matpath='/data/home/AbdelmonemAamer/datasets/datasets/mat/mats/'
respath='~/hare/HARE/HareSparkR/Data/Results/'

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
repetitions=2
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


### Parsing stats/problems
### sider rapper:199865 triples, parserdf:163700
### airports 67267 Errors in timeZone int
### dogfood rapper:379231 triples , parserdf:305300

