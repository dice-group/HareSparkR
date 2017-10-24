#15/10/2017################################################
#parseRDF.R
#parses RDF files in Turtle (.ttl) format and in N triples (.nt) format.
# maintains a dictionary of unique Entities and counts and dictionary of 
#   triples and serial.
# data structure: a named vector
#Saves Triples list and Entities List
#	List of Entities: E2I dict:key s,p,o, cnt
#	List of Triples : T2I dict:key t[s,p,o],serial

# This function is inspired by function parseRDF.py in HARE project
 parseRDF <- function(name,loadpath,savepath){
# Parameters:
#   name: file name with ext .nt or .ttl

# Output
#	 e2i|name.RData containing list of entities and their counts 
#	 t2i|name.RData list of triples and serial
	
# saving results
	if (substring(name,nchar(name)-3)==".xml")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-2)==".nt")  name = substring(name,1,nchar(name)-3)
	# loadpath = paste(data_dir , "KnowledgeBases\\",sep="")
    # savepath = paste(data_dir , "Matrices\\",sep="")

	# E2I dict:key s,p,o, cnt
	# T2I dict:key [s,p,o],serial:how can it be repeated?????
	
	require(redland)
	world <- new("World")
	storage <- new("Storage", world, "hashes", name="", options="hash-type='memory'")
	model <- new("Model", world=world, storage, options="")
	parser <- new("Parser", world)
	parseFileIntoModel(parser, world, paste(loadpath,name,sep=""), model)
	###
	queryString <-"select ?s ?p ?o where {?s ?p ?o.}"
	query <- new("Query", world, queryString, base_uri=NULL, query_language="sparql", query_uri=NULL)
	queryResult <- executeQuery(query, model)
	sn=1 #serial for entities
	j=1 #serial for  triples
	E2I=list()
	T2I=NULL
	while(!is.null(result <- getNextResult(queryResult))){
		for(k in result){
			tmp = E2I[[k]]
			if(is.null(tmp)){
				E2I[[k]]=c(sn,1)
				sn = sn + 1
			}else{ 
				E2I[[k]][2] = tmp[2] + 1
			}
		}
		##Triples (assume no repeats)
		T2I=rbind(T2I,result)
		j = j + 1
		if(j%%100==0) print(sprintf("Triple: %d",j))
	}
	
	save(file=paste(savepath , "e2i_" , name , ".RData",sep=""),E2I)
	save(file=paste(savepath , "t2i_" , name , ".RData",sep=""),T2I)
}

#Packages: SPARQL,egonw (jena),redland,feedeR (parse.rdf)