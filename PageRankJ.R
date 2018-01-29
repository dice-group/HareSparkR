
matpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Matrices\\'
respath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Results\\'
# obama airports sider dogfood
name='obama'
print(load(paste(matpath , "F_",name,".RData",sep='')))
	print(load(paste(matpath , "W_",name,".RData",sep='')))
	dim(F)
	dim(W)
	
	print("CALCULATING P_N")
	# P = sparse.bmat([[None, W], [F, None]])
	blk1 = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(W),ncol(F)))
	blk2 = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(F),ncol(W)))
	P=rbind(cbind(blk1,W),cbind(F,blk2))
	n = nrow(P)
##----------------------------####
### Java
 damping = 0.85
 d_P_T= damping*Matrix::t(P)
 ones = rep(1,n)/n
 d_ones=(1-damping)*ones
 
TMPmat <- as(d_P_T, "TsparseMatrix")

 ia=TMPmat@i
 ja=TMPmat@j
 x=TMPmat@x
 # order by row
 ro=order(ia)
 
  library(rJava)
	.jinit('.')
	.jaddClassPath('D:/spark/pca/target/pca-1.0.jar')
	source('D:\\spark\\pca\\src\\main\\java\\org\\sparkexample\\addPath.R')
	print(.jclassPath())
	hjw <- .jnew("org.sparkexample.matMultiply") # create instance of HelloJavaWorld class
	repetitions=5
	runtimes_pgJ = NULL
	for ( i in 1:repetitions){
		tic=proc.time();
		S_n=hjw$hare(.jarray(ia[ro],dispatch=T),.jarray(ja[ro],dispatch=T),.jarray(x[ro],dispatch=T),nc=nrow(P),.jarray(d_ones,dispatch=T),0.001,damping,as.integer(1000))
		tac=proc.time()
		rtime=tac-tic
		runtimes_pgJ = c(runtimes_pgJ,rtime[3])
		print(c(i,rtime[3]))
	}
	
	print(sprintf("Average Runtime HARE: %.3f", mean(runtimes_pgJ)))
	distribution = S_n 
 	# Saving results 
	 load(paste(matpath , "e2i_" , name , ".RData",sep=""))
	 load(paste(matpath , "t2i_" , name , ".RData",sep=""))
	 # tmp=data.frame(Entity=names(E2I),Probability=as.vector(resourcedistribution))[order(resourcedistribution,decreasing=TRUE),]		
	  # write.csv(file=paste(respath , "results_resources_" , name , "_PAGERANK.txt",sep=''),tmp,row.names=FALSE)
	  tmp = data.frame(Entity=names(E2I),probability=as.vector(distribution[1:length(E2I)]))
	  tmp = rbind(tmp,data.frame(Entity=paste(T2I[,1],T2I[,2],T2I[,3],sep=' '),probability=as.vector(distribution[(length(E2I)+1):n])))
	  write.csv(file=paste(respath , "results_resources_" , name , "_PAGERANK.txt",sep=''),tmp,row.names=FALSE)

	 # ============================ Compare to R =================
	
	
	 source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\hare.R")
	fname="airports.xml"
	 
	 runtime = pageRank(fname,loadpath=matpath,savepath=respath, epsilon=10^-3, damping = .85, saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
	 