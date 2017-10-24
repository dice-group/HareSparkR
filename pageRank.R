# pageRank.R
 # implements Google PageRank algorithm
# Reference: Sergey Brin and Lawrence Page. The anatomy of a large-scale hypertextual
#             web search engine. In Computer Networks and ISDN Systems,
#             pages 107–117. Elsevier Science Publishers B. V., 1998.
# This function is inspired by function pagerank.py in HARE project github.com

 pagerank <- function(name,loadpath, savepath, epsilon, damping,maxIterations=1000, saveresults=TRUE, printerror=FALSE, printruntimes=FALSE){
	if (substring(name,nchar(name)-3)==".xml")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-2)==".nt")  name = substring(name,1,nchar(name)-3)

	tic=proc.time()
	#Load matrices
	print("LOADING MATRICES F & W")
	print(load(paste(loadpath , "F_" , name , ".RData",sep='')))
	print(load(paste(loadpath , "W_" , name , ".RData",sep='')))
	# W:the transition matrix from triples to entities.
	print(sprintf('Dim of F: %d,%d',nrow(F),ncol(F)))
	# F:the matrix of which the entries are the transition probabilities from entities to triples,
	print(sprintf('Dim of W: %d,%d',nrow(W),ncol(W)))
	
	
	print("CALCULATING P_N")
	# P = sparse.bmat([[None, W], [F, None]])!!!!!!!!!!!!
	blk1 = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(W),ncol(F)))
	blk2 = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(F),ncol(W)))
	P=rbind(cbind(blk1,W),cbind(F,blk2))
	n = nrow(P)
	
	previous = ones = rep(1,n)/n
	error = 1
	 
	tic2 = proc.time()
	ni=0
	while (error > epsilon && ni < maxIterations){
		ni = ni + 1
		tmp = previous
		previous = damping*Matrix::t(P)%*%(previous) + (1-damping)*ones
		error = norm(as.matrix(tmp - previous),"f")
		if(printerror)
			print(error)
	}

	distribution = previous
	tac = proc.time()
	runtime = tac-tic
	runtime2 = tac-tic2
	if(printruntimes){
		print(c("RUNTIME with load: ", runtime))
		print(c("RUNTIME without load: ", runtime2))
	}
	
	#Save results
	if(saveresults){
		print("LOADING DICTIONARIES")
		load(paste(loadpath , "e2i_" , name , ".RData",sep="")) # set of Entities E2I
		load(paste(loadpath , "t2i_" , name , ".RData",sep="")) # set of Triples  T2I
		browser()
	print("WRITING RESULTS")
		tmp = data.frame(Entity=names(E2I),probability=as.vector(distribution[1:length(E2I)]))
		tmp = rbind(tmp,data.frame(Entity=paste(T2I[,1],T2I[,2],T2I[,3],sep=' '),probability=as.vector(distribution[(length(E2I)+1):n])))
		write.csv(file=paste(savepath , "results_resources_" , name , "_PAGERANK.txt",sep=''),tmp,row.names=FALSE)
	}
	return (runtime2[3])
}
	

	