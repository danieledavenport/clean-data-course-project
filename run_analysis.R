#First, download the data
myurl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(myurl,"dataset.zip",method="curl")
#Record the date and time the data was downloaded and write it out to metadata.txt
metadata<-paste("Source data downloaded from", myurl, "as of",format(Sys.time(), "%b %d %Y %X"))
fileConn<-file("metadata.txt")
writeLines(metadata, fileConn)
close(fileConn)

#Extract the components of the zip file
unzip("dataset.zip")

#Create a data frame for the test set
#First, since we will eventually need descriptive variable names for the columns so we will create a vector to use for col.names
featurefile<-"UCI HAR Dataset/features.txt"
varfile<-read.table(featurefile)
varnames<-as.character(varfile[,2])
#Then we read in the test data
testfile<-"UCI HAR Dataset/test/X_test.txt"
dfTest<-read.table(testfile, col.names=varnames)

#Create a data frame for the training set
trainfile<-"UCI HAR Dataset/train/X_train.txt"
dfTrain<-read.table(trainfile, col.names=varnames)

#Merge the test set and the training set to create one data set.
df<-rbind(dfTest, dfTrain)

#Before doing any extraction or summarization, combine the new data set with vectors which provide:
#1) descriptive activity names, and 2) subject identifiers
#Create a vector of activity codes for the test data set
testactfile<-"UCI HAR Dataset/test/y_test.txt"
#Read in the test activity codes
dfTestact<-read.table(testactfile, col.names=c("activity_code"))
#Create a vector of activity codes for the training data set
trainactfile<-"UCI HAR Dataset/train/y_train.txt"
#Read in the train activity codes
dfTrainact<-read.table(trainactfile, col.names=c("activity_code"))
#Combine the test and train activity code data
dfAct<-rbind(dfTestact,dfTrainact)
#Add the activity_code column as the first column
df<-cbind(dfAct,df)

#Create a vector of subject identifiers for the test data set
testsubfile<-"UCI HAR Dataset/test/subject_test.txt"
#Read in the test subject identifiers
dfTestsub<-read.table(testsubfile, col.names=c("subject_id"))
#Create a vector of subject identifiers for the training data set
trainsubfile<-"UCI HAR Dataset/train/subject_train.txt"
#Read in the train subject identifiers
dfTrainsub<-read.table(trainsubfile, col.names=c("subject_id"))
#Combine the test and train subject identifiers data
dfSub<-rbind(dfTestsub,dfTrainsub)
#Add the subject_id column as the first column
df<-cbind(dfSub,df)

#Add activity column with translated activities
#define the lookup table for activity codes
lookupfile<-"UCI HAR Dataset/activity_labels.txt"
#Read in the lookup file of activity codes
Lookup<-read.table(lookupfile, col.names=c("activity_code","activity"))

#Use plyr to join activity_code to activity
library(plyr)
df<-join(df,Lookup,by="activity_code")
#Rearrange the columns as subject_id, activity, activity_code
lastcol<-length(names(df))
df <- df[c(names(df)[1], names(df)[lastcol],names(df)[2:(lastcol-1)])]

#Extract only the measurements on the mean and standard deviation for each measurement.
#First, create a regex expression for the columns we are interested in
mypattern<-"subject|activity|std|mean"
#Then, create a vector of the column names
namestemp<-names(df)[grep(mypattern,names(df))]
#The result contains "...meanFreq..." which we do not want
excludepattern<-"meanFreq"
#The final vector of column names.
mynames<-namestemp[grep(excludepattern,namestemp,invert=TRUE)]
 
#Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
#For the measure variables, we exclude the first three column names
mvars<-mynames[4:length(mynames)]
#We then take the previous dataframe and first apply melt, then dcast
tmpmelt<-melt(temp,id.vars=c("subject_id","activity"), measure.vars=mvars)
result<-dcast(tmpmelt,subject_id + activity ~ variable, mean)