
	name="sec"
	savepath="D:\\RDF\\mats\\"
	loadpath="D:\\RDF\\parseNT\\"
	# name="wd022018"
	# savepath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"
	# loadpath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"

# read Pch_all
	Alpha <- 866611
	tch_sz = c(20000,20000,rep(40000,5),240000,240000,146611)
	PTch_all = list()
	NChnks = length(tch_sz)
	mem = 0;
	t0=proc.time()
	for(t_ch in 1:NChnks){
		t1=proc.time()
		print(load(paste0(savepath,"PTch_",name,"_",t_ch,".RData")))
		PTch_all[[t_ch]] = PTch;
		mem = mem + object.size(PTch)
		t2=proc.time()
		print(sprintf("ch:%d, total mem:%.1f, time%.1f",t_ch,mem/(1024*1024),(t2-t1)[3]))
	}
	# load_PTch  10m,110GB
	t2=proc.time()
	print(sprintf("total load time:%.1f",(t2-t0)[3]))
	##-------------------
	## ncores=1
	require(parallel)
	require(doParallel)
	cluster <- makeCluster(3)
	registerDoParallel(cluster)

	epsilon=1e-3; damping=0.85; maxIterations=12;
	n=Alpha
	previous = ones = rep(1,n)/n
	d_ones = (1-damping)*ones
	error = 1
	 #Equation 9
	tic2 = proc.time()
	ni=0	
	ch_st_ix=tch_sz
	ch_st_ix[1]=1
	for(i in 2:NChnks) ch_st_ix[i] = tch_sz[i-1] + ch_st_ix[i-1];
	print("Calculating HARE...")
	# library(Matrix)
	# require(snowfall)
	# sfInit(parallel=TRUE, cpus = 3) # logical CPU’s  minus one
	# R Version:  R version 3.1.2 (2014-10-31)
	# sfExport("previous")
	# sfExport("PTch_all")
	# sfExport("d_ones")
	# sfExport("ch_st_ix")
	# sfExport("tch_sz")

	get_chunk_hare <- function(t_ch){
		    # print(t_ch)
			t1=proc.time()
			damping=0.85
			prv = damping *(PTch_all[[t_ch]] %*% tmp) #+ d_ones[ch_rng]
			t2=proc.time()
			# print(sprintf("ni:%d, ch:%d, time:%.1f",ni,t_ch,(t2-t1)[3]))
			return(prv)
	}
	tmp2=NULL
	while (error > epsilon && ni < maxIterations){
		ni = ni + 1
		tmp = previous
			# sfExport("tmp")
		t1=proc.time()
		tmp2 <- foreach(i = 1:NChnks,.packages='Matrix', .combine="c") %dopar% 
				get_chunk_hare(i);
		t2=proc.time()
		for(t_ch in 1:length(tmp2)){
			ch_rng=ch_st_ix[t_ch]:(ch_st_ix[t_ch]+tch_sz[t_ch]-1)
			previous[ch_rng]=tmp2[[t_ch]]+ d_ones[ch_rng]
		}
		t3=proc.time()
		# system.time(tmp2 <- sfLapply(1:NChnks, get_chunk_hare,.packages='Matrix'))
		error = norm(as.matrix(tmp - previous),"f")
		
		print(sprintf("ni:%d,max index:%d,max:%f,sumSn:%f,error:%f, %.3f",ni,which.max(as.vector(previous)),max(previous),sum(previous),error,(t3-t1)[3]));
		# print(error)
	}
	tac2 = proc.time()
	print(paste0("Hare time:" , (tac2-tic2)[3]));
	stopCluster(cluster)
	# sfStop()


	##Save results
	
	
	system.time(
  result_dopar <- foreach(i = 0:9, .combine = "rbind") %dopar%
    get_column_means_from_file(i)
)
