	## py to R
	library(RcppCNPy)
	setwd()
	# for(ds in c('Airports','SIDER',))
		F=npyLoad("D:\\RDF\\mats\\py\\Airports\\F.npz")
		
	
	rapper -g airports.nt -o json  >airports.json
	library(jsonlite)
	df1 <- jsonlite::fromJSON("D:\\RDF\\mats\\py\\Airports.json", simplifyDataFrame = TRUE, flatten = TRUE)
 # pupil_data_to_csv.py
# coding=utf-8

import pickle
import numpy as np
import sys

# open the pickled file
# replace with your path to pupil_data
# if sys.version_info >= (3, 0):
	# pupil_data = pickle.load(open("/Users/wrp/recordings/2016_01_28/001/pupil_data","rb"),encoding='latin1') 
# else:
pupil_data = pickle.load(open("D:\\RDF\\mats\\py\\t2i_example.pkl","rb")) 


# pupil_data will be unpickled as a dictionary with three main keys
#'pupil_positions', 'gaze_positions', 'notifications'
# here we are interested in pupil_positions
pupil_positions = pupil_data['pupil_positions'] 

# uncomment the below line to see what keys are in a pupil_positions list item
pupil_positions[0].keys() 

# to export pupil diameter in millimeters to a .csv file with timestamps frame numbers and timestamps
# as correlated columns  you can do the following:

header = ['timestamp','diameter','confidence','diameter_3D','modelConfidence']
header_str = ','.join(header)
filtered_pupil_positions = []
for i in pupil_positions:
	filtered_pupil_positions.append([i[v] for v in header])
 
np.savetxt("/Users/wrp/Desktop/pupil_data.csv",filtered_pupil_positions,delimiter=",",header=header_str,comments="")
 