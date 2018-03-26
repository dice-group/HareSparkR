
matpath='~/datasets/datasets/mat/mats/'
respath='~/datasets/results'
# airports sider dogfood lubm50fix dbpedia 
name='lubm20fix'
print(load(paste(matpath , "F_",name,".RData",sep='')))
	print(load(paste(matpath , "W_",name,".RData",sep='')))
	dim(F)
	dim(W)
	P = F %*% W #sparse.csr_matrix(F.dot(W))
	n = nrow(P)
##----------------------------####
### Java
damping = 0.85
 d_P_T= damping* P ## keep transposed
 ones = rep(1,n)/n
 d_ones=(1-damping)*ones
 
# TMPmat <- as(d_P_T, "TsparseMatrix")
	TMPmat <- d_P_T
 ia=TMPmat@i
 p=TMPmat@p
 x=TMPmat@x
 
  library(rJava)
	# .jinit('.')
	.jinit(parameters="-Xmx80g")
	.jaddClassPath('/home/AbdelmonemAamer/spark/pca/target/pca-1.0.jar')
	source('/home/AbdelmonemAamer/spark/pca/src/main/java/org/sparkexample/addPathCls.R')
	# .jaddClassPath("/home/AbdelmonemAamer/spark/pca")
	print(.jclassPath())
	hjw <- .jnew("org.sparkexample.matMultiply") # create instance of HelloJavaWorld class
	repetitions=3
	runtimes_hareJ = NULL
	for ( i in 1:repetitions){
		tic=proc.time();
		S_n=hjw$PageRankLoop(.jarray(ia,dispatch=T),.jarray(p,dispatch=T),.jarray(x,dispatch=T),nr=nrow(P),
				.jarray(d_ones,dispatch=T), 0.001,damping,as.integer(1000),
				name,"local[*]","16g")#sc_cores=
		tac=proc.time()
		rtime=tac-tic
		runtimes_hareJ = c(runtimes_hareJ,rtime[3])
		print(c(i,rtime[3]))
	}
	
	print(sprintf("Average Runtime HARE: %.3f", mean(runtimes_hareJ)))
	
 	resourcedistribution = S_n  #S(N)
	tripledistribution = Matrix::t(F) %*% S_n #Equation 6, S(T)
	#Scale with equation 8 to get a distribution [8.11.17]
	
	Alpha = n
	Beta = nrow(tripledistribution)
	scaleS_N = Beta/(Alpha+Beta)
	scaleS_T = 1-scaleS_N
	resourcedistribution = resourcedistribution * scaleS_T
	tripledistribution = tripledistribution * scaleS_N
	 # Saving results 
	 load(paste(matpath , "e2i_" , name , ".RData",sep=""))
	 tmp=data.frame(Entity=names(E2I),Probability=as.vector(resourcedistribution))[order(resourcedistribution,decreasing=TRUE),]		
	  write.csv(file=paste(respath , "results_resources_" , name , "_HARE.txt",sep=''),tmp,row.names=FALSE)

	 # ============================ Compare to R =================
	
	 source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\hare.R")
	fname="airports.xml"
	 
	 runtime = hare(fname,loadpath=matpath,savepath=respath, epsilon=10^-3, damping = .85, saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
	 