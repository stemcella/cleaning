
###STEP0. DOWNLOADING FILES,
rm(list=ls())
library(plyr)   ## load plyr package for dplyr
library(dplyr)  ## load dplyr package for handling dataframe easy.
url<-c("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
download.file(url,"dataset.zip",method="curl")
unzip("dataset.zip")

### STEP1. MERGING DATA TABLE (561+3 columns, 7352+2947 rows)

train<-read.csv("./UCI HAR Dataset/train/X_train.txt", sep="",header=FALSE)
test<-read.csv("./UCI HAR Dataset/test/X_test.txt", sep="",header=FALSE)
dataset<-rbind(train,test)
featNames<-read.csv("./UCI HAR Dataset/features.txt",sep="",header=FALSE)
featNames<-featNames[,2]
colnames(dataset)<-featNames

train_label<-read.csv("./UCI HAR Dataset/train/y_train.txt",sep="",header=FALSE)
test_label<-read.csv("./UCI HAR Dataset/test/y_test.txt",sep="",header=FALSE)
activity<-rbind(train_label,test_label)
colnames(activity)<-c("activity")

subject_train<-read.csv("./UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")
subject_test<-read.csv("./UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="")
subject<-rbind(subject_train,subject_test)
colnames(subject)<-c("subject")

group<-as.factor(c(rep("train",7352),rep("test",2947)))

fdata<-cbind(dataset,activity,subject,group)
fdata<-group_by(fdata,group)

### STEP2. Extracting Mean and Std values (66+3 columns, 7352+2947 rows)

valid_colnames<- make.names(names=names(fdata), unique=TRUE, allow_=TRUE)  ##removing some duplicating column error..
colnames(fdata)<-valid_colnames
Final<-select(.data=fdata,subject,activity,contains(".mean.."),contains(".std.."))


### STEP3. Uses descriptive activity names to name the activities in the data set

Final$activity<-as.character(Final$activity)
Final$activity[Final$activity==1]<-"Walking"
Final$activity[Final$activity==2]<-"Walking Upstairs"
Final$activity[Final$activity==3]<-"Walking Downstairs"
Final$activity[Final$activity==4]<-"Sitting"
Final$activity[Final$activity==5]<-"Standing"
Final$activity[Final$activity==6]<-"Laying"
Final$activity<-as.factor(Final$activity)


### STEP4. Appropriately labels the data set with descriptive variable names.
Final$subject <- as.character(Final$subject)
for (i in 1:30) {
        Final$subject[Final$subject == i] <- paste("Participant", i)}
Final$subject<-as.factor(Final$subject)

### STEP5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData<-group_by(Final,subject,activity,group)%>%summarise_each(funs(mean))%>%arrange(subject,activity)
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)

