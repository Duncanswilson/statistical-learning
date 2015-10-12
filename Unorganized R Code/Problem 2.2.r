library(class)
##Read in Training Data
X <- as.matrix(read.table(gzfile("zip.train.gz")))
X.train <- X[, -1]
y.trainTwos <- X[, 1] == 2
y.trainThrees <- X[, 1] == 3
y.trainBoth <- y.trainTwos | y.trainThrees

##Read in Test Data
X <- as.matrix(read.table(gzfile("zip.test.gz")))
X.test <- X[, -1]
y.testTwos <- X[, 1] == 2
y.testThrees <- X[, 1] == 3
##y.testBoth <- y.testTwos | y.testThrees

###Linear Regression for 3's
L3 <- lm(y.trainThrees ~ X.train)
yhatTrainThrees <- (cbind(1, X.train) %*% L3$coef) >= 0.5 
L3.trainError <- mean(yhatTrainThrees != y.trainThrees)
yhatTestThrees <- (cbind(1, X.test) %*% L3$coef) >= 0.5 
L3.testError <- mean(yhatTestThrees != y.testThrees)

###Linear Regression for 2's
L2 <- lm(y.trainTwos ~ X.train)
yhatTrainTwos <- (cbind(1, X.train) %*% L2$coef) >= 0.5 
L2.trainError <- mean(yhatTrainTwos != y.trainTwos)
yhatTestTwos <- (cbind(1, X.test) %*% L2$coef) >= 0.5 
L2.testError <- mean(yhatTestTwos != y.testTwos)

###Sum up total error
L.totalTrainError <- L2.trainError + L3.trainError
L.totalTestError <- L2.testError + L3.testError

###-----------------------------------------------------------### 
##K-nearest neighbors
k <- c(1,3,5,7,15)
k.threeError <- k.twoError <- c(NA,NA,NA,NA,NA)

### K-NN twos against all digits 
for(i in 1:length(k)){
  yhatTwos <- knn(X.train, X.test, y.trainTwos, k[i])
  k.twoError[i] <- mean(yhatTwos != y.testTwos)
}

### K-NN threes against all digits 
for(i in 1:length(k)){
  yhatThrees <- knn(X.train, X.test, y.trainThrees, k[i])
  k.threeError[i] <- mean(yhatThrees != y.testThrees)
}

###Sum of error
K.totalError <- k.twoError + k.threeError

##Make and print table 
totalError = matrix(c(L2.trainError,L2.testError,L3.trainError,L3.testError,L.totalTrainError, 
                      L.totalTestError, k.twoError, k.threeError, K.totalError), ncol = 1) 
colnames(totalError) = "Rate of Error"
rownames(totalError) = c("L.R. with Twos Train","L.R. with Twos Test","L.R. with Threes Train" ,
                         "L.R. with Threes Test","L.R. Total Train Error","L.R. Total Test Error", 
                         paste0("k-NN for Twos with k =", k), paste0("k-NN for Threes with k =", k), 
                         paste0("k-NN for both with k =", k))
totalError
