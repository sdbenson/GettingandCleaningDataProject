library(reshape2)

subject_test=read.table("subject_test.txt",sep="")
X_test=read.table("X_test.txt",sep="")
Y_test=read.table("Y_test.txt",sep="")


subject_train=read.table("subject_train.txt",sep="")
X_train=read.table("X_train.txt",sep="")
Y_train=read.table("Y_train.txt",sep="")


activity_labels=read.table("activity_labels.txt",sep="")
features=read.table("features.txt",sep="")
features_info=read.table("features_info.txt",sep="")

labs=paste(features [,2])
names(X_train)=labs
names(X_test)=labs
names(activity_labels)=c("V1","activity")
names(subject_test)="subject"
names(subject_train)="subject"
meanstdfeatures=grep(("-mean|std"),labs)
meanstdfeaturesname=grep(("-mean|std"),labs,value=TRUE)
X_test_meanstd=X_test[,meanstdfeatures]
X_train_meanstd=X_train[,meanstdfeatures]
XY_train=cbind(subject_train,Y_train,X_train_meanstd)
XY_test=cbind(subject_test,Y_test,X_test_meanstd)
XY=rbind(XY_train,XY_test)
MergeXY=merge(activity_labels,XY,sort=FALSE)
MergeXY$V1=NULL

molten=melt(MergeXY,id=c("subject","activity"))

finaloutput=dcast(molten,subject + activity ~ variable,fun.aggregate=mean)