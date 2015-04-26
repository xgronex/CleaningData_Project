##install.packages(reshape2)
##install.packages("dplyr")
##install.packages("Rcpp")
library(reshape2)
library(dplyr)
library(plyr)

## Paths here
base_dir <- "UCI HAR Dataset\\"
subject_test_path <- paste(base_dir,"test\\subject_test.txt",sep="")
y_test_path <- paste(base_dir,"test\\y_test.txt",sep="")
x_test_path <- paste(base_dir,"test\\X_test.txt",sep="")
subject_train_path <- paste(base_dir,"train\\subject_train.txt",sep="")
y_train_path <- paste(base_dir,"train\\y_train.txt",sep="")
x_train_path <- paste(base_dir,"train\\X_train.txt",sep="")
features_path <- paste(base_dir,"features.txt",sep="")
activity_labels_path <- paste(base_dir,"activity_labels.txt",sep="")
result_path <- "result.txt"

## Read raw data
subject_test <- read.table(file=subject_test_path)
y_test <- read.table(file=y_test_path)
x_test <- read.table(file=x_test_path)
all_test <- cbind(subject_test,y_test,x_test)

subject_train <- read.table(file=subject_train_path)
y_train <- read.table(file=y_train_path)
x_train <- read.table(file=x_train_path)
all_train <- cbind(subject_train,y_train,x_train)

all_data <- rbind(all_train,all_test)

## Pick only subject (1), activity (2), plus std and mean features
all_features <- read.table(file=features_path,col.names=c("index","feature"))
req_features <- all_features[grepl("mean()|std()",all_features$feature),]
all_data_filtered <- all_data[,c(1,2,req_features$index+2)]

## Name columns
feature_names <- as.character(req_features$feature)
names(all_data_filtered) <- c("subject","activity_code",feature_names)

## Join against activity labels to get meaningful names
all_activities <- read.table(file=activity_labels_path,col.names=c("activity_code","activity"))

final1 <- merge(all_data_filtered, all_activities, by.x="activity_code", by.y="activity_code", all=TRUE)[, c("subject","activity", feature_names)]

## Summarize
melted <- melt(final1,id=c("subject","activity"),measure.vars=feature_names)
final2 <- ddply(melted,.(subject,activity,variable), summarize, avg=mean(value))

## Write to file
write.table(final2, result_path, row.names=FALSE)

