setwd("F:/Coursera/Getting and Cleaning Data/Week4/Week 4 Assignment")
library(dplyr)

## Download Zip File

MyFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(MyFileUrl,destfile="./DataFiles.zip")

## Unzip and set file path

unzip(zipfile="./DataFiles.zip")

## Read Activity Labels and Features Files

ActivityLabels        <- read.table("./UCI HAR Dataset/activity_labels.txt") 
ActivityLabels[,2]    <- as.character(ActivityLabels[,2])
names(ActivityLabels) <- c("Activity", "ActivityDescription")

Features           <- read.table("./UCI HAR Dataset/features.txt") 
Features[,2]       <- as.character(Features[,2]) 

## Read Activity Files

ActivityDataTest  <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE)
ActivityDataTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE)

## Read the Subject Files

SubjectDataTest  <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
SubjectDataTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## Read Features Files

FeaturesDataTest  <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
FeaturesDataTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

## Combine Train and Test Data

ActivityData <- rbind(ActivityDataTrain, ActivityDataTest)
SubjectData  <- rbind(SubjectDataTrain, SubjectDataTest)
FeaturesData <- rbind(FeaturesDataTrain, FeaturesDataTest)

## Add Names to Data Sets

names(ActivityData) <- c("Activity")
names(SubjectData)  <- c("Subject")
names(FeaturesData) <- Features$V2

## Add Activity Labels to Activity Data

ActivityDataWithLabels <- ActivityData %>%
                                inner_join(ActivityLabels, key = "Activity") %>%
                                select(ActivityDescription) %>%
                                rename(Activity = ActivityDescription)


## Only Look at mean() and std() Features Columns

SubsetFeatures        <- grep("mean\\(\\)|std\\(\\)", Features[,2])
SubsetFeaturesColumns <- Features[SubsetFeatures,2]
SubsetFeaturesData    <- subset(FeaturesData, select = SubsetFeaturesColumns)

## Combine All Data Sets

CombinedData <- cbind(SubsetFeaturesData, SubjectData, ActivityDataWithLabels)

## Clean Up Column Names

names(CombinedData) <- gsub('-mean', 'Mean', names(CombinedData)) 
names(CombinedData) <- gsub('-std', 'Std', names(CombinedData)) 
names(CombinedData) <- gsub('[-()]', '', names(CombinedData)) 

## Create Tidy Data Summary and Write to Text File 

CombinedTidy <- CombinedData %>%
        group_by(Subject, Activity) %>%
        summarize_each(funs(mean))

write.table(CombinedTidy, file = "tidydata.txt",row.name=FALSE)





