#16/10/2017
# Calculate W:the transition matrix from triples to entities. 
#       and F:the matrix of which the entries are the transition probabilities
#             from entities to triples,

function getTransitionMatrices(name,data_dir){
	##Load data
	if (substring(name,nchar(name)-4)==".ttl")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-3)==".nt")  name = substring(name,1,nchar(name)-3)
	loadpath = paste(data_dir , "Matrices/",sep="")
	savepath = paste(data_dir , "Matrices/",sep="")
	# E2I = load(paste(loadpath , "e2i_" , name , ".RData")) # set of Entities
	# T2I = load(paste(loadpath , "t2i_" , name , ".RData")) # set of Triples
	E2I = list(BarackObama=c(1,2), party=c(2,1), Democrates=c(3,1),spouse=c(4,1),MichelleObama=c(5,1))
	T2I = data.frame(s=c("BarackObama","BarackObama"),p=c("party","spouse"),o=c("Democrates","MichelleObama"),stringsAsFactors=FALSE)
	

	#initialize
	i = 0
	F = Matrix::Matrix(0, nrow =length(E2I), ncol = nrow(T2I), sparse = TRUE)
	W = Matrix::Matrix(0, nrow =nrow(T2I), ncol = length(E2I), sparse = TRUE)
	#?f = defaultdict(int)
	#?w = defaultdict(int)
	print("CONSTRUCTING DICTIONARY OF KEYS")
	
	# k = 0
	print("\CALCULATING MATRIX W & F...")
	
	for(i in 1:nrow(T2I)){#may be done with lapply
		for (e in T2I[i,]){		
			#edge from entity_j to triple_i detected
			j=E2I[e][[1]][1]
			W[i, j] = 1.0/3
			F[j, i] = 1.0/E2I[e][[1]][2]
		}
	}            
####################################
	save(file=paste(savepath , "W_" , name ,".RData"),W)
	save(file=paste(savepath , "F_" , name ,".RData"),F)

}

