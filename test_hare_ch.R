	# name="sec"
	# savepath="D:\\RDF\\mats\\"
	# loadpath="D:\\RDF\\parseNT\\"
	name="wd022018"
	savepath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"
	loadpath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"

# read PTch_all
	Alpha <- 479414243
	tch_sz = c(10000000,10000000,rep(20000000,5),120000000,120000000,119414243)
	PTch_all = list()
	NChnks = 10
	mem = 0;
	t0=proc.time()
	for(t_ch in 1:NChnks){
		t1=proc.time()
		print(load(paste0(savepath,"PTch_",name,"_",t_ch,".RData")))
		PTch_all[[t_ch]]=PTch;
		mem=mem+object.size(PTch)
		t2=proc.time()
		print(sprintf("ch:%d, total mem:%.1f, time%.1f",t_ch,mem/(1024*1024),(t2-t1)[3]))
	}
	print(sprintf("ch:%d, total load time%.1f",(t2-t0)[3]))
	##-------------------
	## ncores=1
	# foreach()
	
	
	