#7/12/2017
# Calculate W:the transition matrix from triples to entities. 
	#       and F:the matrix of which the entries are the transition probabilities
	#             from entities to triples,

 getTransitionMatrices <-function(name,loadpath,savepath){
	##Load data
	if (substring(name,nchar(name)-3)==".xml")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-2)==".nt")  name = substring(name,1,nchar(name)-3)
	
	load(paste(loadpath , "e2i_" , name , ".RData",sep="")) # set of Entities E2I
	load(paste(loadpath , "t2i_" , name , ".RData",sep="")) # set of Triples  T2I
	
	# E2I = list(BarackObama=c(1,2), party=c(2,1), Democrates=c(3,1),spouse=c(4,1),MichelleObama=c(5,1))
	# T2I = data.frame(s=c("BarackObama","BarackObama"),p=c("party","spouse"),o=c("Democrates","MichelleObama"),stringsAsFactors=FALSE)
	print(sprintf("Number of entities loaded: %d",nrow(E2I)))
	print(sprintf("Number of triples loaded: %d",nrow(T2I)))
# browser()
	#initialize
	F = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(E2I), nrow(T2I)))
	W = Matrix::sparseMatrix(i=1,j=1,x=0,dims=c(nrow(T2I), nrow(E2I)))
	
	print("CALCULATING MATRIX W & F...")
	
	cname=c('subject','predicate','object')
	Beta=length(T2I[,1])
	for(co in 1:3){
		print(cname[co])
		j=match(T2I[,co],row.names(E2I))
		W[cbind(1:Beta,j)]=1.0/3
		F[cbind(j,1:Beta)]=1.0/E2I[j,2]
	}
####################################
	print('Saving files...')
	save(file=paste(savepath , "W_" , name ,".RData",sep=""),W)
	save(file=paste(savepath , "F_" , name ,".RData",sep=""),F)

}

# To Do: pred_index=, subj_index=, obj_index=,lit_index=,
# prd=unique(T2I[,2])
# pred_index=match(prd,E2I)
# j=pred_index[T2I[,2]]
