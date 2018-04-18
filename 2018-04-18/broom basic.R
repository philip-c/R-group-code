### R group presentation
### Philip Chan, ESS
### April 18, 2018
### script 1

rm(list=ls())

### INTRODUCTION
### Why use broom?

### base R's summary and print of models are messy (also not in dataframe format)
lmfit <- lm(mpg ~ wt, mtcars)
lmfit
summary(lmfit)

### The output of the tidy(), augment(), and glance() functions summarizes
### different data of the output, and is always a data frame.
### Unlike base R, broom's output never has rownames. This ensures that 
### you can combine it with outputs without fear of losing information
### (rownames have to be unique in R).

### What can be used with broom?
### Works with a wide range stats functions: lm, nls, arima, h.test,... 
### ...see the 3rd reference, page 34


### REFERENCES
### 1. https://cran.r-project.org/web/packages/broom/vignettes/broom.html
### 2. https://cran.r-project.org/web/packages/broom/vignettes/broom_and_dplyr.html
### 3. https://opr.princeton.edu/workshops/Downloads/2016Jan_BroomRobinson.pdf



# 1. broom on regression models  --------------------------------------------------

### A. LINEAR MODEL  ####

# dummy linear model
lmfit <- lm(mpg ~ wt, mtcars)
lmfit
summary(lmfit)

## to get specific information, have to access the object (a list) with $
## which can be confusing.

## for specific information of the model project, there're functions

# get coefficients
coef(lmfit) # or lmfit$coef

# get residuals
residuals(lmfit)

# fitted values
fitted.values(lmfit)

## moreover, they're named vectors and viewing them isn't so nice.


### prettify model outputs using broom
library('broom')

# tidy() - summarizes coefficient information
tidy(lmfit) 

# augment() - summarized observation-level information, retaining original input data
head( augment(lmfit) )


# glance() - returns 1 row with goodness of fit info
glance(lmfit)



### B. GENERAL LINEAR MODEL   ####

# dummy model
glmfit <- glm(am ~ wt, mtcars, family="binomial")
glmfit

# before
summary(glmfit)

# after
tidy(glmfit)
head(augment(glmfit))
glance(glmfit)



### C. ARIMA MODEL ####

# dummy data
times <- 1:100
myts <- times + 4*rnorm(100)
myts <- ts(myts, start=c(2001), end=c(2100), frequency=1)
plot(myts)

# dummy model
ts.model <- stats::arima(myts, order = c(3,0,0))

# before
summary(ts.model)

# after
tidy(ts.model)
glance(ts.model)


# 2: broom on hypothesis tests ----------------------------------------------------------------

### A.  CORRELATION TEST ####

# dummy data
x <- 1:10
y <- 10:1
plot(1:10, x, type = "l", col = "red")
lines(1:10, y, col = "blue")

# apply test
ct <- cor.test(x, y, method = "pearson")

# before
ct

# after
tidy(ct)


### B.  T TEST ####

# dummy data
sample1 <- rexp(100, rate = .5)
sample2 <- rnorm(100, mean = 4, sd = 0.5)
plot(1:100, sample1, col = "blue", pch = 19)
points(1:100, sample2, col = "orange", pch = 19)

# apply test
tt <- t.test(sample1, sample2)

# before
tt

# after
tidy(tt)
glance(tt)


### C.  ACF ####

# dummy data
times <- 1:100
myts <- times + 4*rnorm(100)
myts <- ts(myts, start=c(2001), end=c(2100), frequency=1)
plot(myts)

# apply function
p <- acf(myts)

# before
summary(p)
p

# after
tidy(p)

 
### D.  Box test ####

# apply test
BT <- Box.test(myts)

# before
BT

# after
tidy(BT)

