## R group presentation
## Philip Chan, ESS
## March 14, 2018

## Data Structure and Subsetting in R (part 1)
##
##
## References: http://adv-r.had.co.nz/
##             https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures/

## Overview:
##  1. atomic vectors
##  2. matrices
##  3. lists
##  4. data frames


# 0: see the structure of any object in R -------------------------------------

# Use typeof(), class(), length(), str() 
typeof(2.1)
class(2.1)
length(c(1,2,3,"hi"))

# str() provides a concise and practical summary

str(iris)



# 1: atomic vectors -------------------------------------------------------


# homogenous and the most basic structure in R
# 5 types (raw excluded), in order of most general to most specific:
#   character
#   complex
#   numeric
#   integer
#   logical
  


## A. Create
# c()
# numeric(n), logical(n), integer(n), character(n)

c(1,2,c(30,10))

str(c(1L,2L,3L))
str(c("a","b","c"))
c(TRUE, TRUE, FALSE)


## B. Interact
# mixed types
c(1L, 2L, 3L, 4.5)
c("a","b","c", 1, 2, 3)
c(TRUE, FALSE, 1, 2, 3.5)

# NA allowed and will always be coerced to the correct type
# NA_real_, NA_character, NA_integer


# coercion
as.logical(c(TRUE, FALSE, 6.2))
as.logical(c(TRUE, FALSE, 6.2, "ABC"))

as.numeric(c("AbC", 1L, 2L))


1L == "1"


## C. Subset
x <- c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

# a. positive integer
x[c(2, 6)]

# b. negative integer
x[-c(1,3,5,7)]
# mixed sign not allowed

# c. logical 
#     note the 'recycling' property
x[c(TRUE, FALSE)]

x[x > 40]

x[ x > 40 & x <= 80] # note difference with && and ||

x[c(TRUE, NA, FALSE)]



## D. Attributes (R's way of storing metadata)
## names(), class(), and dim() are special attributes with a named function

names(x) <- letters[1:10]
class(x) <- "integer"
dim(x) <- c(2,5)

# note: useful retention of names in sapply and lm objects 
lm1 <- lm(iris)
lm1$coefficients  #(Intercept, Sepal.Width, and so forth are name attributes)


## general attributes - can be anything
attr(x, "name of attribute") <- "description of the attribute"

# see all atributes with attributes()
attributes(x)


## Good practice to use names(), class(), and dim() instead of attr() when dealing with those special metadata



# 2: matrices -------------------------------------------------------------


## A. Create
matrix(1:100, nrow = 4, ncol = 5) -> my.mat

# note the order: by default byrow = F

# does not say explicitly say "matrix" as class
str(state.x77)



## B. Interact
# binary operators (+,- ,*, /) perform element-wise operation
# rbind()
# cbind()



## C. subset 

# a. [i,j] notation, structure simplifying where possible
my.mat[4,5]
my.mat[2:3, ]
my.mat[ ,2]                      #! structure simplified; the second column is returned in "flat" form
my.mat[-c(4:5)]                  #! structure simplified; the first 3 columns are returned in "flat" form
 
# b. [i,j] notation, structure perserving
my.mat[ ,2, drop = FALSE]        # still a matrix
my.mat[ ,-c(4:5), drop = FALSE]  # still a matrix

# b. with logicals
my.mat[c(TRUE, FALSE)]     # note the "flat" result
my.mat[c(TRUE, FALSE), ]   

# c. which() 
which(my.mat == 2)
which(my.mat == 2, arr.ind = T)   # with arr.ind = T the result is in [i,j] notation



## D. Attributes

# similiar to atomic vectors
#dimnames(m)
colnames(my.mat) <- c("A","B","C","D","E")
rownames(my.mat) <- c("row1","row2", "row3", "row4")
dim(my.mat)


attr(my.mat, "random matrix") <- "for testing"



## E. Array -- matrix with dimension => 2
array(1:100, dim = c(4,5, 3))




## end part 1
