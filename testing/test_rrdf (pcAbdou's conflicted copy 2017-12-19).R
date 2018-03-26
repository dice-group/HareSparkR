library(rrdf)
# store = new.rdf()
# tripleCount(store)

options(java.parameters = "-Xmx2048m")
library(rJava)
# .jinit(parameters="-Xmx3g")

library(rrdf)
# fname='/home/abdelmoneim/Dropbox/HARE/HareSparkR/Data/KnowledgeBases/airports.nt'
fname='/home/abdelmoneim/Hare/datasets/airports.nt'
# fname='/home/abdelmoneim/Hare/datasets/sider.nt'
# fname='/home/abdelmoneim/Hare/datasets/dogfood.nt'
# fname='/home/abdelmoneim/Hare/datasets/sec.nt'
model=load.rdf(fname,"N-TRIPLES")
tripleCount(model)

# returns data frame containing result
tic=proc.time()
trp=sparql.rdf(model, "SELECT ?s ?p ?o{ ?s ?p ?o }")
tac=proc.time()
print(tac-tic)
dim(trp)

Ent=table(c(trp[,1],trp[,2],trp[,3]))
length(Ent)
E2=cbind(sn=1:length(Ent),cnt=Ent)



library(rrdf)
m1 = load.rdf("one.rdf")
m2 = load.rdf("two.rdf")
m3 = combine.rdf(m1, m2)
summarize.rdf(m3)
sparql.rdf(m3, "SELECT ?s ?p { ?s ?p ?o }")
## get number of entities

# java.lang.OutOfMemoryError: GC overhead limit exceeded

# =============================On cluster============================
options(java.parameters = "-Xmx96g")
library(rJava)
.jinit(parameters="-Xmx96g")

library(rrdf)

# fname='/data/home/AbdelmonemAamer/datasets/datasets/sec.nt'
# fname='/data/home/AbdelmonemAamer/datasets/datasets/uspto2015.nt'
name='lubm200fix'
fname='/data/home/AbdelmonemAamer/datasets/datasets/lubm200fix.nt'
model=load.rdf(fname,"N-TRIPLES")
tripleCount(model)

# returns data frame containing result
tic=proc.time()
trp=sparql.rdf(model, "SELECT ?s ?p ?o{ ?s ?p ?o }")
tac=proc.time()
print(tac-tic)
dim(trp)

T2I=trp
savepath='/data/home/AbdelmonemAamer/datasets/datasets/mat/mats/'
	save(file=paste(savepath , "t2i_" , name , ".RData",sep=""),T2I)
t2=proc.time()
Ent=table(unlist(c(T2I[,1],T2I[,2],T2I[,3])))
	E2I=cbind(sn=1:length(Ent),cnt=Ent)

	# print(sprintf("# Triples: %d, #unique entities: %d, # escaped triples: %d",j-1,nrow(E2I),nerr))
save(file=paste(savepath , "e2i_" , name , ".RData",sep=""),E2I)
t3=proc.time()





	java.lang.OutOfMemoryError: Java heap space
