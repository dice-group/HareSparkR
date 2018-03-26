##########################################################################
fname="C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HARE-master\\Data\\KnowledgeBases\\dbpedia_2015-10.nt"
# Geiser

	name="lubm5k"
	savepath="/home/AbdelmonemAamer/shared/mats/"
	fname=paste("/home/AbdelmonemAamer/shared/kg/",name,'.nt',sep='')
	tic=proc.time()
	trp=read.table(fname,sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)
	dim(trp)
	sum(is.na(unlist(trp[,4])))##test wrong
	print(object.size(trp))
	T2I=trp[,1:3]
	rm(trp) # for memory usage
	flg=duplicated(paste(T2I[,1],T2I[,2],T2I[,3],sep=''))
	T2I=T2I[!flg,]
	dim(T2I)
	save(file=paste(savepath , "t2i_" , name , ".RData",sep=""),T2I)
	tic1=proc.time()
		Ent=table(unlist(c(T2I[,1],T2I[,2],T2I[,3])))
		E2I=cbind(sn=1:length(Ent),cnt=Ent)
	# savepath='/data/home/AbdelmonemAamer/datasets/datasets/mat/mats/'
	tic2=proc.time()
	save(file=paste(savepath , "e2i_" , name , ".RData",sep=""),E2I)
	tac=proc.time()
	print(tac-tic1)
	print(tac-tic)


# fname="D:\\rdf\\lubm20fix.nt"
savepath='/home/hadoop/abd/mat/'
name='lubm5k'
# fname=paste('/data/home/AbdelmonemAamer/datasets/datasets/',name,'.nt',sep='')
fname=paste('/home/hadoop/abd/kg/',name,'.nt',sep='')
tic=proc.time()
trp=read.table(fname,sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)
dim(trp)
sum(is.na(unlist(trp[,4])))
print(object.size(trp))
T2I=trp[,1:3]
rm(trp) # for memory usage
save(file=paste(savepath , "t2i_" , name , ".RData",sep=""),T2I)
tic1=proc.time()
	Ent=table(unlist(c(T2I[,1],T2I[,2],T2I[,3])))
	E2I=cbind(sn=1:length(Ent),cnt=Ent)
# savepath='/data/home/AbdelmonemAamer/datasets/datasets/mat/mats/'
tic2=proc.time()
save(file=paste(savepath , "e2i_" , name , ".RData",sep=""),E2I)
tac=proc.time()
print(tac-tic1)
print(tac-tic)
## remove duplicated triples

##  print(load(paste(savepath , "t2i_" , name , ".RData",sep="")))
flg=duplicated(paste(T2I[,1],T2I[,2],T2I[,3],sep=''))
T2I=T2I[!flg,]
 

<http://dbpedia.org/ontology/number> <http://www.w3.org/2000/01/rdf-schema#comment> "Jersey number of an Athlete (sports player, eg \"99\") or sequential number of an Album (eg \"Third studio album\")"@en .


############################################################
parseNT
getLine
get subj uri
get pred uri
rest of line Literal
ln='<subject> <predicat> object'
some subjects are blank noes _xxxx

####
source("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\parseNT.R")

# rdfpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\KnowledgeBases\\'
rdfpath='D:\\RDF\\'
matpath='D:\\RDF\\mats\\pnt\\'
fname='dbpedia.nt'

tic=proc.time()
parseNT(name=fname,loadpath=rdfpath,savepath=matpath)
tac=proc.time()
print(tac-tic)
####testing#####
name = substring(fname,1,nchar(fname)-3)
print(load(paste(matpath , "e2i_" , name , ".RData",sep=""))) # set of Entities E2I
print(load(paste(matpath , "t2i_" , name , ".RData",sep=""))) # set of Triples  T2I
 pe=E2I
 pt=T2I
matpath='D:\\RDF\\mats\\'
load(paste(matpath , "e2i_" , name , ".RData",sep="")) # set of Entities E2I
load(paste(matpath , "t2i_" , name , ".RData",sep="")) # set of Triples  T2I
pen=row.names(pe)
rn=names(E2I)
length(pen)
length(rn)
# the problem is %5C char
###### Cluster
source("~/hare/HARE/HareSparkR/HareSparkR/parseNT.R")
matpath='/data/home/AbdelmonemAamer/datasets/datasets/mat/mats/'
rdfpath='/data/home/AbdelmonemAamer/datasets/datasets/'
tic=proc.time()
parseNT(name='dbpedia.nt',loadpath=rdfpath,savepath=matpath)
tac=proc.time()
print(tac-tic)

matpath='/data/home/AbdelmonemAamer/datasets/datasets/mat/mats/'
name='dbpedia'
load(paste(matpath , "e2i_" , name , ".RData",sep="")) # set of Entities E2I
pe=E2I
pen=row.names(pe)
# table(substring(pen,1,1))
length(unique(substring(pen,2)))
aa=substring(pen,1,1)
bb=pen[aa==' ']
cc=pen[aa!=' ']
bb=substring(bb,2)
sum(bb %in% cc)

print(load(paste(matpath , "t2i_" , name , ".RData",sep="")))
tt=T2I
T2I[,3]=substring(T2I[,3],2)
Ent=table(unlist(c(T2I[,1],T2I[,2],T2I[,3])))
	E2I=cbind(sn=1:length(Ent),cnt=Ent)
