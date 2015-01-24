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
tidy <- ddply(new, .(Activity, Subject), numcolwise(mean))

## write the tidy data set to tidy_data.txt
write.table(tidy, file="tidy_data.txt", row.name=FALSE)