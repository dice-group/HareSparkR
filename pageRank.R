pageRank.R
 implements Google PageRank algorithm

function pagerank(name, epsilon, damping, saveresults=TRUE, printerror=FALSE, printruntimes=FALSE){
	if (substring(name,nchar(name)-4)==".ttl")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-3)==".nt")  name = substring(name,1,nchar(name)-3)
	
	
	
	tic=proc.time()
	#Load matrices
	print("LOADING MATRICES F & W")
	load(paste(load_dir , "F_" , name , ".RData"))
	load(paste(load_dir , "W_" , name , ".RData"))
	
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
	if(printruntimes)){
		print(c("RUNTIME with load: ", runtime))
		print(c("RUNTIME without load: ", runtime2))
	}
}
	
Entities:E2I
Triples: T2I
	