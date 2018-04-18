### R group presentation
### Philip Chan, ESS
### April 18, 2018
### script 3

rm(list=ls())
library('dplyr')
library('broom')

### broom offers a convenient way to explore clustering methods


### construct dummy cluster data
set.seed(2014)
centers <- data.frame(cluster=factor(1:3), size=c(100, 150, 50), x1=c(5, 0, -3), x2=c(-1, 1, -2))
points <- centers %>% group_by(cluster) %>%
  do(data.frame(x1=rnorm(.$size[1], .$x1[1]),
                x2=rnorm(.$size[1], .$x2[1])))

library(ggplot2)
ggplot(points, aes(x1, x2, color=cluster)) + geom_point()


### implementation k means
points.matrix <- cbind(x1 = points$x1, x2 = points$x2)
kclust <- kmeans(points.matrix, 3)

# before
kclust

# after
tidy(kclust)
augment(kclust, points.matrix) %>%
  ggplot(aes(x1, x2)) + geom_point(aes( color = .cluster))
glance(kclust)



### exploratory data analysis

# build a model for each 1 <= k <= 9 
kclusts <- data.frame(k=1:9) %>% 
  group_by(k) %>% 
  do(kclust=kmeans(points.matrix, .$k))

# tidy() - get the estimated centers of each kmeans model
clusters <- kclusts %>%
  group_by(k) %>%
  do(tidy(.$kclust[[1]]))

# augment() - see how each input data is assigned (to clusters 1, 2, or 3) in each model
assignments <- kclusts %>%
  group_by(k) %>%
  do(augment(.$kclust[[1]], points.matrix))

# glance() - compare the fit of each model
clusterings <- kclusts %>%
  group_by(k) %>%
  do(glance(.$kclust[[1]]))

# graph the result of each model from assignments
p1 <- ggplot(assignments, aes(x1, x2)) +
  geom_point(aes(color = .cluster)) +
  facet_wrap(~ k)

p1
