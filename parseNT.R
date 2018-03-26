parseNT <- function(name,loadpath,savepath){
	if (substring(name,nchar(name)-3)==".xml")  {ext =".xml"; name = substring(name,1,nchar(name)-4)}
	if (substring(name,nchar(name)-2)==".nt")  {ext=".nt"; name = substring(name,1,nchar(name)-3)}

	Chunk_size=5000
	E2I=list()
	Tall=NULL
	T2I=NULL
	con <- file(paste(loadpath,name,ext,sep=""), "r", blocking = FALSE)#108 seconds
	nt = 0
	# sn = 1
	while(1==1){## rbind is slow
		lnk=readLines(con, n=Chunk_size) # get one Chunk
		if(length(lnk)==0) break;
		for (li in 1:length(lnk)){
			ln = lnk[li]
			# T=parseTriple(ln)
			st=strsplit(ln, " ")
			s=st[[1]][1]
			p=st[[1]][2]
			o=substring(ln,nchar(s)+nchar(p)+3,nchar(ln)-2)# leave one space after >
				##Triples (assume no repeats)
				T2I=rbind(T2I,cbind(s,p,o))
			nt = nt + 1
			if(nt %% 1000 ==0)print(sprintf("Triple: %d",nt))
			if(nt%%10000==0) {
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

	print(sprintf("# Triples: %d, #unique entities: %d",nt,nrow(E2I)))
	save(file=paste(savepath , "e2i_" , name , ".RData",sep=""),E2I)
	save(file=paste(savepath , "t2i_" , name , ".RData",sep=""),T2I)

	close(con)
}

############# getnLines

getTriples<-function(fname){
	Chunk_size=500000
	con <- file(fname, "r", blocking = FALSE, encoding = "UTF-8")#108 seconds
	nl = 0
	sv=list()
	pv=list()
	ov=list()
	while(1==1){
		lnk=readLines(con, n=Chunk_size) # get one Chunk
		if(length(lnk)==0) break;
		# nl=nl+length(lnk)
		for(i in 1:length(lnk)){
			st=strsplit(lnk[i], " ")#Wrong when blank nodes
			s=st[[1]][1]#paste(st[[1]][1],'>',sep='')
			p=st[[1]][2]#paste(st[[1]][2],'>',sep='')
			o=substring(lnk[i],nchar(s)+nchar(p)+3,nchar(lnk[i])-2)
			nl=nl+1
			sv[[nl]]=s
			pv[[nl]]=p
			ov[[nl]]=o
			if(nl %% 10000==0) print(sprintf("triple: %d",nl));
			# pv=c(pv,p)
			# ov=c(ov,o)
		}
	}
	print(sprintf("number of lines:%d",nl))
	return(list(s=sv,p=pv,o=ov))
}

name="sec"
savepath="D:\\RDF\\mats\\"
t1=proc.time()
lt=getTriples(paste("D:\\RDF\\",name,".nt",sep=''))
t2=proc.time()
print(t2-t1)

trp=cbind(unlist(lt[[1]]),unlist(lt[[2]]),unlist(lt[[3]]))
rm(lt)
gc()
table(substring(unlist(trp[,3]),1,1))
flg=duplicated(paste(trp[,1],trp[,2],trp[,3],sep=''))
trp=trp[!flg,]
T2I=trp
save(file=paste("D:\\RDF\\mats\\" , "t2i_" , name , ".RData",sep=""),T2I)

# checksum
tic1=proc.time()
	Ent=table(unlist(c(trp[,1],trp[,2],trp[,3])))
	E2I=cbind(sn=1:length(Ent),cnt=Ent)
tic2=proc.time()
# t3=proc.time()
	# Ent1=rle(sort(unlist(c(trp[,1],trp[,2],trp[,3]))))
	# E1=cbind(sn=1:length(Ent1$values),cnt=Ent1$lengths)
# t4=proc.time()
# print(t4-t3)

# save(file=paste(savepath , "e2i_" , name , ".RData",sep=""),E2I)
print(sprintf("Time trp:%f, Ent:%f, total:%f",(t2-t1)[3],(tic2-tic1)[3],(tic2-t1)[3]))

###============================================
# t1=proc.time()
	# sg=table(unlist(trp[,1]))
	# pg=table(unlist(trp[,2]))
	# lg=table(unlist(trp[substring(unlist(trp[,3]),1,1)=="\"",3]))
	# oeg=table(unlist(trp[substring(unlist(trp[,3]),1,1)=="<",3]))
# t2=proc.time()
# t2-t1
### *********************************************

# name="lubm5k"
# savepath="/home/AbdelmonemAamer/shared/mats/"
# fname=paste("/home/AbdelmonemAamer/shared/kg/",name,'.nt',sep='')
name='sec'
savepath="D:\\RDF\\mats\\"
fname=paste("D:\\RDF\\",name,'.nt',sep='')
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

t3=proc.time()
	Ent1=rle(sort(unlist(c(T2I[,1],T2I[,2],T2I[,3]))))
t4=proc.time()

#### *************************************************
# parseNT2HDT

parseNT2HDT <- function(fname){
	Chunk_size=500000
	con <- file(fname, "r", blocking = FALSE)#108 seconds
	nl = 0#line(triple)
	sn = 1# Entity
	sv=list()
	pv=list()
	ov=list()
	Ent=list()
	while(1==1){
		lnk=readLines(con, n=Chunk_size) # get one Chunk
		if(length(lnk)==0) break;
		# nl=nl+length(lnk)
		for(i in 1:length(lnk)){
			st=strsplit(lnk[i], " ")
			s=st[[1]][1];#paste(st[[1]][1],'>',sep='')
			p=st[[1]][2]#paste(st[[1]][2],'>',sep='')
			o=substring(lnk[i],nchar(s)+nchar(p)+3,nchar(lnk[i])-2)
			nl = nl + 1
			##subj
			tmp = Ent[[s]]
			if(is.null(tmp)){
				Ent[[s]]=c(sn,1)
				sv[[nl]]=sn
				sn = sn + 1
			}else{ 
				Ent[[s]][2] = tmp[2] + 1
				sv[[nl]] = tmp[1]
			}
			##predicate
			tmp = Ent[[p]]
			if(is.null(tmp)){
				Ent[[p]]=c(sn,1)
				pv[[nl]]=sn
				sn = sn + 1
			}else{ 
				Ent[[p]][2] = tmp[2] + 1
				pv[[nl]] = tmp[1]
			}
			##object
			tmp = Ent[[o]]
			if(is.null(tmp)){
				Ent[[o]]=c(sn,1)
				ov[[nl]]=sn
				sn = sn + 1
			}else{ 
				Ent[[p]][2] = tmp[2] + 1
				ov[[nl]] = tmp[1]
			}
			
		}
	}
	print(sprintf("number of lines: %d",nl))
	return(list(s=sv,p=pv,o=ov,Ent=Ent))
}

name="sec"
savepath="D:\\RDF\\mats\\"
t1=proc.time()
lt=parseNT2HDT(paste("D:\\RDF\\",name,".nt",sep=''))
t2=proc.time()
print(t2-t1)

trp=cbind(unlist(lt[[1]]),unlist(lt[[2]]),unlist(lt[[3]]))
E=names(lt[['Ent']])
T2I=cbind(E[trp[,1]],E[trp[,2]],E[trp[,3]])

#  N.B: