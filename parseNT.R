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
	while(1==1){
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
