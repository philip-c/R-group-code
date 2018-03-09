## Feb 28, 2018 R group presentation 
## location: ESS-SIRC room
## Philip Chan

## references: 1. http://faculty.nps.edu/sebuttre/home/R/apply.html
##             2. http://adv-r.had.co.nz/Functionals.html

## dummy datasets used below:
## a. state.x77 (US state facts and figures datset)
## b. mtcars (motor trend car road tests dataset)
## c. barley (yield data from a Minnesota barley trial dataset)

rm(list=ls())


# intro and apply() ------------------------------------------------------------------

##'Apply' functions keep you from having to write loops
## to perform some operation on every row or
## every column of a matrix or data frame, or on every element in a list

(x <- state.x77)

# A: motivation example: for-loop style of finding column averages
avgs <- numeric(8)

for (i in 1:ncol(x)){
  avgs[i] <- mean(state.x77[,i])  
}


# In R, loop is comparatively slow, much more so in large datasets. 
# R is bad at looping. A more vectorized way to do this is
# to use the apply() function.

## R-style of finding column averages
apply(state.x77, MARGIN = 2, FUN = mean, na.rm = T)

# margin = {1,2}, where 1 => applying FUN by row; and 2 => applying FUN by column
# note: name-perserving
# special cases: colMeans(), ColSums(), rowMeans(), and rowSums()


## B: customizable function in the 3rd argument of apply()
f <- function(x) c(min(x), median(x), max(x))

output <- apply(state.x77, MARGIN = 2, FUN = f)

rownames(output) <- c("min","median","max")

# note: some structure is assumed for you



## C: additional arguements
apply (state.x77, 2, mean, trim = .10)

# equivalently....
apply (state.x77, 2, function(x)  mean(x, trim = .10))


## D: exceptions: data structure
(a <- matrix (c(5, 2, 7, 1, 2, 8, 4, 5, 6), 3, 3))

apply(a, 1, function(x) which(x == min(x))[1])

## note: the output is a list, which is unexpected.
## reason: which() returns a vector for the 2nd row, and R needs to generalize the output to 
## accomandate a size-3 object. It does so by using list structure. 



# lapply ------------------------------------------------------------------

## about: more general than apply(), works on list structure.
##       on data.frames, works like apply(), always assuming dimension = 2,...
##       which makes an implicit assumption on your data structure -- that it is
##       in "wide" format with column variables.

## idea: takes a function, applies it to each element in a list, 
##       and returns the results in the form of a list.


# internally...

lapply2 <- function(mylist, f, ...) {

   out <- vector("list", length(mylist))         # initialization

   for (i in seq_along(mylist)) {
     
     out[[i]] <- f(mylist[[i]], ...)     # use function f on the i'th object in x
   }

   out

 }


# like apply()
(avgs <- lapply(mtcars, mean))

# in-place modification with []
# note that the output and input dataset are the same structure -- no copying is done
mtcars[] <- lapply(mtcars, scale)



# sapply ------------------------------------------------------------------
## simplified lapply; same as
lapply(X, fun , simplify2array = T)

## idea: Simplfying the structure of lapply(), where possible

# A: list simplified to vector
(avgs <- sapply(mtcars, mean))

# B: list simplified to dataframe
(new.df <- sapply(mtcars, scale))

rownames(new.df) <- rownames(mtcars)


# tapply ------------------------------------------------------------------

# R's Excel pivot table
# when to use:  applying a function to subsets of a data

barley

# some examples

tapply (X = barley$yield, INDEX = barley$site, FUN = mean)
#tapply() returns a vector with one element for each unique value 
# of barley$site.

tapply (barley$yield, list (barley$year, barley$site), mean)




# other -------------------------------------------------------------------

# some use of lapply

# read all files of the same extension (.csv)
all.files <- lapply(dir("//.csv"), read.csv)

# extract the GDP column of from a list of many dataframes
list.of.GDP <- lapply(all.files, `[`, "GDP")
