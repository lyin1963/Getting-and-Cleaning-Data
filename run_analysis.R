# Merges the training and the test sets to create one data set.
library(plyr)
SubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
TrainDataset <- cbind(SubjectTrain, YTrain, XTrain)
str(TrainDataset)

SubjextTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
TestDataset <- cbind(SubjextTest, YTest, XTest)
str(TestDataset)

Dataset_temp <- rbind(TrainDataset, TestDataset)
str(Dataset_temp)

# Adding header
Features <- read.table("./UCI HAR Dataset/features.txt", sep =" ")
str(Features)
colnames(Dataset_temp)[1:2] <- c("ID", "Type") 
str(Dataset_temp)
Dataset_temp_1<- Dataset_temp[3:563]
str(Dataset_temp_1)
colnames(Dataset_temp_1) <- Features[,2]
str(Dataset_temp_1)

# Extracts the mean and standard deviation from the dataset
MeanAndSD <- grep("-mean\\(\\)|-std\\(\\)", Features[, 2])
str(MeanAndSD)
DatasetwihtMeanAndSD <- Dataset_temp_1[, MeanAndSD]
str(DatasetwihtMeanAndSD)
HDataset <- cbind(Dataset_temp[, 1:2],DatasetwihtMeanAndSD)
str(HDataset)


# Uses descriptive activity name in the data set
names(HDataset) <- gsub("\\(|\\)", "", names(HDataset))
str(HDataset)
activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
activities[, 2] <- gsub("_", "", activities[, 2])
str(activities)

HDataset[, 2] = activities[HDataset[, 2], 2]
str(HDataset)

names(HDataset)<-gsub("^t", "time", names(HDataset))
names(HDataset)<-gsub("^f", "frequency", names(HDataset))
names(HDataset)<-gsub("Acc", "Accelerometer", names(HDataset))
names(HDataset)<-gsub("Gyro", "Gyroscope", names(HDataset))
names(HDataset)<-gsub("Mag", "Magnitude", names(HDataset))
names(HDataset)<-gsub("BodyBody", "Body", names(HDataset))
str(HDataset)

# Saving the dataset to the text file
write.table(HDataset, "merged.txt", row.name=FALSE )

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
HDataset2<-aggregate(. ~ID + Type, HDataset, mean)
str(HDataset2)
HDataset2<-HDataset2[order(HDataset2$ID,HDataset2$Type),]
str(HDataset2)
write.table(HDataset, "SecondData.txt", row.name=FALSE )
