# get the data


# 1. Read the data files into R

  # read data

Xtest <-read.table("X_test.txt")
Ytest <-read.table("Y_test.txt")
Ytrain <-read.table("Y_train.txt")
Xtrain <-read.table("X_train.txt")
subtest<- read.table("subject_test.txt")
subtrain<- read.table("subject_train.txt")
activities <- read.table("activity_labels.txt", col.names = c("id", "activity"))
features<-read.table("features.txt")
  
  # merge training and tests sets and then bind full data sets

XFull <- rbind(Xtest, Xtrain)
YFull <- rbind(Ytrain, Ytest)
subFull <- rbind(subtrain, subtest)
full<- cbind(subFull, YFull, XFull)
  

# 2. Extract mean and standard deviation for each measurement

  # get columns containing mean and std, convert to lowercase and subset

MeanStd <- features$V2[grep("-(mean|std)\\(\\)", features[,2])]
labels <- c("subject", "activity", tolower(MeanStd))
colnames(full) <- labels
full<-full[1:68]


# 3. Use descriptive activity names in the data set

full$activity <- as.factor(full$activity)
levels(full$activity)<- c("walking", "walkingupstairs", "walkindownstairs", 
                                 "sitting", "standing", "laying")


# 4. Appropriately label data set with descriptive variable names

names(full)<-gsub("^f", "Frequency", names(full))
names(full)<-gsub("^t", "Time", names(full))
names(full)<-gsub("acc", "Accelerometer", names(full))
names(full)<-gsub("gyro", "Gyroscope", names(full))
names(full)<-gsub("mag", "Magnitude", names(full))                                                  
names(full)<-gsub("bodybody", "Body", names(full))
names(full)<-gsub("body", "Body", names(full)) 
names(full)<-gsub("jerk", "Jerk", names(full))
                                                
                                                  
# 5. Create a tidy data set 

tidy <- ddply(full, .(subject, activity), function(x) colMeans(x[, 3:68]))
                                                  
write.table(tidy, "tidy.txt", row.name=F)