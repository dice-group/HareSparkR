#16/10/2017
function getTransitionMatrices(name,data_dir){
	##Load data
	if (substring(name,nchar(name)-4)==".ttl")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-3)==".nt")  name = substring(name,1,nchar(name)-3)
	loadpath = paste(data_dir , "Matrices/",sep="")
	savepath = paste(data_dir , "Matrices/",sep="")
	E2I = load(paste(loadpath , "e2i_" , name , ".RData")) # set of Entities
	T2I = load(paste(loadpath , "t2i_" , name , ".RData")) # set of Triples
	
	#initialize
	i = 0
	F = Matrix::Matrix(0, nrow =length(E2I), ncol = length(T2I), sparse = TRUE)
	W = Matrix::Matrix(0, nrow =length(T2I), ncol = length(E2I), sparse = TRUE)
	#?f = defaultdict(int)
	#?w = defaultdict(int)
	print("CONSTRUCTING DICTIONARY OF KEYS")
	
	k = 0
	for t, i in T2I.items():
		k += 1
		sys.stdout.write('\r')

}