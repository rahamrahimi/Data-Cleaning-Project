#Data Cleaning Project Script

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="HAR.zip")
unzip(zipfile="HAR.zip")

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./UCI HAR Dataset/features.txt')

activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activityLabels) <- c('activityId','activityType')

Merge_train <- cbind(y_train, subject_train, x_train)
Merge_test <- cbind(y_test, subject_test, x_test)
All_Merged <- rbind(Merge_train, Merge_test)

colNames <- colnames(All_Merged)
mean_and_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )
DataMeanAndStd <- All_Merged[ , mean_and_std == TRUE]
DataWithActivityNames <- merge(DataMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
DataTidySet <- aggregate(. ~subjectId + activityId, DataWithActivityNames, mean)
DataTidySet <- DataTidySet[order(DataTidySet$subjectId, DataTidySet$activityId),]
write.table(DataTidySet, "DataTidySet.txt", row.name=FALSE)