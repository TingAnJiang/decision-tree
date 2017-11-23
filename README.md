# decision-tree

## 概述
這一過程將初始的包含大量資訊的資料集，按照一定的劃分條件逐層非類至不可再分或不需再分，充分產生樹。

在每一次分類中先找出各個可以做為分類變數的引數的所有可能劃分條件，再對每一個引數比較在各個劃分條件下所得的兩個分支的差異大小。選出使得差異最大的劃分條件作為該引數的最佳劃分；再將各個引數在最佳劃分下所得的兩個分支的差異大小進行比較，選出差異最大者作為該節點的分類變數，並採用該變數的最佳劃分。

比較差異大小的計算方法：信息熵(Entropy)、基尼係數(Gini index)

## 兩種使用最為普遍的決策樹演算法

1. C4.5決策樹(ID3的改進演算法) 
2. CART分類迴歸樹

--------------------------------------------------------------------------------

### ID3和C4.5
* ID3 演算法 (Iterative Dichotomiser 3)

ID3在建構決策樹過程中，以資訊獲利(Information Gain)為準則，並選擇最大的資訊獲利值作為分類屬性。[以下例子說明請參考此](https://read01.com/7K8yE3.html#.WZu8Tz4jHIU)

entropy公式：
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/entropy.JPG)

Information Gain 公式：
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/Information Gain.JPG)

![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/ID3-1.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/ID3-2.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/ID3-3.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/ID3-4.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/ID3-5.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/ID3-6.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/ID3-7.JPG)

-----------------------------------------------------------------------------

* C4.5 演算法

C4.5是ID3的升級版，C4.5演算法利用屬性的獲利比率(Gain Ratio)克服問題。

Gain Ratio公式:
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/gain ratio.JPG)
；![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/split1.JPG)

![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/C4.5-1.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/C4.5-2.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/C4.5-3.JPG)
![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/C4.5-4.JPG)

-----------------------------------------------------------------------------

### CART

以吉尼係數(Gini index)做為選擇屬性的依據。CART與ID3、C4.5演算法的最大相異之處是，其在每一個節點上都是採用二分法，也就是一次只能夠有兩個子節點，ID3、C4.5則在每一個節點上可以產生不同數量的分枝。

