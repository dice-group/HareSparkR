#15/10/2017################################################
#parseRDF.R
#parses RDF files in Turtle (.ttl) format and in N triples (.nt) format.
# maintains a dictionary of unique Entities and counts and dictionary of 
#   triples and serial.
# data structure: a named vector
#Saves Triples list and Entities List
#	List of Entities: E2I dict:key s,p,o, [serial,cnt]
#	List of Triples : T2I dict:key t[s,p,o],serial

# This function is inspired by function parseRDF.py in HARE project
function parseRDF(name){
# Parameters:
#   name: file name with ext .nt or .ttl

# Output
#	 e2i|name.RData containing list of entities and their counts 
#	 t2i|name.RData list of triples and serial
	
# saving results
	if (substring(name,nchar(name)-4)==".ttl")  name = substring(name,1,nchar(name)-4)
	if (substring(name,nchar(name)-3)==".nt")  name = substring(name,1,nchar(name)-3)
	
	E2I dict:key s,p,o, cnt
	T2I dict:key [s,p,o],serial:how can it be repeated?????
	
	
	
	paste(savepath , "e2i_" , name , ".RData")
	pickle.dump(T2I, open(savepath + "t2i_" + name + ".pkl", "wb"))

}

