#Obama.R
	E2I = list(BarackObama=c(1,2), party=c(2,1), Democrates=c(3,1),spouse=c(4,1),MichelleObama=c(5,1))
	T2I = data.frame(s=c("BarackObama","BarackObama"),p=c("party","spouse"),o=c("Democrates","MichelleObama"),stringsAsFactors=FALSE)
# save(file='e2i_obama.RData',E2I)
# save(file='t2i_obama.RData',T2I)
fname="obama.xml"

 # cd Hare/HARE-master/Data/KnowledgeBases/
rdfpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\KnowledgeBases\\'
matpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Matrices\\'
respath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Results\\'

source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\getTransitionMatrices.R")
getTransitionMatrices(fname,loadpath=matpath,savepath=matpath)
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\hare.R")
runtime = hare(fname,loadpath=matpath,savepath=respath, epsilon=10^-3, damping = .85, saveresults=TRUE, printerror=FALSE, printruntimes=TRUE)
## result in results folder
 

	print(load(paste(matpath , "F_obama.RData",sep='')))
	print(load(paste(matpath , "W_obama.RData",sep='')))
	dim(F)
	dim(W)
	P = F %*% W #sparse.csr_matrix(F.dot(W))
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
 # double[] hare(double[][] d_P_T, double[] d_ones,double epsilon,double damping,int maxIterations)
	bb=as.matrix(d_P_T)
 # S_n=hjw$hare(.jarray(bb,dispatch=T),.jarray(d_ones,dispatch=T),0.001,damping,as.integer(1000))
 S_n=hjw$hare(.jarray(ia[ro],dispatch=T),.jarray(ja[ro],dispatch=T),.jarray(x[ro],dispatch=T),nc=nrow(P),.jarray(d_ones,dispatch=T),0.001,damping,as.integer(1000))

S_n=c(0.3098126995242607,0.16990636522170185,0.16990636522170185,0.16990636522170185,0.16990636522170185)
	resourcedistribution = S_n  #S(N)
	tripledistribution = Matrix::t(F) %*% S_n #Equation 6, S(T)
	#Scale with equation 8 to get a distribution [8.11.17]
	
	Alpha = n
	Beta = nrow(tripledistribution)
	scaleS_N = Beta/(Alpha+Beta)
	scaleS_T = 1-scaleS_N
	resourcedistribution = resourcedistribution * scaleS_T
	tripledistribution = tripledistribution * scaleS_N
	 resourcedistribution
	 
	 
	 