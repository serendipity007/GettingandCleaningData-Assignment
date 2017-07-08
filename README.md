# GettingandCleaningData-Assignment
A wide, tidy dataset for Human Activity Recognition Using Smartphones was produced doing the following:
1. The files were downloaded from the website.
2. The training and the test sets to create one data set.
3. Only the measurements on the mean and standard deviation for each measurement were utilized in the final dataset.
4. The activities in the data set were named with descriptive activity labels, descriptive variable names were provided as appropriate.
5. From the data set in step 4, an independent wide tidy data set with the average of each variable for each activity and each subject.

The output dataset can be found in the tidy.txt file, which can be read into R with :
fileLoc <- "http://github.com/serendipity007/GettingandCleaningData-Assignment/blob/master/tidy.txt")
read.table(url(fileLoc), header = TRUE)




Additional detailed descriptions of the variables can be found in CodeBook.md. 
