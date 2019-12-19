# Script is initiated checking if the Dataset zip file is present
# If it is, it will set the working directory to it and begin the analysis
# If it is not, it will assume that the current directory is the Dataset one
if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")){
                fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(fileURL,"getdata_projectfiles_UCI HAR Dataset.zip", method="curl")
}
if (!dir.exists("getdata_projectfiles_UCI HAR Dataset")) { 
        unzip("getdata_projectfiles_UCI HAR Dataset.zip") 
}
# Checking if the Dataset directory is present
# If it is, it will set the working directory to it and begin the analysis
# If it is not, it will assume that the current directory is the Dataset one
if(dir.exists("UCI HAR Dataset")){
        setwd("./UCI HAR Dataset")
}

# Checking if dplyr is installed and calling it

if(!require("dplyr")) install.packages("dplyr")
library("dplyr")

#Reading the data that will be brought together into a single tidy dataset

feature_names <- read.table("features.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt", col.names = c("activity_label"))
sub_test <- read.table("./test/subject_test.txt", col.names = c("subject_Id"))

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt", col.names = c("activity_label"))
sub_train <- read.table("./train/subject_train.txt", col.names = c("subject_Id"))

#Using the list of features to name each variable in each x dataset

colnames(x_test) <- colnames(x_train) <- unlist(feature_names[2])

act_labels <- read.table("activity_labels.txt", col.names = c("activity_label","activity"))

# Pre-merging the datasets into a test and a training datasets
# While extracting only the measurements on the mean and 
# standard deviation for each measurement
# It might be useful to visualize the data if it's needed

test_merged <- cbind(arrange(merge(cbind(sub_test,y_test),act_labels), by = subject_Id),x_test[grep("(M|m)ean|(S|s)td." ,names(x_test))])
train_merged <- cbind(arrange(merge(cbind(sub_train,y_train),act_labels), by = subject_Id),x_train[grep("(M|m)ean|(S|s)td." ,names(x_train))])

# Binding the two datasets together and removing the label column that was used
# To match descriptive activity names to name the activities in the data set
# And each variable is given descriptive names 

df_tidy <- rbind(test_merged,train_merged)
df_tidy$activity_label <- NULL
names(df_tidy)<-gsub("Acc", "Accelerometer", names(df_tidy))
names(df_tidy)<-gsub("Gyro", "Gyroscope", names(df_tidy))
names(df_tidy)<-gsub("BodyBody", "Body", names(df_tidy))
names(df_tidy)<-gsub("Mag", "Magnitude", names(df_tidy))
names(df_tidy)<-gsub("^t", "Time_", names(df_tidy))
names(df_tidy)<-gsub("^f", "Frequency_", names(df_tidy))
names(df_tidy)<-gsub("tBody", "Timebody_", names(df_tidy))
names(df_tidy)<-gsub("-mean()", "Mean", names(df_tidy))
names(df_tidy)<-gsub("-std()", "STD", names(df_tidy), ignore.case = TRUE)
names(df_tidy)<-gsub("-freq()", "frequency_", names(df_tidy),)
names(df_tidy)<-gsub("angle", "Angle", names(df_tidy))
names(df_tidy)<-gsub("gravity", "Gravity", names(df_tidy))

# From the tidy data set, an independent second data set is created 
# With the average of each variable for each activity and each subject
# Finally it's written to the working directory as the tidydata.txt file

df_tidy2<-aggregate(. ~subject_Id + activity, df_tidy, mean)
df_tidy2<-df_tidy2[order(df_tidy2$subject_Id,df_tidy2$activity),]
setwd('..')
write.table(df_tidy2, file = "tidydata.txt",row.name=FALSE)
