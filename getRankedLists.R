# 25/10/2017
getRankedLists <- function(classes, method,loadpath,savepath){
    # savepath = data_dir + "RankedLists/" 
	if (method == "HARE"){
		fname= paste(loadpath, "results_resources_dbpedia_HARE.txt",sep='')
	}		
	if( method == "PAGERANK"){
		fname= paste(loadpath, "results_dbpedia_PAGERANK.txt")
		}
         #con <- file(fname, "r", blocking = FALSE)
	 #res <- readLines(con)
	 res <- read.csv(fname,header=TRUE,stringsAsFactors=FALSE)
	 
	require(SPARQL)
	endpoint = "http://dbpedia.org/sparql"
	for (class_name in classes){
		print(class_name)
		queryString = paste("SELECT ?entity
				   WHERE {?entity a <http://dbpedia.org/ontology/" , class_name , ">}",sep="")
##############
		# query <- new("Query", world, queryString, base_uri=NULL, query_language="sparql", query_uri=NULL)
		# queryResult <- executeQuery(query, model)
			qd <- SPARQL(endpoint,queryString)
			entities <- unlist(qd$results)
			tmp=NULL#merge(entities,res,by.x=1,by.y=1)
			for(i in 1:nrow(res)){
				if(res[i,1] %in% entities)
				      tmp=rbind(tmp,res[i,])
			}
			write.csv(file=paste(savepath , class_name , "_" , method , ".txt", sep=""),tmp)
	}

}
