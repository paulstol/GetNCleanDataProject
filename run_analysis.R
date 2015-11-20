tidySamsung <- function() {
     
     library(dplyr)
     library(data.table)
     library(stats)
     
     subTrainFile <- "data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt"
     xTrainFile <- "data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt"
     yTrainFile <- "data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\Y_train.txt"
     subTestFile <- "data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt"
     xTestFile <- "data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt"
     yTestFile <- "data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\Y_test.txt"
     featureFile <- "data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\features.txt"
     subjectId <- "SubjectID"
     activityId <- "ActivityID"
     
     features <- read.table(featureFile)
     labels <- as.character(features$V2)
     
     subTrain <- read.table(subTrainFile)
     xTrain <- read.table(xTrainFile, col.names = labels)
     yTrain <- read.table(yTrainFile)
     subTest <- read.table(subTestFile)
     xTest <- read.table(xTestFile, col.names = labels)
     yTest <- read.table(yTestFile)
     
     # 1. Merges the training and the test sets to create one data set.
     trainData <- cbind(subTrain, yTrain, xTrain)
     testData <- cbind(subTest, yTest, xTest)
     allData <- rbind(trainData, testData)
     
     names(allData)[1] <- subjectId
     names(allData)[2] <- activityId
     names(allData)[3:563] <- labels
     
     allData <- allData[ !duplicated(names(allData)) ]
     
     # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
     meanAndStdDevData <- select(allData, 1, 2, contains("mean()"), contains("std"), -contains("angle"))
     
     # 3. Uses descriptive activity names to name the activities in the data set
     meanAndStdDevData$ActivityID[meanAndStdDevData$ActivityID == 1] <- "WALKING"
     meanAndStdDevData$ActivityID[meanAndStdDevData$ActivityID == 2] <- "WALKING_UPSTAIRS"
     meanAndStdDevData$ActivityID[meanAndStdDevData$ActivityID == 3] <- "WALKING_DOWNSTAIRS"
     meanAndStdDevData$ActivityID[meanAndStdDevData$ActivityID == 4] <- "SITTING"
     meanAndStdDevData$ActivityID[meanAndStdDevData$ActivityID == 5] <- "STANDING"
     meanAndStdDevData$ActivityID[meanAndStdDevData$ActivityID == 6] <- "LAYING"
     
     # 4. Appropriately labels the data set with descriptive variable names.
     names(meanAndStdDevData) <- gsub(pattern="[[:punct:]]", names(meanAndStdDevData), replacement="")
     names(meanAndStdDevData) <- gsub("tBody", "TimeBody", names(meanAndStdDevData))
     names(meanAndStdDevData) <- gsub("tGravity", "TimeGravity", names(meanAndStdDevData))
     names(meanAndStdDevData) <- gsub("fBody", "FourierBody", names(meanAndStdDevData))
     names(meanAndStdDevData) <- gsub("fGravity", "FourierGravity", names(meanAndStdDevData))
     names(meanAndStdDevData) <- gsub("Acc", "Acceleration", names(meanAndStdDevData))
     names(meanAndStdDevData) <- gsub("mean", "Mean", names(meanAndStdDevData))
     names(meanAndStdDevData) <- gsub("std", "StandardDeviation", names(meanAndStdDevData))
     
     # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
     sumData <- aggregate(x = meanAndStdDevData[3:68], by = list(meanAndStdDevData$SubjectID, meanAndStdDevData$ActivityID), FUN = "mean")
     names(sumData)[1:2] <- c(subjectId, activityId)

     write.table(sumData, file = "tidySamsungData.txt", row.names = FALSE) 
}




