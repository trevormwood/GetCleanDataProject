#download the file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","smartphone_data.zip")

#extract data from the the .zip
unzip("smartphone_data.zip")

#load the main files into Rstudio workspace
x_test = read.table("./UCI HAR Dataset/test/X_test.txt")
y_test = read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train = read.table("./UCI HAR Dataset/train/X_train.txt")
y_train = read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")

# merge the test and trial data into single data frames for different parts of data
all_data = rbind(x_test,x_train)
all_activities = rbind(y_test,y_train)
all_subjects = rbind(subject_test,subject_train)

#load in the list of features and identify the relevant columns
features = read.table("./UCI HAR Dataset/features.txt")
feature_names = as.character(features[,2])
meanInds = grep("mean",feature_names)
stdInds = grep("std",feature_names)
allInds = c(sort(c(meanInds,stdInds)))
all_feature_names = feature_names[allInds]

#select only the relevant bits of the data
all_data = all_data[,allInds]

#convert the numerical activity labels to strings
activity_labels = c("Walking","Walking Upstairs","Walking Downstairs","Sitting","Standing","Laying")
all_activity_names = character(nrow(all_data))
all_subject_ids = integer(nrow(all_data))
for(ii in 1:nrow(all_activities)){
    all_activity_names[ii] = activity_labels[as.integer(all_activities[ii,1])]
    all_subject_ids[ii] = as.integer(all_subjects[ii,1])
}

#convert the variable names to something more readable
all_feature_names = tolower(all_feature_names)

#specify time vs frequency domain
for(ii in 1:length(all_feature_names)){
    if(substr(all_feature_names[ii],1,1)=="t"[]){
        all_feature_names[ii] = paste("timedomain",substring(all_feature_names[ii],2))
    }
    if(substr(all_feature_names[ii],1,1)=="f"[]){
        all_feature_names[ii] = paste("frequencydomain",substring(all_feature_names[ii],2))
    }
}

#replace some unreadable abbreviations
all_feature_names = gsub("acc","acceleration",all_feature_names)
all_feature_names = gsub("mag","magnitude",all_feature_names)
all_feature_names = gsub("gyro","gyroscope",all_feature_names)
all_feature_names = gsub("std","standarddeviation",all_feature_names)
all_feature_names = gsub(" ","",all_feature_names)

#use the new column names in data frame
colnames(all_data) = all_feature_names

#add the activities and output
all_data$subject = all_subject_ids
all_data$activity = all_activity_names
write.table(all_data,"tidy_data1.txt",row.names=FALSE)

#get the mean for each measurement for all subject-activity pairs
all_data2 = data.frame(matrix(ncol=180,nrow=79))
column_labels = character(180)
for(ii in 1:30){
    for(jj in 1:6){
        inds = all_data[,80]==ii & all_data[,81]==activity_labels[jj]
        theMeans = colMeans(all_data[which(inds),1:79])
        all_data2[,(jj-1)*30+ii] = theMeans
        column_labels[(jj-1)*30+ii] = paste("subject",as.character(ii),"activity",as.character(jj))
    }
}

#give correct column names to variables
column_labels = gsub(" ","",column_labels)
colnames(all_data2) = column_labels

#write the second data set
write.table(all_data2,"tidy_data2.txt",row.names=FALSE)