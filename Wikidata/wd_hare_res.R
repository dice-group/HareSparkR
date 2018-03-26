
name="wd022018"
	savepath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"
	loadpath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"
ni=9
hd_sz=10000

	print('Saving results...')
	print(load(paste0(savepath,"Sn_",name,"_",ni,".RData")))#previous
	#Ent, Ent_cnt,prob. sorted by prob.
	##load Ent
	print(load(paste0(loadpath,name,"_E_cnt.RData")))
	E_cnt=E_cnt[-1]
	con <- file(paste(loadpath,name,"_Ent.txt",sep=''), "r", blocking = FALSE)
	Ent = readLines(con)
	close(con)
	Ent=Ent[-1]
	
	print(paste0("Sorting...",format(Sys.time(), "%a %b %d %X %Y")))
	Sn_order=order(previous,decreasing=TRUE)
    print(paste0("hd_order...",format(Sys.time(), "%a %b %d %X %Y")))
	hd_order=Sn_order[1:hd_sz]
	tmp_hd=cbind(Entity=Ent[hd_order],count=E_cnt[hd_order],Probability=as.vector(previous)[hd_order])
	print(paste0("Saving head:",hd_sz," ",format(Sys.time(), "%a %b %d %X %Y")))
	write.csv(file=paste(savepath , "results_resources_" , name , "_HARE_hd.csv",sep=''),tmp_hd,row.names=FALSE)
	print(paste0("cbind...",format(Sys.time(), "%a %b %d %X %Y")))
	tmp=cbind(Entity=Ent,count=E_cnt,Probability=as.vector(previous))[Sn_order,]		
	write.csv(file=paste(savepath , "results_resources_" , name , "_HARE.txt",sep=''),tmp,row.names=FALSE)
