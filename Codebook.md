# Codebook

This file describes the data, the variables, and the work that has been performed to clean up the data.

### Data Set Description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

Check the README.md file for further details about this dataset.


#### Attribute Information:

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### Sources & Assumptions

The raw data was obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, the description of the original data can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

It is assumed that the Samsung data is unzipped into the working directory. Therefore the data should and the run_analysis.R  script should reside in the same folder.

### Work & Transformations:

#### Merged the training and the test sets to create one data set.

In the Data there are two directories - test and train.
I read the three files from each directory and combined them into one data set, which resulted to one dataset for each category (test and train).
```{r}
test <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)
```
After getting these two data sets I merged them to one tidy data set with 10299 obs. of 563 variables.
```{r}
Data <- rbind(test, train)
```

#### Extracted only the measurements on the mean and standard deviation for each measurement.

Based on column names in the features text file, I restricted the data to only those columns that have something to do with mean or standard deviation.
```{r}
names(Data1)[3:68]
 [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
 [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
 [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
[13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
[17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
[21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
[25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
[29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
[33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
[37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
[41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
[45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
[57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
[61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
```

#### Used descriptive activity names to name the activities in the data set and appropriately labeled the data set with descriptive variable names.

Based on the Activity names in the "activity_labels.txt" file, I replaced the activity IDs (y-test and y_train data binded within the 2nd column of the tidy dataset) with their correspoding activity names:
```{r}
ID Activity name

1  WALKING
2  WALKING_UPSTAIRS
3  WALKING_DOWNSTAIRS
4  SITTING
5  STANDING
6  LAYING
```
I also appropriately labeled the first the subject and activity columns.
```{r}
 names(Data1)[1:2]
[1] "Subject_ID"    "Activity_Name"
```
#### Created 2 datasets: 

The First dataset is the dataset compatible with the instructions above
```{r}
write.table(Data1, file="./Tidy_Dataset.txt", sep="\t")
```
The second dataset is an independent tidy data set with the average of each variable for each activity and each subject.
```{r}
library(reshape2)
DataMelt <- melt(Data1, id=c("Subject_ID", "Activity_Name"))  # table with all unique values per subject/activity pair
Data2 <- dcast(DataMelt, Subject_ID + Activity_Name ~ variable, mean)  # means of values per pair

write.table(Data2, file="./Tidy_Means.txt", sep="\t"
```