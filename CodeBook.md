# Codebook
  The run_analysis.R script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

1) **Downloading the UCI HAR Dataset**  
    Dataset downloaded and extracted under the folder called UCI HAR Dataset

2) **Assign each data to variables**  
    * feature_names <- features.txt : 561 rows, 2 columns  
    The features come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ, that were originated by the subjects smartphones.
    * act_labels <- activity_labels.txt : 6 rows, 2 columns  
    List that correlates the labels with the activities that were being performed when the measurements where made.
    * sub_test <- test/subject_test.txt : 2947 rows, 1 column  
    Contains test data of 9 out of the 30 volunteer test subjects being observed
    * x_test <- test/X_test.txt : 2947 rows, 561 columns  
    Contains recorded features test data
    * y_test <- test/y_test.txt : 2947 rows, 1 columns  
    Contains test data of activities’code labels
    * sub_train <- test/subject_train.txt : 7352 rows, 1 column  
    Contains train data of 21 out of the 30 volunteer test subjects being observed
    * x_train <- test/X_train.txt : 7352 rows, 561 columns  
    Contains recorded features train data
    * y_train <- test/y_train.txt : 7352 rows, 1 columns  
    Contains train data of activities code labels

3) **Extracts only the measurements on the mean and standard deviation for each measurement**  
    * test_merged (7352 rows, 89 columns) is created by merging x_test, y_test, act_lebels and sub_test by first cbinding sub_test and y_test, then merging the resultant data set with act_labels by using arrange() and the activity_label column as index; and finally by cbinding the result with the columns in x_test where either mean or standard deviation were present.  
    * train_merged (2947 rows, 89 column) is created by merging x_train, y_train, act_lebels and sub_train  by first cbinding sub_train and y_train, then merging the resultant data set with act_labels by using arrange() and the activity_label column as index; and finally by cbinding the result with the columns in x_train where either mean or standard deviation were present.

4) **Merges the training and the test sets to create one data set**  
    * df_tidy (10299 rows, 88 columns) is created by merging test_merged and train_merged using rbind() with test_merged and train_merged, since both have the same number of equally named columns. Then the

5) **Appropriately labels the data set with descriptive variable names are given to the columns in df_tidy that were brought from x_test and x_train**  

    * All Acc in column's name are replaced by Accelerometer
    * All Gyro in column's name are replaced by Gyroscope
    * All BodyBody in column's name are replaced by Body
    * All Mag in column's name are replaced by Magnitude
    * All f characters that start a column's name are replaced by Frequency_
    * All t characters that start a column's name are replaced by Time_

6) **From the data set with descriptive variable names, creates a second, independent tidy data set with the average of each variable for each activity and each subject**  
    * df_tidy2 (180 rows, 88 columns) is created by the function aggregate(), by taking the mean of every variable for each subject in each activity.  
    df_tidy2 is then exported into tidydata.txt file.

