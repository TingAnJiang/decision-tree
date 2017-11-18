library(magrittr)
data <- read.csv("data_train.csv")

var <- c("Pclass","Sex","Age","SibSp","Parch","Fare",
         "Embarked","Title","FsizeD","Child","Mother")

data[1:10,var] %>% knitr::kable()

# 將原本的train資料再切割成training跟testing
# 利用caret套件裡的createDataPartition函式
# 依train$Survived欄位的0,1分佈比例，等比例做資料集切割

library(caret)
set.seed(200)
inTraining <- createDataPartition(data$Survived, p = .8, list = FALSE)
data_train <- data[ inTraining,c("Survived",var)]
data_test <- data[-inTraining,c("Survived",var)]


# 確認各資料集0,1出現比例
# 原始train資料集0,1分佈比例
prop.table(table(data$Survived)) * 100
# 切割過後的 training data 0,1分佈比例
prop.table(table(data_train$Survived)) * 100
# 切割過後的 testing data 0,1分佈比例
prop.table(table(data_test$Survived)) * 100

#CART
#------------------開始種樹--------------------
library(rpart)
library(rpart.plot)
formula_Tit <- Survived~.
rp_Cla <- rpart(formula_Tit, data_train, method = "class", minsplit = 20, cp = 0.01, xval = 10) #預設值 #minsplit表示每個節點中所包含樣本數的最小值，cp是複雜度參數
rp_Cla$cptable
cp <- rp_Cla$cptable[which.min(rp_Cla$cptable[, "xerror"]), "CP"] #選xerror最小的cp
rp_Cla <- prune(rp_Cla, cp = cp)
rp_Cla
summary(rp_Cla)
rpart.plot(rp_Cla)

#--------測試-----------
pre_Cla <- predict(rp_Cla, data_test, type = "class", cp = cp)
pre_Cla
table(data_test$Survived, pre_Cla)

(sum(diag(table(data_test$Survived, pre_Cla))) / sum(table(data_test$Survived, pre_Cla)))


#---------------綜合建模--------------
minsplit <- c(10, 20, 30, 50)
xval <- c(10, 30, 50, 100, 150) #xval若為0則代表沒有validation(也不會有xerror)
pre_false <- matrix(0, 4, 5)
cp <- matrix(0, 4, 5)

for (i in 1:4) {
  for (j in 1:5) {
    rp_Cla <- rpart(formula_Tit, data_train, method = "class", minsplit = minsplit[i], xval = xval[j], cp = 0.01)
    cp[i,j] <- rp_Cla$cptable[which.min(rp_Cla$cptable[, "xerror"]), "CP"]
    rp_Cla <- prune(rp_Cla, cp = cp[i,j])
    pre <- predict(rp_Cla, data_test, type = "class")
    pre_false[i,j] <- sum(pre != data_test$Survived)
  }
}
cp
dimnames(pre_false) <- list(minsplit, xval)
pre_false
cp
#取預設值就有一樣好的效果


#C4.5
#------------------開始種樹--------------------
library(RWeka)
data_train$Survived <- as.factor(data_train$Survived) #將Survived改為因數型，使J48()函數可辨別
formula_Tit <- Survived~.
C45 <- J48(formula_Tit, data_train) #先使用預設值種樹
C45 #這棵樹種起來非常大顆
summary(C45)
plot(C45)

#--------測試-----------
pre_C45 <- predict(C45, data_test)
pre_C45
table(data_test$Survived, pre_C45)

(sum(diag(table(data_test$Survived, pre_C45))) / sum(table(data_test$Survived, pre_C45)))


#---------------綜合建模--------------
C <- c(0.01, 0.05, 0.1, 0.25)
M <- c(2, 5, 10, 20, 30)

pre_false <- matrix(0, 4, 5)

for (i in 1:4) {
  for (j in 1:5) {
    pre <- predict(J48(formula_Tit, data_train, control = Weka_control(C = C[i], M = M[j])), data_test)
    pre_false[i,j] <- sum(pre != data_test$Survived)
  }
}


dimnames(pre_false) <- list(C, M)
pre_false

C45 <- J48(formula_Tit, data_train, control = Weka_control(M = 10, C = 0.05))
C45
plot(C45)