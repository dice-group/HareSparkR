#17/10/2017
 hare <- function(name,loadpath,savepath, epsilon=1e-3, damping, maxIterations=1000,saveresults=TRUE, printerror=FALSE, printruntimes=FALSE){
	
	if (substring(name,nchar(name)-3)==".xml")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-2)==".nt")  name = substring(name,1,nchar(name)-3)
	# loadpath = paste(data_dir , "Matrices\\",sep="")
	# savepath = paste(data_dir , "Matrices\\",sep="")
	# E2I = list(BarackObama=c(1,2), party=c(2,1), Democrates=c(3,1),spouse=c(4,1),MichelleObama=c(5,1))
	# T2I = data.frame(s=c("BarackObama","BarackObama"),p=c("party","spouse"),o=c("Democrates","MichelleObama"),stringsAsFactors=FALSE)

	tic=proc.time()
	#Load matrices
	print("LOADING MATRICES F & W")
	print(load(paste(loadpath , "F_" , name , ".RData",sep='')))
	print(load(paste(loadpath , "W_" , name , ".RData",sep='')))
	print(sprintf('Dim of F: %d,%d',nrow(F),ncol(F)))
	print(sprintf('Dim of W: %d,%d',nrow(W),ncol(W)))
	
	
	print("CALCULATING P_N")
	P = F %*% W #sparse.csr_matrix(F.dot(W))
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

    
	resourcedistribution = previous  #S_N
	tripledistribution = Matrix::t(F) %*% previous #Equation 6, S_T
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
		
	print("WRITING RESULTS")
		write.csv(file=paste(savepath , "results_resources_" , name , "_HARE.txt",sep=''),data.frame(names(E2I),as.vector(resourcedistribution)),row.names=FALSE)
		write.csv(file=paste(savepath , "results_triples_" , name , "_HARE.txt",sep=''),data.frame(paste(T2I[,1],T2I[,2],T2I[,3],sep=' '),as.vector(tripledistribution)),row.names=FALSE)
	}
	return (runtime2[3])
}