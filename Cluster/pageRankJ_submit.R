
hadpath='/user/hadoop/abd/'
matpath='/home/hadoop/abd/mat/'
respath='/home/hadoop/abd/res/'
# airports sider dogfood lubm50fix dbpedia 
name='sider'
print(load(paste(matpath , "F_",name,".RData",sep='')))
	print(load(paste(matpath , "W_",name,".RData",sep='')))
	dim(F)
	dim(W)
	# P = F %*% W #sparse.csr_matrix(F.dot(W))
	print("CALCULATING P_N")
	# P = sparse.bmat([[None, W], [F, None]])
	blk1 = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(W),ncol(F)))
	blk2 = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(F),ncol(W)))
	P=rbind(cbind(blk1,W),cbind(F,blk2))
	n = nrow(P)
##----------------------------####
### Java
damping = 0.85
 d_P_T= damping* t(P)
 # ones = rep(1,n)/n
 # d_ones=(1-damping)*ones
 
TMPmat <- as(d_P_T, "TsparseMatrix")
	# TMPmat <- d_P_T
 ia=TMPmat@i
 ja=TMPmat@j
 x=TMPmat@x
## Prepare run
write.table(data.frame(ia,ja,x), file=paste(matpath , "P_",name,"_PageRank.csv",sep=''), row.names=FALSE, col.names=FALSE, sep=",")
system2("hadoop",paste("fs -rm",paste(hadpath , "P_",name,"_PageRank.csv",sep=''),sep=' '))#overwrite
system2("hadoop",paste("fs -put",paste(matpath , "P_",name,"_PageRank.csv",sep=''),hadpath,sep=' '))
##  Submit
params=c(paste("nr=",nrow(P),sep=''),
		paste("damping=",damping,sep=''),
		"epsilon=0.001",
		"maxIterations=1000",
		"Algorithm=PageRank",
		paste("matpath=",hadpath,sep=''),#path in hdfs
		paste("dataset=",name,sep='')
		)

con <- file(paste(matpath, name,"_PageRank.par",sep=''), "w", blocking = FALSE)
writeLines(params,con)
close(con)

## process results
	
	S_n = read.table(paste("Sn_",name,"_PageRank.csv",sep=''));
	 S_n=as.matrix(S_n,ncol=1)
 	distribution = S_n 
 	# Saving results 
	 load(paste(matpath , "e2i_" , name , ".RData",sep=""))
	 load(paste(matpath , "t2i_" , name , ".RData",sep=""))

	 #tmp = data.frame(Entity=names(E2I),probability=as.vector(distribution[1:length(E2I)]))
	  tmp = data.frame(Entity=row.names(E2I),probability=as.vector(distribution[1:nrow(E2I),1]))
     tmp = rbind(tmp,data.frame(Entity=paste(T2I[,1],T2I[,2],T2I[,3],sep=' '),probability=as.vector(distribution[(length(E2I)+1):n])))
	 write.csv(file=paste(respath , "results_resources_" , name , "_PAGERANK.txt",sep=''),tmp,row.names=FALSE)
