#install packages if necessary
install.packages("dplyr")
install.packages("rattle")

#require necessary packages
require(dplyr)
require(rattle)

#set location variables for files
datafilesdirectory<-"./UCI HAR Dataset/"
test.datafilesdirectory<-paste(datafilesdirectory,"test/" ,sep="")
train.datafilesdirectory<-paste(datafilesdirectory,"train/" ,sep="")

#Read the activity label and feature data
activity.raw<-read.table(paste(datafilesdirectory,"activity_labels.txt",sep=""))
features.raw<-read.table(paste(datafilesdirectory,"features.txt",sep=""))

#set names for activity file for later mapping
names(activity.raw)<-c("activityid","activity")


#Read the raw test data 
test.data.raw<-read.table(paste(test.datafilesdirectory,"X_test.txt",sep=""))
test.activityid.raw<-read.table(paste(test.datafilesdirectory,"y_test.txt",sep=""))
test.subject.raw<-read.table(paste(test.datafilesdirectory,"subject_test.txt",sep=""))

#add column headers to the data file
names(test.data.raw)<-features.raw[,2]

#merge the columns of the data files
test.data.mergedcols<-test.data.raw
test.data.mergedcols$activityid<-test.activityid.raw[,1]
test.data.mergedcols$subject<-test.subject.raw[,1]


#get rid of unnecessary structures to save memory
rm(test.data.raw,test.activityid.raw,test.subject.raw)


#get rid of duplicated cols
test.data.mergedcols<-test.data.mergedcols[,!duplicated(names(test.data.mergedcols))]

#reduce the columns we are working with to only the -mean() and -std() columns
test.data.reducedcols<-test.data.mergedcols %>%
  select( subject, activityid, matches("mean()|std()"))

#remove unnecessary data
rm(test.data.mergedcols)


##Do the same for training. This could've been more elegant with a function.
#Read the raw train data
train.data.raw<-read.table(paste(train.datafilesdirectory,"X_train.txt",sep=""))
train.activityid.raw<-read.table(paste(train.datafilesdirectory,"y_train.txt",sep=""))
train.subject.raw<-read.table(paste(train.datafilesdirectory,"subject_train.txt",sep=""))

#add column headers to the data file
names(train.data.raw)<-features.raw[,2]

#merge the columns of the data files
train.data.mergedcols<-train.data.raw
train.data.mergedcols$activityid<-train.activityid.raw[,1]
train.data.mergedcols$subject<-train.subject.raw[,1]

#get rid of unnecessary structures
rm(train.data.raw,train.activityid.raw,train.subject.raw)

#get rid of duplicated cols
train.data.mergedcols<-train.data.mergedcols[,!duplicated(names(train.data.mergedcols))]

#reduce the columns we are working with to only the -mean() and -std() columns
train.data.reducedcols<-train.data.mergedcols %>%
  select( subject, activityid, matches("mean()|std()"))

#remove unnecessary data
rm(train.data.mergedcols)

#combine 2 sets into 1
combined.ds<-rbind(test.data.reducedcols,train.data.reducedcols)

#add the activity name to the combined ds
combined.ds<-combined.ds %>%
  left_join(activity.raw) %>%
  select(-activityid)

#get rid of more unnecessary columns
final.ds<-combined.ds %>%
  select(-contains("angle("))%>%
  select(-matches("freq()?"))    

#get rid of unnecessary structures
rm(test.data.reducedcols,train.data.reducedcols, features.raw, activity.raw)


#get the names to clean up
dsnames<-normVarNames(names(final.ds))

#fix names
dsnames<-sub("f_","frequency_", dsnames, fixed=T)
dsnames<-sub("t_","time_", dsnames, fixed=T)
dsnames<-sub("-mean()","_mean", dsnames, fixed=T)
dsnames<-sub("-std()","_standarddeviation", dsnames, fixed=T)
dsnames<-sub("-std()","_standarddeviation", dsnames, fixed=T)
dsnames<-sub("_body_body_","_body_", dsnames, fixed=T)
dsnames<-sub("_acc","_accelerometer", dsnames, fixed=T)
dsnames<-sub("_gyro","_gyroscope", dsnames, fixed=T)
dsnames<-sub("x$","xaxis", dsnames)
dsnames<-sub("y$","yaxis", dsnames)
dsnames<-sub("z$","zaxis", dsnames)
dsnames<-sub("-","", dsnames, fixed=T)
dsnames<-gsub("_","", dsnames, fixed=T )
dsnames<-paste("average",dsnames,sep="")
dsnames<-sub("averageactivityaxis","activity", dsnames, fixed=T)
dsnames<-sub("averagesubject","subject", dsnames, fixed=T)

#add the names back to the final output
names(final.ds)<-dsnames


#create the final output summary
final.ds<-final.ds %>%
    group_by(subject,activity)%>%
    summarise_each(funs(mean))

#save the data
write.table(final.ds,"summarisedfinaldata.txt",row.names = F)