計算上和ID3非常相似，只是評估函數替換，熵換成吉尼係數、資訊獲利換成吉尼獲利，並挑選獲利最大做分割。[以下例子說明請參考此](https://read01.com/ykd8P.html#.WZ0A8z4jHIU)

(ps. Gini index 亦指 impurity)

Gini index公式：![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/gini index.JPG)

Gini gain公式：![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/Gini gain.JPG)

Example：

![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/CART-1.JPG)

在上述圖中，屬性有3個，分別是有房情況，婚姻狀況和年收入，其中有房情況和婚姻狀況是離散的取值，而年收入是連續的取值。拖欠貸款者屬於分類的結果。

假設現在來看有房情況這個屬性，那麼按照它劃分後的Gini指數計算如下

![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/CART-2.JPG)

而對於婚姻狀況屬性來說，它的取值有3種，按照每種屬性值分裂後Gini指標計算如下

![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/CART-3.JPG)

最後還有一個取值連續的屬性，年收入，它的取值是連續的，那麼連續的取值採用分裂點進行分裂。如下

![](D:/R project/Statistical ML lab (NCCU)/dicision tree for discuss/entropy/CART-4.JPG)

根據這樣的分裂規則CART算法就能完成建樹過程。

-------------------------------------------------------------------------------

## 剪枝

建樹完成後就進行第二步了，即根據驗證數據進行剪枝。在建樹過程中，可能存在Overfitting，許多分支中反映的是數據中的異常，這樣的決策樹對分類的準確性不高，那麼需要檢測並減去這些不可靠的分支。決策樹常用的剪枝有事前剪枝和事後剪枝。

* 事前剪枝：根據一些原則及早的停止樹增長，如樹的深度達到用戶所要的深度、節點中樣本個數少於用戶指定個數、不純度指標下降的最大幅度小於用戶指定的幅度等。(缺點：可能過度修剪(over-pruning)、門檻值設定不易)

* 事後剪枝：通過在完全生長的樹上剪去分枝實現的，通過刪除節點的分支來剪去樹節點，可以使用的後剪枝方法有多種，比如：代價複雜性剪枝(cost complexity prune)、最小誤差剪枝(reduced error prune)、基於錯誤的剪枝(Error Based Pruning)等等。[詳細說明請參考此後段](http://www.cnblogs.com/starfire86/p/5749334.html)

C4.5採用事後剪枝(基於錯誤的修剪)，以比較一個父節點和其子節點的純度。[參考](http://www.plsyard.com/post-pruning-in-c45/)

CART算法採用事後剪枝(代價複雜性剪枝法)。複雜度參數愈小會導致樹越複雜(大)，並且可能overfitting，而複雜度參數愈大則反之。 [林軒田老師課程,1:27開始](https://www.youtube.com/watch?v=uvGC_Y0EYiA&list=PLXVfgk9fNX2IQOYPmqjqWsNUFl2kpk1U2&index=36) 


------------------------------------------------------------------------------

## R demo

資料前置
```{r warning=FALSE, message = FALSE}
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
```
```{r}
# 確認各資料集0,1出現比例

# 原始train資料集0,1分佈比例
prop.table(table(data$Survived)) * 100
# 切割過後的 training data 0,1分佈比例
prop.table(table(data_train$Survived)) * 100
# 切割過後的 testing data 0,1分佈比例
prop.table(table(data_test$Survived)) * 100
```

### CART 
開始種樹
```{r warning=FALSE}
library(rpart)
library(rpart.plot)
formula_Tit <- Survived~.
rp_Cla <- rpart(formula_Tit, data_train, method = "class", minsplit = 20, cp = 0.01, xval = 10) #預設值
#minsplit表示每個節點中所包含樣本數的最小值，cp是複雜度參數
rp_Cla$cptable
cp <- rp_Cla$cptable[which.min(rp_Cla$cptable[, "xerror"]), "CP"] #選xerror最小的cp
cp
rp_Cla <- prune(rp_Cla, cp = cp)
rp_Cla
rpart.plot(rp_Cla)
```

測試
```{r}
pre_Cla <- predict(rp_Cla, data_test, type = "class", cp = cp)
table(data_test$Survived, pre_Cla)

#accurancy
(sum(diag(table(data_test$Survived, pre_Cla))) / sum(table(data_test$Survived, pre_Cla)))
```


### C4.5

開始種樹


```{r warning=FALSE, message = FALSE}
library(RWeka)
data_train$Survived <- as.factor(data_train$Survived) #將Survived改為因數型，使J48()函數可辨別
formula_Tit <- Survived~.
C45 <- J48(formula_Tit, data_train) #先使用預設值種樹
C45 #這棵樹種起來非常大顆
```
測試
```{r}
pre_C45 <- predict(C45, data_test)
table(data_test$Survived, pre_C45)

#accurancy
(sum(diag(table(data_test$Survived, pre_C45))) / sum(table(data_test$Survived, pre_C45)))
```
修剪樹(綜合建模找參數)

補充:Weka的參數 `WOW(J48)`

* -C : pruning confidence  (default 0.25)

* -M : minimum number of instances per leaf  (default 2)
```{r}
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
```
```{r}
C45 <- J48(formula_Tit, data_train, control = Weka_control(C = 0.05, M = 10))
C45
plot(C45)
```

測試
```{r}
pre_C45 <- predict(C45, data_test)
table(data_test$Survived, pre_C45)

#accurancy
(sum(diag(table(data_test$Survived, pre_C45))) / sum(table(data_test$Survived, pre_C45)))
```




-------------------------------------------------------------------------------

## reference

* [C4.5決策樹算法](https://read01.com/7K8yE3.html#.WZu8Tz4jHIU)

* [決策樹之CART算法](https://read01.com/ykd8P.html#.WZ0A8z4jHIU)

* [《機器學習實戰》基於資訊理論的三種決策樹算法(ID3,C4.5,CART)](https://read01.com/xARP30.html#.WZ0BfT4jHIU)

* [Weka_control](https://rdrr.io/cran/RWeka/man/Weka_control.html)

* [決策樹（主要針對CART）的生成與剪枝](https://kknews.cc/zh-tw/other/jeb3nq.html)

* [决策树-剪枝算法](http://www.cnblogs.com/starfire86/p/5749334.html)

* [決策樹分析 簡禎富講座教授](file:///C:/Users/anne_2/Downloads/%E7%B0%A1%E7%A6%8E%E5%AF%8C%E8%80%81%E5%B8%ABCh04%20%E6%B1%BA%E7%AD%96%E6%A8%B9%E5%88%86%E6%9E%90.pdf)

* [决策树C4.5算法里的后剪枝](http://www.plsyard.com/post-pruning-in-c45/)

