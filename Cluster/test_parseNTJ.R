name="sider"
savepath="D:\\RDF\\mats\\"
loadpath="D:\\RDF\\"
fname=paste(loadpath,name,".nt",sep='')

    library(rJava)
	.jinit(parameters="-Xmx400g")
	.jaddClassPath('C:/Users/Abdelmonem/Dropbox/HARE/HareSparkR/HareSparkR/Java/pca/target/parseNT.jar')
	print(.jclassPath())
	hjw <- .jnew("parseNT.parseNT") # create instance of HelloJavaWorld class
	
	tic=proc.time();
	cnt=hjw$linecount(fname)
	trp=hjw$getTriples_cnt(fname,as.integer(cnt))
	# cc=do.call(rbind, lapply(trp, .jevalArray))
	cc=lapply(trp, .jevalArray)
	tac=proc.time()
	rtime=tac-tic
	print(rtime)

	
##########################------------------------------------------------------
name="sec"
savepath="D:\\RDF\\mats\\"
# loadpath="C:\\Users\\Abdelmonem\\Dropbox\\Java\\ec-workspace\\parseNT\\"
loadpath="D:\\RDF\\parseNT\\"
t1=proc.time()
	con <- file(paste(loadpath,name,"_s.txt",sep=''), "r", blocking = FALSE)
	S=as.integer(readLines(con))
	close(con)
	con <- file(paste(loadpath,name,"_p.txt",sep=''), "r", blocking = FALSE)
	Prd=as.integer(readLines(con))
	close(con)
	con <- file(paste(loadpath,name,"_ol.txt",sep=''), "r", blocking = FALSE)
	O=as.integer(readLines(con))
	close(con)

	con <- file(paste(loadpath,name,"_Ent.txt",sep=''), "r", blocking = FALSE)
	Ent=readLines(con)
	close(con)
	con <- file(paste(loadpath,name,"_E_cnt.txt",sep=''), "r", blocking = FALSE)
	E_cnt=as.integer(readLines(con))
	close(con)
#optional
	# Tind=cbind(S,P,O)#indexes to Ent
save(file=paste(savepath , "ds_" , name , ".RData",sep=""),S,O,Prd,Ent,E_cnt)
	t2=proc.time()
	t2-t1
##-------------------------------------------------------------------------
	# print(load(paste(savepath , "ds_" , name , ".RData",sep="")))

## getTransidtionMatrix_Tind()
#initialize
    E_cnt=E_cnt[-1]
	t3=proc.time()
	Beta=length(S)
	Alpha=length(E_cnt)
	F = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(Alpha, Beta))
	W = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(Beta, Alpha))
	
	print("CALCULATING MATRIX W & F...")
	
	print('Subject...')
	W[cbind(1:Beta,S)]=1.0/3
	F[cbind(S,1:Beta)]=1.0/E_cnt[S]
		
	print('Predicate...')
	W[cbind(1:Beta,Prd)]=1.0/3
	F[cbind(Prd,1:Beta)]=1.0/E_cnt[Prd]
		
	print('Object...')
	W[cbind(1:Beta,O)]=1.0/3
	F[cbind(O,1:Beta)]=1.0/E_cnt[O]
		
	t4=proc.time()
	t4-t3

# P=F%*%W
epsilon=1e-3; damping=0.85; maxIterations=12;
d_P_T = damping*Matrix::t(F %*% W) #sparse.csr_matrix(F.dot(W))
n = nrow(d_P_T)
ones = rep(1,n)/n

previous = ones = rep(1,n)/n
	d_ones = (1-damping)*ones
	error = 1
	 #Equation 9
	tic2 = proc.time()
	ni=0
	while (error > epsilon && ni < maxIterations){
		ni = ni + 1
		tmp = previous
		previous = d_P_T%*%(previous) + d_ones
		error = norm(as.matrix(tmp - previous),"f")
		
		print(sprintf("ni:%d,max index:%d,max:%f,sumSn:%f",ni,which.max(as.vector(previous)),max(previous),sum(previous)));
		# if(printerror)
			print(error)
	}

	
print(load('P_ch_sec.RData'))	
	
	
	#################################
	print('Saving files...')
	save(file=paste(savepath , "W_" , name ,".RData",sep=""),W)
	save(file=paste(savepath , "F_" , name ,".RData",sep=""),F)

	
#Check F&W: the order of Ent is different!!
Fnew=F
Wnew=W
load(paste(savepath , "W_" , name ,"_ok.RData",sep=""))
load(paste(savepath , "F_" , name ,"_ok.RData",sep=""))
Fold=F
Wold=W
identical(Fold,Fnew)

#optional------------------------------------------------
	E2I=cbind(sn=1:length(Ent),cnt=E_cnt)
	row.names(E2I)=Ent
	T2I=cbind(Ent[S],Ent[P],Ent[O])

    save(file=paste(savepath , "e2i_" , name , ".RData",sep=""),E2I)
    save(file=paste(savepath , "t2i_" , name , ".RData",sep=""),T2I)

	
	
	# F_ob=rbind(c(0.5,0.5),c(1,0),c(0,1),c(0,1),c(1,0))
	# W_ob=rbind(c(1/3,1/3, 0,0, 1/3), c(1/3, 0,1/3,1/3, 0))
	# P_ob=F_ob %*% W_ob
	
	
	# A=matrix(c(2,1,5,3, 0,7,1,6, 9,2,4,4, 3,6,7,2), byrow=T,nrow=4)
	# B=matrix(c(6,1,2,3, 4,5,6,5, 1,9,8,-8, 4,0,-8,5), byrow=T,nrow=4)
	# C=A %*% B
	
	# F1=A[,1:2]
	# F2=A[,3:4]
	# W1=B[1:2,]
	# W2=B[3:4,]
	## [F1 F2] * [W1 W2]^T
	# c11=F1%*%W1
	# c22=F2%*%W2
	# identical(C,c11+c22)
	