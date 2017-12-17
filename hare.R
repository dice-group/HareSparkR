#17/10/2017
# Computes P(N), S(N) and S(T) From transition matrices F & W
# This function is inspired by function hare.py in HARE project

 hare <- function(name,loadpath,savepath, epsilon=1e-3, damping, maxIterations=1000,saveresults=TRUE, printerror=FALSE, printruntimes=FALSE){
	
	if (substring(name,nchar(name)-3)==".xml")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-2)==".nt")  name = substring(name,1,nchar(name)-3)
	
	tic=proc.time()
	#Load matrices
	print("LOADING MATRICES F & W")
	print(load(paste(loadpath , "F_" , name , ".RData",sep='')))
	print(load(paste(loadpath , "W_" , name , ".RData",sep='')))
	print(sprintf('Dim of F: %d,%d',nrow(F),ncol(F)))
	print(sprintf('Dim of W: %d,%d',nrow(W),ncol(W)))
	
	print("CALCULATING P(N)")#Eqn:(4)
	P = F %*% W #sparse.csr_matrix(F.dot(W))
	n = nrow(P)

	previous = ones = rep(1,n)/n
	error = 1
	 #Equation 9
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

    
	resourcedistribution = previous  #S(N)
	tripledistribution = Matrix::t(F) %*% previous #Equation 6, S(T)
	#Scale with equation 8 to get a distribution [8.11.17]
	
	Alpha = n
	Beta = nrow(tripledistribution)
	scaleS_N = Beta/(Alpha+Beta)
	scaleS_T = 1-scaleS_N
	resourcedistribution = resourcedistribution * scaleS_T
	tripledistribution = tripledistribution * scaleS_N
	
	tac = proc.time()
	runtime = tac-tic
	runtime2 = tac-tic2
	if(printruntimes){
		print(sprintf("RUNTIME with load: %.3f", runtime[3]))
		print(sprintf("RUNTIME without load: %.3f", runtime2[3]))
		print(sprintf("Number of iterations: %d", ni))
	}
	
	#Save results
	if(saveresults){
		print("LOADING DICTIONARIES")
		load(paste(loadpath , "e2i_" , name , ".RData",sep="")) # set of Entities E2I
		load(paste(loadpath , "t2i_" , name , ".RData",sep="")) # set of Triples  T2I
		
	print("WRITING RESULTS")### to be sorted in decreasing order
		tmp=data.frame(Entity=names(E2I),Probability=as.vector(resourcedistribution))[order(resourcedistribution,decreasing=TRUE),]		
		write.csv(file=paste(savepath , "results_resources_" , name , "_HARE.txt",sep=''),tmp,row.names=FALSE)
		tmp=data.frame(Triple=paste(T2I[,1],T2I[,2],T2I[,3],sep=' '),Probability=as.vector(tripledistribution))[order(tripledistribution,decreasing=TRUE),]
		write.csv(file=paste(savepath , "results_triples_" , name , "_HARE.txt",sep=''),tmp,row.names=FALSE)
	}
	return (runtime2[3])
}