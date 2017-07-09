setwd("~/R")
library(dplyr)
# 
# This section is about creating data directory. 
# Next step is to download file and unzip data
# As program maybe run mutiple times, there are a few checks to prevent repeat downloads and unzipping
#
if(!file.exists("~/R/data")){dir.create("~/R/data")}
fileurl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "~/R/Data/data.zip"
path <- "~/R/data/UCI HAR Dataset"

if (!file.exists(zipFile)){
  download.file(fileurl,destfile = zipFile, method = "curl")
  if(!file.exists(path)){
    unzip(zipFile, exdir = "~/R/data")
  }
}

#-----------------------------------------------------------------------
# This section deals with the following :
# ****Merges the training and the test sets to create one data set.*****
#-----------------------------------------------------------------------

train_x <- read.table(paste(path, "/train/", "X_Train.txt", sep=""))
test_x <- read.table(paste(path, "/test/", "X_test.txt", sep=""))
train_y <- read.table(paste(path, "/train/", "Y_Train.txt", sep=""))
test_y <- read.table(paste(path, "/test/", "Y_test.txt", sep=""))
subject_train <- read.table(paste(path, "/train/", "subject_train.txt", sep=""))
subject_test <- read.table(paste(path, "/test/", "subject_test.txt", sep=""))


mergedX_int <- rbind(train_x, test_x)
mergedY <- rbind(train_y, test_y)
mergedSubject = rbind(subject_train, subject_test)



#-------------------------------------------------------------------------------------
# This section deals with the following :
# *** Extracts only the measurements on the mean and standard deviation for each measurement.***
# *** Appropriately labels the data set with descriptive variable names.*****
# ---------------------------------------------------------------------------------------

features <- read.table(paste(path, "/features.TXT", sep=""), as.is= TRUE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])
features[,2] <- gsub("BodyBody", "Body", features[,2])
names(mergedX_int) <- features[,2]
namestoKeep <- grep("Mean|Std", names(mergedX_int))
mergedX <- mergedX_int[, namestoKeep]


#-------------------------------------------------------------------------------------
# This section deals with the following :
# *** Uses descriptive activity names to name the activities in the data set***
#---------------------------------------------------------------------------------------

activitiesLabels <- read.table(paste(path, "/activity_labels.txt", sep=""), as.is= TRUE)
mergedY$V1 <- activitiesLabels[match(mergedY$V1, activitiesLabels$V1), 2]
names(mergedY) <- c("activity")
names(mergedSubject) <- c("subject")


#-------------------------------------------------------------------------------------
# This section deals with the following :
# Create Merged dataset with descriptive variable names
#---------------------------------------------------------------------------------------



final <- cbind(mergedSubject, mergedY, mergedX)
final$subject <- as.factor(final$subject)
final$activity <- as.factor(final$activity)


#-------------------------------------------------------------------------------------
# This section deals with the following :
# Create Merged dataset with descriptive variable names
# From the merged data set, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
#---------------------------------------------------------------------------------------

tidy <- final %>% group_by(subject, activity) %>% summarise_all(mean)
## capture.output( print(tidy, print.gap=3), file="tidy.txt")
write.table(tidy, file = "tidy.txt", sep = "\t\t", quote = FALSE, row.names = FALSE)

# check
tidyData <- read.table("tidy.txt", header = TRUE)
