## ---------------------------------------------------------------------------------
## Getting and Cleaning Data
## Week 4 Project
## Cara Hubbell
## January 2016
## ---------------------------------------------------------------------------------

## First we will require needed packages and get our data.

print("Installing and loading required packages", quote=FALSE)
sapply(c("dplyr","data.table"), require, character.only=TRUE)

print("Downloading data", quote=FALSE)
if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

pathdata <- file.path("./data" , "UCI HAR Dataset")

## ---------------------------------------------------------------------------------
## 1. Merge the training and the test sets to create one data set.

print("Merging data files", quote=FALSE)
ActivityTrain <- read.table(file.path(pathdata, "train", "Y_train.txt"),header = FALSE)
ActivityTest  <- read.table(file.path(pathdata, "test" , "Y_test.txt" ),header = FALSE)
ActivityData <- rbind(ActivityTrain,ActivityTest)
names(ActivityData)<- c("activity")

SubjectTrain <- read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(pathdata, "test" , "subject_test.txt"),header = FALSE)
SubjectData <- rbind(SubjectTrain, SubjectTest)
names(SubjectData)<-c("subject")

FeaturesTrain <- read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(pathdata, "test" , "X_test.txt" ),header = FALSE)
FeaturesData <- rbind(FeaturesTrain,FeaturesTest)
FeaturesNames <- read.table(file.path(pathdata, "features.txt"),head=FALSE)
names(FeaturesData)<- FeaturesNames$V2

Data <- cbind(cbind(SubjectData,ActivityData),FeaturesData)

## ---------------------------------------------------------------------------------
## 2. Extract only the measurements on the mean and standard deviation for each 
##    measurement.

print("Extracting relevant data", quote=FALSE)
Data <- Data[,grep("-mean\\(\\)|-std\\(\\)", FeaturesNames[,2])]

## ---------------------------------------------------------------------------------
## 3. Use descriptive activity names to name the activities in the data set.

ActivityNames <- fread(file.path(pathdata, "activity_labels.txt"))
setnames(ActivityNames, names(ActivityNames), c("activity", "activityName"))

## ---------------------------------------------------------------------------------
## 4. Appropriately label the data set with descriptive variable names.

print("Renaming variables", quote=FALSE)
Data <- merge(y = Data, x = ActivityNames, by = "activity")
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("activity","ActivityNumber", names(Data))
names(Data)<-gsub("ActivityNumberName","ActivityName", names(Data))

## ---------------------------------------------------------------------------------
## 5. From the data set in step 4, create a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

print("Creating tidy data file", quote=FALSE)
Data2 <- aggregate(. ~subject + ActivityName, Data, mean)
Data2 <- Data2[order(Data2$subject,Data2$ActivityNumber),]
write.table(Data2, file = "./data/tidydata.txt",row.name=FALSE)
View(read.table("./data/tidydata.txt"))

## ---------------------------------------------------------------------------------

