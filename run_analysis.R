#features and activity data
features <- read.table("features.txt", header = FALSE)
activitylabels <- read.table("activity_labels.txt", header = FALSE)

#assigning column names
colnames(activitylabels) <- c("activityid","activity")


#train data
subjecttrain <- read.table("train/subject_train.txt", header = FALSE)
xtrain <- read.table("/Users/lseino/Desktop/coursera/samsungdata/UCI HAR Dataset/train/X_train.txt", header = FALSE)
ytrain <- read.table("/Users/lseino/Desktop/coursera/samsungdata/UCI HAR Dataset/train/y_train.txt", header = FALSE)

#assigning column names
colnames(subjecttrain) <- "subject"
colnames(xtrain) <- features$V2
colnames(ytrain) <- "activity"
#bind train data
traindata <- cbind(ytrain,subjecttrain,xtrain)

#test data
subjecttest <- read.table("test/subject_test.txt", header = FALSE)
xtest <- read.table("/Users/lseino/Desktop/coursera/samsungdata/UCI HAR Dataset/test/X_test.txt", header = FALSE)
ytest <- read.table("/Users/lseino/Desktop/coursera/samsungdata/UCI HAR Dataset/test/y_test.txt", header = FALSE)

#assigning column names
colnames(subjecttest) <- "subject"
colnames(xtest) <- features$V2
colnames(ytest) <- "activity"
#bind train data
testdata <- cbind(ytest,subjecttest,xtest)

#final binding
finaldata <- rbind(traindata,testdata)

#extracting only the measurements for mean and std and ensuring the subject and activity table present
mean_stddata <- finaldata[,grepl("mean|std|",names(finaldata))]
mean_stddata[1:2] <- TRUE

#use descriptive names to name data in the data set
install.packages(reshape2)
library(plyr)
library(dplyr)
library(reshape2)
mean_stddata <- join(mean_stddata,activitylabels, by = "activityid")
finaldata <- finaldata[,mean_stddata]
finaldata$activity <- factor(finaldata$activity,
                            labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

#remove paranthesis and correct syntax in names
#descriptive names
names(finaldata) <- gsub("Acc", "Acceleration", names(finaldata))
names(finaldata) <- gsub("^t", "Time", names(finaldata))
names(finaldata) <- gsub("^f", "Frequency", names(finaldata))
names(finaldata) <- gsub("BodyBody", "Body", names(finaldata))
names(finaldata) <- gsub("mean", "Mean", names(finaldata))
names(finaldata) <- gsub("std", "Std", names(finaldata))
names(finaldata) <- gsub("Freq", "Frequency", names(finaldata))
names(finaldata) <- gsub("Mag", "Magnitude", names(finaldata))

#tidydata
meltdataset <- melt(finaldata, id = c("subject","activity"))
tidydata <- dcast(meltdataset,subject+activity ~ variable, mean)
write.csv(tidydata,"tidydata.csv", row.names = FALSE)
