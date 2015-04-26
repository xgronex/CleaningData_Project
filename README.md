# CleaningData_Project
The code begins by defining the paths to the different raw data files.
It then proceeds to read the raw data from both test and train data sets. In both cases (test and train), the data is split across three files (x,y,subject), we thus read the files and then column bind the data together into a single data set.
The two resulting data sets are then row binded to form a single data set containing both test and train data as requested.
This data set is then subsetted to keep only the measures having to do with std and mean, plus the subject and activity_code columns. 
The measure columns are named based on the info contained in features.txt file.
The activity code column is then converted to its actual activity name by joining against the activity labels data set.
Finally the data is melted to form a data set with four columns subject, activity, variable and value, which is then summarized to get the average value of each (subject, activity, variable) combination.
