#testing getRankedLists
source('C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\HareSparkR\\getRankedLists.R')
loadpath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\Results\\'
savepath='C:\\Users\\Abdelmonem\\Dropbox\\HARE\\HareSparkR\\Data\\RankedLists\\'

classes = c("City", "University", "VideoGame", "SpaceStation", "Mountain", "Hotel",
	            "EurovisionSongContestEntry", "Drug", "Comedian", "ChessPlayer",
	            "Band", "Album", "Person", "Automobile", "HistoricPlace", "Town",	
	            "MilitaryConflict", "ProgrammingLanguage", "Country")

for (method in c('HARE','PAGERANK')){
	getRankedLists(classes,method,loadpath,savepath)
}
	