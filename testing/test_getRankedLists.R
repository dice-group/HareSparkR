#testing getRankedLists
setwd('C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\')
source('HareSparkR/getRankedLists.R')
loadpath='Data/Results/'
savepath='Data/RankedLists/'

classes = c("City", "University", "VideoGame", "SpaceStation", "Mountain", "Hotel",
	            "EurovisionSongContestEntry", "Drug", "Comedian", "ChessPlayer",
	            "Band", "Album", "Person", "Automobile", "HistoricPlace", "Town",	
	            "MilitaryConflict", "ProgrammingLanguage", "Country")
				
# classes = c("City", "University", "VideoGame")
for (method in c('HARE','PAGERANK')){
	getRankedLists(classes,method,loadpath,savepath)
}
	
#################
