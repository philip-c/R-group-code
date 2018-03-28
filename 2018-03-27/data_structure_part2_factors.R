## R group presentation
## March 28, 2018
## Philip Chan, ESS


## References: https://swcarpentry.github.io/r-novice-inflammation/12-supp-factors/
##             https://www.stat.berkeley.edu/classes/s133/factors.html

# factors....
# - used to represent categorical data
# - ordered or unordered 
# - stored as integers(!) with labels
# - can only contain a pre-defined set values, known as levels

rm(list=ls())
library('dplyr')


### 1. unordered factor - order defined alphabetically
fruits <- factor(c("banana", "apple", "orange", "apple"))

# levels = unique elements of a factor
nlevels(fruits)
levels(fruits)


### 2. ordered factor
fruits2 <- factor(fruits, levels = c("orange", "banana", "apple"), ordered=TRUE)

levels(fruits2)
min(fruits2)

as.numeric(fruits2)

# common error: converting factor to numeric
x <- factor(c(300, 200, 100, 0, 100))
levels(x)
as.numeric(x)

# use integer index to convert 
levels(x)[x] %>%    
  as.numeric()

# OR 
as.numeric(as.character(x)) 


### 3. some facts

### a. import
dat <- read.csv(file = 'sample.csv', stringsAsFactors = FALSE)

## b. common error 'invalid factor level'
iris2 <- iris

iris2[151,] <- c(1,2,3,4, "new flower")


# solution 

levels(iris2$Species) <- c(levels(iris2$Species), "new flower")
iris2[151,] <- c(1,2,3,4,"new flower")


### c.  NA as factor

iris2[152,] <- c(1,2,3,4, NA)
iris2$Species <- addNA(iris2$Species)



## d. factors are passed on
# droplevels()

iris_set <- iris[1:20, ]
levels(iris_set$Species)

droplevels(iris_set$Species)


## e. a numeric range as factor
str(mtcars)

mtcars2 <-  mtcars

mpg_level <- cut(mtcars2$mpg, breaks = c(10,20,30,40), 
                   labels  = c("low","medium","high"))

mtcars2$mpg_level <- mpg_level


aggregate(mtcars2[,c("hp","cyl")], 
          by = list(mtcars2$mpg_level), 
          FUN = median)

by(mtcars2[,c("hp","cyl")], mtcars2$mpg_level, FUN = summary) # wrapper for tapply


## f. plotting
plot(x = mtcars2$mpg_level, 
     y = mtcars2$cyl, 
     main = "plot of factors/categorical variable",
     xlab = "mpg level",
     ylab = "number of cylinders")


## g. use in lm
with(mtcars2, lm( hp ~ mpg_level + gear) )
