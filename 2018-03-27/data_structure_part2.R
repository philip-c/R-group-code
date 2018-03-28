
# factors
# lists
# data frames

# 3. lists ----------------------------------------------------------------

## like containers: contents are not restricted to atomic type
## the elements of a list can be anything 


## A. Create
list(food = c("eggs","bread","cheese"), 
     sub_list = list(), 
     some_numbers = 1:10
)                  -> my.list -> list1

# as.list
# length()
# is.recursive()


## B. Interact

# combining lists
c(list1, list2,...)

# add with $


# coercion
c(my.list, v)    # list is more general

list(my.list, v)

c(my.list, list(v))


## C. Subset
# `[`      -- structure preserving
# `[[`     -- structure simplifying
# `$`      -- a shorthand operator, where x$y == x[["y", exact = FALSE]]


# `[` 
my.list[1]
my.list['food']

# `[[` 
my.list[[1]]
my.list[["food"]]

# `$` 
my.list$food
my.list$fo

# caution
vars <- "food"
my.list$vars 



# 4: data frames ----------------------------------------------------------
# a list, a matrix, "rectangular"


## A. Create (by column)
(my.df <- data.frame(numbers = c(10:1), letters = letters[1:10]))

# as.data.frame()
# is.recursive()

## B. Interact
cbind()
rbind()

my.df$newColumn <- NA
my.df["newColumn2"] <- "column 2" 
my.df[,"newColumn3"] <- "column 3"


## C. Subset

# `[`  (as list)
my.df[1]              
my.df['numbers']           

# `[[` 
my.df[[1]]
my.df[['numbers']]

# `$` 
my.df$numbers


# [i,j] (as.matrix)
my.df[ 1:5 , 2 ]



# logical
my.df[ my.df$numbers > 7 & my.df$letters %in% c("a","b","c") ,  ] # note the equivalent to which()


# subset() 
subset(  my.df,  numbers > 7 & letters %in% c("a","b","C"),  select = c(numbers, letters:newColumn2)  )





