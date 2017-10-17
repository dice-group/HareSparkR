#17/10/2017
function hare(name,data_dir, epsilon, damping, saveresults=TRUE, printerror=FALSE, printruntimes=FALSE){
	if (substring(name,nchar(name)-4)==".ttl")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-3)==".nt")  name = substring(name,1,nchar(name)-3)
	loadpath = paste(data_dir , "Matrices/",sep="")
	savepath = paste(data_dir , "Matrices/",sep="")
	# E2I = list(BarackObama=c(1,2), party=c(2,1), Democrates=c(3,1),spouse=c(4,1),MichelleObama=c(5,1))
	# T2I = data.frame(s=c("BarackObama","BarackObama"),p=c("party","spouse"),o=c("Democrates","MichelleObama"),stringsAsFactors=FALSE)

}