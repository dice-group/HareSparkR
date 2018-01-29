# test parseRDF
# .xml ->parseRDF -[E2I,T2I]->getTrnsMat -[F,W]->hare -[S_N,S_T]->getRankedLists-[RankedLists]
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\parseRDF.R")
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\getTransitionMatrices.R")
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\hare.R")
# fname='dbpedia_2015-10.xml'
# fname='dailymed_dump.xml'
# fname='dbpedia100k.xml'
# fname='obama.xml'
fname='sider.xml'

tic=proc.time()
rdfpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\KnowledgeBases\\'
matpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Matrices\\'
respath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Results\\'

print(load(paste(matpath,'t2i_airports.RData',sep='')))
print(load(paste(matpath,'e2i_airports.RData',sep='')))
object.size(T2I)
tt=T2I

source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\parseRDF.R")
tic=proc.time()
parseRDF(name=fname,loadpath=rdfpath,savepath=matpath)
tac=proc.time()
print(tac-tic)
####