print(sprintf("# Triples: %d, #unique entities: %d, # escaped triples: %d",nrow(T2I),nrow(E2I),0))
save(file=paste(matpath , "e2i_" , name , "1.RData",sep=""),E2I)
save(file=paste(matpath , "t2i_" , name , "1.RData",sep=""),T2I)

T2I=T1
save(file=paste(matpath , "t2i_" , name , ".RData",sep=""),T2I)

###replicated triples
  flg=duplicated(paste(T2I[,1],T2I[,2],T2I[,3]))
  T1=T2I[!flg,]
  
########################Lnx
matpath='~/Hare/datasets/mats/'
rdfpath='~/Hare/datasets/'
parseNT(name='lubm500fix.nt',loadpath=rdfpath,savepath=matpath)
tac=proc.time()
print(tac-tic)

###########################################


 parseTriple <- function(ln1){
	pos=which(strsplit(ln1, "")[[1]]==">")
	s=substring(ln1,1,pos[1])
	p=substring(ln1,pos[1]+2,pos[2])
	o=substring(ln1,pos[2]+2)# leave one space after >

return(cbind(s=s,p=p,o=o))
}


parseTriple1 <- function(ln){
	st=strsplit(ln, ">")
	s=paste(st[[1]][1],'>',sep="")
	p=paste(st[[1]][2],'>',sep="")
	o=substring(ln,nchar(s)+nchar(p)+2)# leave one space after >

return(data.frame(s=s,p=p,o=o,stringsAsFactors=F))
}

tic=proc.time()
Chunk_size=500
E2I=list()
Tall=NULL
T2I=NULL
# con <- file("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HARE-master\\Data\\KnowledgeBases\\dbpedia_2015-10.nt", "r", blocking = FALSE)
con <- file("~/Hare/datasets/airports.nt", "r", blocking = FALSE)#108 seconds
# con <- file("D:\\RDF\\airports.nt", "r", blocking = FALSE)#108 seconds
nt = 0
sn = 1
while(1==1){
	lnk=readLines(con, n=Chunk_size) # get one Chunk
	if(length(lnk)==0) break;
	for (li in 1:length(lnk)){
		ln = lnk[li]
		T=parseTriple(ln)
		# addTriple(T)
		# for(k in T){
			# tmp = E2I[[k]]
			# if(is.null(tmp)){
				# E2I[[k]]=c(sn,1)
				# sn = sn + 1
			# }else{ 
				# E2I[[k]][2] = tmp[2] + 1
			# }
		# }
			##Triples (assume no repeats)
			T2I=rbind(T2I,T)
		# ln=readLines(con, n=1) # get one line
		nt = nt + 1
		if(nt %% 100 ==0)print(sprintf("Triple: %d",nt))
		if(nt%%1000==0) {
				Tall=rbind(Tall,T2I)
				T2I=NULL
				}
	}
}
		Tall=rbind(Tall,T2I)
	T2I=Tall
	print("Calculating counts...")
	# browser()
	Ent=table(unlist(c(T2I[,1],T2I[,2],T2I[,3])))
	E2I=cbind(sn=1:length(Ent),cnt=Ent)

	print(sprintf("# Triples: %d, #unique entities: %d, # escaped triples: %d",nt,nrow(E2I),nerr))

tac=proc.time()
print(tac-tic)

save(file='e2i_dbpedia1.RData',E2I)
save(file='t2i_dbpedia1.RData',T2I)

close(con)

ty=as.vector(rbind(tt[,1],tt[,2],tt[,3]))
 length(unique(ty)
 

 # 1.25 sec
tb4=proc.time() 
Chunk_size=10000
con <- file("C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HARE-master\\Data\\KnowledgeBases\\dbpedia_2015-10.nt", "r", blocking = FALSE)
sn =1
while(1==1){
	lnk=readLines(con, n=Chunk_size) # get one Chunk
	if(length(lnk)==0) break;
	print(sn)
	sn=sn+1
}
	close(con)
taft=proc.time()
print(taft-tb4)


tic=proc.time()
parseTriple <- function(ln){
	st=strsplit(ln, " ")
	s=st[[1]][1]
	p=st[[1]][2]
	o=substring(ln,nchar(s)+nchar(p)+2,nchar(ln)-2)# leave one space after >

return(data.frame(s=s,p=p,o=o,stringsAsFactors=F))
}

ln='<http://datasets.freme-project.eu/airports/id/1> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://schema.org/Place> .'

parseTriple(ln)

####### getTriples
getTriplesNT<-function(fname){
	Chunk_size=5000
	Tall=NULL
	trp=NULL
	con <- file(fname, "r", blocking = FALSE)#108 seconds
	nt = 0
	# sn = 1
	while(1==1){
		lnk=readLines(con, n=Chunk_size) # get one Chunk
		if(length(lnk)==0) break;
		for (li in 1:length(lnk)){
			ln = lnk[li]
			# which(strsplit(ln, "")[[1]]=="2")
			st=strsplit(ln, " ")
			s=st[[1]][1]
			p=st[[1]][2]
			o=substring(ln,nchar(s)+nchar(p)+3,nchar(ln)-2)# leave one space after >
				##Triples (assume no repeats)
				trp=rbind(trp,cbind(s,p,o))
			nt = nt + 1
			if(nt %% 1000 ==0)print(sprintf("Triple: %d",nt))
			if(nt%%10000==0) {
					Tall=rbind(Tall,trp)
					trp=NULL
					}
		}
	}
		Tall=rbind(Tall,trp)
	return(Tall)	
}