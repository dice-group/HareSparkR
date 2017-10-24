# test parseRDF
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\parseRDF.R")
fname='dbpedia_2015-10.xml'
# fname='dbpedia100k.xml'

tic=proc.time()
loadpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\KnowledgeBases\\'
savepath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\Matrices\\'
parseRDF(name=fname,data_dir=dd)
tac=proc.time()
print(tac-tic)
#######
## test getTransitionMatrices
tic2=proc.time()
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\getTransitionMatrices.R")
getTransitionMatrices(fname,data_dir=dd)
tac2=proc.time()
print(tac2-tic2)

########
####test hare
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\hare.R")
tic3=proc.time()
hare(fname,dd, epsilon=10^-2, damping = .85, saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)

print(".....HARE.....")
runtimes_hare = np.array(repetitions*[.0])
for i in range(repetitions-1):
	runtime = hare(data, epsilon=10**(-2), damping = .85, saveresults=True, printerror=False, printruntimes=True)
	runtimes_hare[i] = runtime
print("Average Runtime HARE: ", np.mean(runtimes_hare))

tac3=proc.time()
print(tac3-tic3)
############## test pagerank ################
print(".....PAGERANK.....")
loadpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\Matrices\\'
savepath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\Data\\Results\\'
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSaprkR\\HareSparkR\\pageRank.R")
    tic4=proc.time()
    runtime = pagerank(fname,loadpath,savepath,maxIterations=1000, epsilon=10**(-3), damping = .85,  saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
	tac4=proc.time()
    print(tac4-tic4)
print(runtime)