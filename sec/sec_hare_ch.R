
sec_ch
sec_FW.R
sec_FW20.R
wd_FW40p2.R
sec_FW105p1.R
sec_FW105p2.R
sec_calc_P_T.R
sec_hare.R

####### One Chunk ==============
test_parseNTJ

### Using HARE and getTransitionMatrices without chunks: works fine
parseNT.R getTriples
test_parseRDF
##diff entities, was due to Encoding
	loadpath="D:\\RDF\\parseNT\\"
con <- file(paste(loadpath,name,"_Ent.txt",sep=''), "r", blocking = FALSE)
Ent = readLines(con)
close(con)

matpath='D:\\RDF\\mats\\'
tic2=proc.time()
getTransitionMatrices(fname,loadpath=matpath,savepath=matpath)
tac2=proc.time()
print(tac2-tic2)

runtime = hare(fname,loadpath=matpath,savepath=matpath, epsilon=10^-3, damping = .85, saveresults=TRUE, printerror=TRUE, printruntimes=TRUE)