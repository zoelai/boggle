# Q8 in Chapter 9
# OJ

# loading libraries
library(ISLR2)
library(e1071)

# Create a training set containing a random sample of 800 observations, 
# and a test set containing the remaining observations.

set.seed(3463)
(n <- nrow(OJ))
trainIndex <- sample(1:n, 800)
train <- OJ[trainIndex,]
test <- OJ[-trainIndex,]

###########################################################################
######################    Linear   Approach ###############################
###########################################################################

# Fit a support vector classifier to the training data using cost = 0.01, 
# with Purchase as the response and the other variables as predictors. 
svm.fit <- svm(Purchase~., data = train, kernel = "linear", cost = 0.01)
summary(svm.fit)

# What are the training and test error rates
svm.train.pred <- predict(svm.fit, train)
svm.test.pred <- predict(svm.fit, test)
table(svm.train.pred, train$Purchase)
# train error rate:
(79 + 60)/(427 + 79 + 60 + 234) #  0.17375
table(svm.test.pred, test$Purchase)
(20 + 22)/(144 + 20 + 22 + 84) # 0.1555556

# Find the best cost of the linear model 


# Use the tune() function to select an optimal cost. 
# Consider values in the range 0.01 to 10.
cost_seq <- seq(0.01, 10, by=0.5)
svm.tune <- tune(svm, Purchase~., data = train, kernel = "linear", ranges = list(cost = cost_seq))
summary(svm.tune)

# we get the lowest error when cost = 0.51

svm.bestFit <- svm(Purchase ~., data = train, kernel = "linear", cost = 0.51)
svm.train.best.pred <- predict(svm.bestFit, train)
svm.test.best.pred <- predict(svm.bestFit, test)
(train.error <- mean(svm.train.best.pred != train$Purchase)) # 0.1725
(test.error <- mean(svm.test.best.pred != test$Purchase)) # 0.1518519

###############################################################################
####################      radial     Approach   ###############################
###############################################################################

svm.fit.radial <- svm(Purchase ~., data = train, kernel = "radial", cost = 0.01)
summary(svm.fit.radial)

# Tune the cost
cost_seq <- seq(0.01, 10, by=0.5)
svm.radial.tune <- tune(svm, Purchase ~ ., data = train, kernel = "radial", ranges = list(cost = cost_seq))
summary(svm.radial.tune) # cost = 0.51

# build the model with the best cost
svm.fit.radial <- svm(Purchase ~., data = train, kernel = "radial", cost = 0.51)
svm.radial.train.pred <- predict(svm.fit.radial, train)
svm.raial.test.pred <- predict(svm.fit.radial, test)
(train.error <- mean(svm.radial.train.pred != train$Purchase)) # 0.15875
(test.error <- mean(svm.raial.test.pred != test$Purchase)) # 0.1444444

###############################################################################
####################      Polynomial  Approach   ##############################
###############################################################################

svm.fit <- svm(Purchase ~., data = train, kernel = "polynomial", cost = 0.01, degree=2)
summary(svm.fit)

# Tuning the cost
cost_seq <- seq(0.01, 10, by=0.5)
svm.poly.tune <- tune(svm, Purchase ~ ., data = train, kernel = "polynomial", ranges = list(cost = cost_seq), degree = 2)
summary(svm.poly.tune) # best cost = 8.51

# build the model with the best cost
svm.poly.bestFit <- svm(Purchase ~., data = train, kernel = "polynomial", cost = 8.51)
svm.poly.train.pred <- predict(svm.poly.bestFit, train)
svm.poly.test.pred <- predict(svm.poly.bestFit, test)
(mean(svm.poly.train.pred != train$Purchase)) # train error 0.1475
(mean(svm.poly.test.pred != test$Purchase)) # test error 0.1777778
################################################################################

#  which approach seems to give the best results on this data?

# test error of the linear svm model: 0.1518519
# test error of the radial svm model: 0.1444444
# test error of the polynomial svm model: 0.1777778

# The radial approach has the best result.


