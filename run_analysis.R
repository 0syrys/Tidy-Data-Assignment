#reading in data

testx<-read.table("~/UCI HAR Dataset/test/X_test.txt")
testy<-read.table("~/UCI HAR Dataset/test/y_test.txt")
testsub<-read.table("~/UCI HAR Dataset/test/subject_test.txt")
trainx<-read.table("~/UCI HAR Dataset/train/X_train.txt")
trainy<-read.table("~/UCI HAR Dataset/train/y_train.txt")
trainsub<-read.table("~/UCI HAR Dataset/train/subject_train.txt")

#combining test and train set

datax<-rbind(testx,trainx)
datay<-rbind(testy,trainy)
datasub<-rbind(testsub,trainsub)

#filtering mean() and std() columns

descr<-read.table("~/UCI HAR Dataset/features.txt")
descr<-filter(descr, as.logical(grepl("mean()",descr$V2, fixed=TRUE)+grepl("std()",descr$V2,fixed=TRUE)))
datax<-select(datax,descr$V1)
Names<-as.data.frame(descr$V2)
Names<-as.data.frame(sapply(Names,gsub,pattern="mean\\()",replacement="Mean"))
Names<-as.data.frame(sapply(Names,gsub,pattern="std\\()",replacement="Std"))

colnames(datax)<-Names$`descr$V2`


#add subject and activity type as identifiers to df

datasub$V1<-factor(datasub$V1)
datax["Subject"]<-datasub
datay$V1<-factor(datay$V1)
levels(datay$V1)<-c("Walking","Walking upstairs","Walking downstairs","Sitting","Standing","Laying")
datax["Activity"]<-datay

#Calculating mean, grouped by Activity anbd Subject

tidy<-aggregate(datax[, 1:66], list(datax$Activity,datax$Subject), mean)
colnames(tidy)[1]<-"Activity"
colnames(tidy)[2]<-"Subject"

write.table(tidy,file="tidy.txt",row.name=FALSE)
#save(tidy,file="tidy.Rda")
