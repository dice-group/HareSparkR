# 25/10/2017
getRankedLists <- function(classes, method,loadpath,savepath){
    # savepath = data_dir + "RankedLists/" 
	if (method == "HARE"){
		fname= paste(loadpath, "results_resources_dbpedia_HARE.txt",sep='')
	}		
	if( method == "PAGERANK"){
		fname= paste(loadpath, "results_dbpedia_PAGERANK.txt")
		}
     
	 readLines(con)
	 
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
			entities <- qd$results

		# entities = NULL
		# while(!is.null(result <- getNextResult(queryResult))){
					# print(result)
					# entities = c(entities,result)
			# }
			write.csv(file=paste(savepath , class_name , "_" , method , ".txt", sep=""),entities)
	}

}