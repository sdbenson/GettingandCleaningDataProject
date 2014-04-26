GettingandCleaningDataProject
=============================

************
Study Design
************

The source data for this dataset can be found at the following website: 
https://d396quasza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 

Once the data is file is unzipped, the following 9 files need to be put in the working directory:
1.  subject_test.txt
2.  X_test.txt
3.  Y_test.txt
4.  subject_train.txt
5.  X_train.txt
6.  Y_train.txt
7.  activity_labels.txt
8.  features.txt
9.  features_info.txt

-Data in the "inertial signals" files was not used.
-A description of the source data can be found in the README.txt and features_info.txt file


*********************
run_analysis.R script
*********************

-The "reshape2" package will need to be installed prior to running the run_analysis.R script

Script Objective:
1.  Merge the training and test data set to create one data set
2.  Extract only the features that are "means" and "standard deviations"
3.  Appropriately labels the data seet with descriptive activity names and feature names
4.  Create a second, independent tidy data set with the average of each feature for each activity and each subject

Description of how the script works: 

library(reshape2)  #Loads the "reshape2 library



subject_test=read.table("subject_test.txt",sep="")  #Reads in a data file

X_test=read.table("X_test.txt",sep="")  #Reads in the a file

Y_test=read.table("Y_test.txt",sep="")  #Reads in a data file



subject_train=read.table("subject_train.txt",sep="")  #Reads in a data file

X_train=read.table("X_train.txt",sep="")  #Reads in the a file

Y_train=read.table("Y_train.txt",sep="") #Reads in the a file



activity_labels=read.table("activity_labels.txt",sep="")  #Reads in the a file

features=read.table("features.txt",sep="")   #Reads in the a file

features_info=read.table("features_info.txt",sep="")   #Reads in the a file


labs=paste(features [,2])  #creates a character vector of the feature 
names
names(X_train)=labs  #replaces the non-descriptive names from the X_train dataframe with the feature names

names(X_test)=labs  #replaces the non-descriptive names from the X_test dataframe with the feature names

names(activity_labels)=c("V1","activity")  #replaces the names of the columns in the activity_lables dataframe with V1 and "activity"

names(subject_test)="subject"  #replaces the column name V1 with "subject"

names(subject_train)="subject"  #replaces the column name V1 with "subject"

meanstdfeatures=grep(("-mean|std"),labs)  # returns the indicies of features the have "-mean" or "std" in the name

meanstdfeaturesname=grep(("-mean|std"),labs,value=TRUE)  #returns the name of the features that have "-mean" or "std" in the name

X_test_meanstd=X_test[,meanstdfeatures]  #selects columns that has "-mean" or "std" in the feature name

X_train_meanstd=X_train[,meanstdfeatures]  #selects columns that has "-mean" or "std" in the feature name

XY_train=cbind(subject_train,Y_train,X_train_meanstd)  #  combines columns from the "subject" dataframe, "Y_train" dataframe and the "X_train_meanstd" (only the data with "mean" or "std" in its name)

XY_test=cbind(subject_test,Y_test,X_test_meanstd)  #  combines columns from the "subject" dataframe, "Y_test" dataframe and the "X_test_meanstd" (only the data with "mean" or "std" in its name)

XY=rbind(XY_train,XY_test)  # merges the train and test datasets together

MergeXY=merge(activity_labels,XY,sort=FALSE)  #merges the XY dataset and the activity lables on the V1 variable name

MergeXY$V1=NULL  #removes the V1 column from the final dataset


molten=melt(MergeXY,id=c("subject","activity"))  #melts the merged dataset to facilitate the creation of the average of each variable for each activity and each subject


finaloutput=dcast(molten,subject + activity ~ variable,fun.aggregate=mean)  #obtains the mean of each variable for each activity and each subject


*********
Code Book
*********
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are in this data set are: 

mean(): Mean value
std(): Standard deviation

The data in the final dataset is the average of each feature for each activity and each subject


