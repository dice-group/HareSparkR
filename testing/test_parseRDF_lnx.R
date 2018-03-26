# test parseRDF
# .xml ->parseRDF -[E2I,T2I]->getTrnsMat -[F,W]->hare -[S_N,S_T]->getRankedLists-[RankedLists]
source("/home/abdelmoneim/Dropbox/HARE/HareSparkR/HareSparkR/parseRDF.R")
source("/home/abdelmoneim/Dropbox/HARE/HareSparkR/HareSparkR/getTransitionMatrices.R")
source("/home/abdelmoneim/Dropbox/HARE/HareSparkR/HareSparkR/hare.R")
# fname='dbpedia_2015-10.xml'
# fname='dailymed_dump.xml'
# fname='dbpedia100k.xml'
# fname='obama.xml'
# fname='dogfood.xml'
# fname='uspto.xml'
#fname='sec.xml'
# fname='sider.xml'
# fname='airports.xml'
# fname='lubm20fix.xml'
fname='lubm50fix.xml'

tic=proc.time()
#rdfpath='/home/abdelmoneim/Dropbox/HARE/HareSparkR/Data/KnowledgeBases/'
rdfpath='/home/abdelmoneim/Hare/datasets/'
#matpath='/home/abdelmoneim/Dropbox/HARE/HareSparkR/Data/Matrices/'
matpath='/home/abdelmoneim/Hare/datasets/'
respath='/home/abdelmoneim/Dropbox/HARE/HareSparkR/Data/Results/'
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

