# 18/3/2018
NOT USED ANY MORE
name="wd022018"
# name="sec"
# savepath="D:\\RDF\\mats\\"
savepath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"
# loadpath="D:\\RDF\\parseNT\\"
loadpath="/upb/departments/pc2/scratch/desouki/ParseNT/wd/"

#print(load(paste0(savepath,"P_",name,"_",20,".RData")))
print("Adding blocks of FW40...")
library(Matrix)
pe_sz=100000000  #Work around the limit of max nnz(2^31)
for(t_ch in seq(40,80,40)){#trp chnk
	t1=proc.time()
	print(t_ch)
	print(load(paste0(savepath,"P_",name,"_",t_ch-30,"_",t_ch-20,".RData")))
	P_ch1=P
	p2_sz=nrow(P)-p1_sz
	rm(P)
	gc()
	print(load(paste0(savepath,"P_",name,"_",t_ch-10,"_",t_ch,".RData")))
	print(sprintf("Chunk:t_ch:%d, memP:%.1f, memP_ch1:%.1f,nnzP:%d,nnzP_ch1:%d",t_ch, object.size(P)/(1024*1024), object.size(P_ch1)/(1024*1024),
	  length(P@x),length(P_ch1@x)))
	  
	for(e_ch in 1:ceiling(nrow(P)/pe_sz)){
		t2 = proc.time()
		index_st = 1 + (e_ch -1)*pe_sz
		index_end= min(e_ch *pe_sz, nrow(P) )
		print(sprintf("Chunk:e_ch:%d, index_st:%d,index_end:%d",index_st,index_end))
		P1 = P[index_st:index_end,] + P_ch1[index_st:index_end,]
		print(sprintf("Saving P1, nnz:%d, memP1:%.1f,P_ch1 nnz:%d, memPch1:%.1f ...",length(P1@x), object.size(P1)/(1024*1024),length(P_ch1@x), 
			  object.size(P_ch1)/(1024*1024)))
		save(file=paste0(savepath,"P",e_ch,"_",name,"_",t_ch-30,"_",t_ch,".RData"),P1)
		t3 = proc.time()
		print(sprintf("Chunk:e_ch:%d, time total:%.3f, time itr:%.3f, ,memP1:%.1f, nnz:%d",e_ch,(t3-t1)[3],
				(t3-t2)[3],object.size(P1)/(1024*1024), length(P1@x)))
		rm(P1)
		gc()
	}
		# P2 = P[(p1_sz+1):p2_sz,] + P_ch1[(p1_sz+1):p2_sz,]
	# t4 = proc.time()
	# print("Saving P2 ...")
	# save(file=paste0(savepath,"P2_",name,"_",t_ch-10,"_",t_ch,".RData"),P2)
	# t5=proc.time()
	# print(sprintf("Chunk:%d, time total:%.3f, time load:%.3f, time FW:%.3f, time P:%.3f,memP2:%.1f,memP:%.1f, memP_ch1:%.1f,nnz:%d",ch,(t5-t1)[3],
		# (t2-t1)[3],(t3-t2)[3],(t4-t3)[3],object.size(P2)/(1024*1024), object.size(P)/(1024*1024), object.size(P_ch1)/(1024*1024),length(P2@x)))
	rm(P)
	rm(P_ch1)
	gc()
}

#######
print("ch: 81 to 105")
print(load(paste0(savepath,"P_",name,"_",90,"_",100,".RData")))
	P_ch1=P
	p2_sz=nrow(P)-p1_sz
	rm(P)
	gc()
	
	print(load(paste0(savepath,"P_",name,"_",105,".RData")))
	t2=proc.time()
	# P = P + FW
	P1 = P[1:p1_sz,] + FW[1:p1_sz,]
	print(sprintf("Saving P1, nnz:%d, memP1:%.1f ...",length(P1@x), object.size(P2)/(1024*1024)))
	save(file=paste0(savepath,"P1_",name,"_",90,"_",105,".RData"),P1)
	rm(P1)
	gc()
	
	t3=proc.time()
	P2 = P[(p1_sz+1):p2_sz,] + FW[(p1_sz+1):p2_sz,]
	t4 = proc.time()
	print("Saving P2 ...")
	save(file=paste0(savepath,"P2_",name,"_",90,"_",105,".RData"),P2)
	t5=proc.time()
print(sprintf("Chunk:%d, time total:%.3f, time load:%.3f, time FW:%.3f, time P:%.3f,memFW:%.1f,memP2:%.1f",ch,(t4-t1)[3],(t2-t1)[3],(t3-t2)[3],
				(t4-t3)[3],object.size(FW)/(1024*1024), object.size(P2)/(1024*1024)))
	