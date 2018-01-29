
hadpath='/user/hadoop/abd/'
matpath='/home/hadoop/abd/mat/'
respath='/home/hadoop/abd/res/'
damping = 0.85
# airports sider dogfood lubm50fix dbpedia 
name='dbpedia'
print(load(paste(matpath , "F_",name,".RData",sep='')))
	print(load(paste(matpath , "W_",name,".RData",sep='')))
	dim(F)
	dim(W)
	P = F %*% W #sparse.csr_matrix(F.dot(W))
	n = nrow(P)
##--------------*************par file*************--------------####
params=c(paste("nr=",nrow(P),sep=''),
		paste("damping=",damping,sep=''),
		"epsilon=0.001",
		"maxIterations=1000",
		"Algorithm=HARE",
		paste("matpath=",hadpath,sep=''),#path in hdfs
		paste("dataset=",name,sep='')
		)

con <- file(paste(matpath, name,"_HARE.par",sep=''), "w", blocking = FALSE)
writeLines(params,con)
close(con)
### Java
 d_P_T= damping* t(P)
 
TMPmat <- as(d_P_T, "TsparseMatrix")
	# TMPmat <- d_P_T
 ia=TMPmat@i
 ja=TMPmat@j
 x=TMPmat@x
## Prepare run
write.table(data.frame(ia,ja,x), file=paste(matpath , "P_",name,"_HARE.csv",sep=''), row.names=FALSE, col.names=FALSE, sep=",")
system2("hadoop",paste("fs -rm",paste(hadpath , "P_",name,"_HARE.csv",sep=''),sep=' '))#overwrite
system2("hadoop",paste("fs -put",paste(matpath , "P_",name,"_HARE.csv",sep=''),hadpath,sep=' '))
##  Submit

## process results
###----------------------------------------------------------------------------
	
	S_n = read.table(paste("Sn_",name,"_HARE.csv",sep=''));
	 S_n=as.matrix(S_n,ncol=1)
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
	 tmp=data.frame(Entity=row.names(E2I),Probability=as.vector(resourcedistribution))[order(resourcedistribution,decreasing=TRUE),]		
	  write.csv(file=paste(respath , "results_resources_" , name , "_HARE.txt",sep=''),tmp,row.names=FALSE)





##########################################################################################################
##########################################################################################################
	  # ============================ Compare to R =================
	
	 source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\hare.R")
	fname="airports.xml"
	 
	 runtime = hare(fname,loadpath=matpath,savepath=respath, epsilon=10^-3, damping = .85, saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
fname=	 paste(matpath , "P_",name,".csv",sep='')
	 trp=read.table(fname,sep=',',quote = "",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)
