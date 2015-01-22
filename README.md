==================================================================
The original measurements are from the research done by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio and Luca Oneto. See information about their research below
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

==================================================================

For the tidy dataset the respective mean of the measured variable is calculated for each Subject and Activity. 

The dataset includes the following files
==================================================================
- "README.md"
- "codebook_tidy.txt": Shows information about the variables used on the feature vector.
- "tidy_variables.txt": List of all features.
- "tidy_data.txt": Tidy data set

==================================================================

```{r}

## install packages
install.packages("sqldf")
library(sqldf)
install.packages("plyr")
library(plyr)
install.packages("dplyr")
library(dplyr)

## set directory for the column names, read the column names and activity names.
name_dir <- "/" 
names <- read.csv(paste(getwd(), name_dir, "features.txt", sep=""), sep="", header=FALSE, col.names=c("Id", "Measurement")) 
Act <- read.csv(paste(getwd(), name_dir, "activity_labels.txt", sep=""), sep="", header=FALSE, col.names=c("Id", "Activity"))

## set the directory for the test data, read in the test data, subject test data and activity test data.
## combine the columns for the test data set.
test_dir <- "/test/" 
X_test <- read.csv(paste(getwd(), test_dir, "X_test.txt", sep=""), sep="", header=FALSE, col.names=names$Measurement)
subject_test <- read.csv(paste(getwd(), test_dir, "subject_test.txt", sep=""), sep="", header=FALSE, col.names="Subject") 
Y_test <- read.csv(paste(getwd(), test_dir, "y_test.txt", sep=""), sep="", header=FALSE, col.names="Activity") 
test_data <- cbind(subject_test, Y_test, X_test) 

## set the directory for the train data, read in the train data, subject train data and activity train data.
## combine the columns for the train data set
train_dir <- "/train/" 
X_train <- read.csv(paste(getwd(), train_dir, "X_train.txt", sep=""), sep="", header=FALSE, col.names=names$Measurement) 
subject_train <- read.csv(paste(getwd(), train_dir, "subject_train.txt", sep=""), sep="", header=FALSE, col.names="Subject") 
Y_train <- read.csv(paste(getwd(), train_dir, "y_train.txt", sep=""), sep="", header=FALSE, col.names="Activity") 
train_data <- cbind(subject_train, Y_train, X_train)  

#combine the test and trainings data set
data <- rbind(test_data, train_data) 

## select the subject and set the column name
Subject <- data[,1]
names(Subject) <- "Subject"

## replace the activity number to a descriptive word
data_activity <- sqldf("SELECT Act.Activity as Activity FROM data INNER JOIN Act ON data.Activity= Act.Id") 

## select the columns with the keyword mean and with the keyword std
data_mean <- select(data, contains("mean", ignore.case=TRUE)) 
data_std <- select(data, contains("std", ignore.case=TRUE)) 

## combine the columns and rename the subject column
new <- cbind(Subject, data_activity, data_mean, data_std) 

## create the tidy data set
tidy <- ddply(new, .(Subject, Activity), numcolwise(mean))

## write the tidy data set to tidy_data.txt
write.table(tidy, file="tidy_data.txt", row.name=FALSE)

```

==================================================================


