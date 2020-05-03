#Read the Activity files
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
#read the subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
#Read Fearures files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
#check at the properties of the above varibles
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)
#Concatenate the tables by rows
dSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dActivity<- rbind(dataActivityTrain, dataActivityTest)
dFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
#set names to the variables
names(dSubject)<-c("subject")
names(dActivity)<- c("activity")
dFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dFeatures)<- dFeaturesNames$V2
#Merge columns to get the data frame Data for all data
dCombine <- cbind(dSubject, dActivity)
Data <- cbind(dFeatures, dCombine)
#Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dFeaturesNames$V2)]
#Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
#Check the structures of the data frame Data
str(Data)
#Read descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
#facorize Variale activity in the data frame Data using descriptive activity names
#check
head(Data$activity,30)
#Appropriately labels the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
#check it
names(Data)
#Creates another,independent tidy data set and ouput it.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
#Produce Codebook
library(knitr)
knit2html("codebook.Rmd");