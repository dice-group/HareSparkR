#17/10/2017
function hare(name,data_dir, epsilon=1e-3, damping, maxIterations=1000,saveresults=TRUE, printerror=FALSE, printruntimes=FALSE){
	
	if (substring(name,nchar(name)-4)==".ttl")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-3)==".nt")  name = substring(name,1,nchar(name)-3)
	loadpath = paste(data_dir , "Matrices/",sep="")
	savepath = paste(data_dir , "Matrices/",sep="")
	# E2I = list(BarackObama=c(1,2), party=c(2,1), Democrates=c(3,1),spouse=c(4,1),MichelleObama=c(5,1))
	# T2I = data.frame(s=c("BarackObama","BarackObama"),p=c("party","spouse"),o=c("Democrates","MichelleObama"),stringsAsFactors=FALSE)

	tic=proc.time()
	#Load matrices
	print("LOADING MATRICES F & W")
	load(paste(load_dir , "F_" , name , ".RData"))
	load(paste(load_dir , "W_" , name , ".RData"))
	
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
	if(printruntimes)){
		print(c("RUNTIME with load: ", runtime))
		print(c("RUNTIME without load: ", runtime2))
	}
		
}