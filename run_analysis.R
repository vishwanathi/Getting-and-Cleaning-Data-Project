# Getting and Cleaning Data course
# Projecet Assiggment

# Set Working Directory

setwd("C:/Users/Mahesh/Coursera/R working directory/getting and cleaning data/Project/data")

# Read Test and train data and put them all together
# Includes the data from X, Y (activity) and Subject ID

testdata <- cbind(read.table("X_test.txt"), read.table("Y_test.txt"), read.table("subject_test.txt"))
traindata <- cbind(read.table("X_train.txt"), read.table("Y_train.txt"), read.table("subject_train.txt"))
alldata <- rbind(testdata, traindata)


# Read variable name info, and apply to dataset 

colnames <- read.table("features.txt")
V3 <- gsub("\\(","",colnames$V2)
V3 <- gsub(")","",V3)
V3 <- gsub("-","_",V3)
V3 <- gsub(",","_",V3)
V3 <- gsub("angle","angle_",V3)
V4 <- c(V3,"Activity_Num","Subject_ID")
colnames(alldata) <- V4

# Subset dataset with only means and standard deviationsb
# Also keep the last 2 columns which are activity type and subject id

V5 <- c(which(grepl(".mean",V3) | grepl(".std",V3)),562, 563)
alldata_reduced <- alldata[,V5]


# Read label info

activitylabels <- read.table("activity_labels.txt")
names(activitylabels) <- c("Activity_Num", "Activity_Label")
alldata_reduced <- merge(alldata_reduced,activitylabels,by.x="Activity_Num",by.y="Activity_Num", all=TRUE)
alldata_reduced <- alldata_reduced[,-1]

# Compute means by Activity Label and Subject ID

alldata_reduced <- alldata_reduced[order(alldata_reduced$Subject_ID, alldata_reduced$Activity_Label),]
library(reshape2)
adredMelt <- melt(alldata_reduced,id=c("Subject_ID", "Activity_Label"))
final_ds <- dcast(adredMelt, Subject_ID + Activity_Label ~ variable, mean)
colnames(final_ds)[3:81] <- paste("Average",colnames(final_ds)[3:81],sep="_")

# Write the file out into the working directory area as a txt file

write.table(final_ds,file="project_final_ds.txt",sep="\t", col.names = T, row.names = F)



