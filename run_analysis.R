### 1. Merges the training and the test sets to create one data set.

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(X_test) <- features[, 2]

test <- cbind(subject_test, y_test, X_test)
str(test)  # 563 variables


subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(X_train) <- features[, 2]

train <- cbind(subject_train, y_train, X_train)
str(train)

Data <- rbind(test, train)
str(Data)
names(Data)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

extractCols <- grep("mean\\(\\)|std\\(\\)", names(Data))  # indices
Data1 <- Data[, c(1, 2, extractCols)]
names(Data1)


### 3. Uses descriptive activity names to name the activities in the data set

Data1[, 2] <- as.factor(Data1[, 2])
activities <- read.table(".//UCI HAR Dataset/activity_labels.txt")
levels(Data1[, 2]) <- activities[, 2]
str(Data1[, 2])


### 4. Appropriately labels the data set with descriptive variable names. 

colnames(Data1)[1:2] <- c("Subject_ID", "Activity_Name")
names(Data1)

write.table(Data1, file="./Tidy_Dataset.txt", sep="\t")


### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(reshape2)
DataMelt <- melt(Data1, id=c("Subject_ID", "Activity_Name"))  # table with all unique values per subject/activity pair
Data2 <- dcast(DataMelt, Subject_ID + Activity_Name ~ variable, mean)  # means of values per pair

write.table(Data2, file="./Tidy_Means.txt", sep="\t")
