### R group presentation
### Philip Chan, ESS
### April 18, 2018
### script 2

rm(list=ls())
library('dplyr')
library('broom')


### REFRENCE: https://cran.r-project.org/web/packages/broom/vignettes/kmeans.html


### broom's power lies in its ability to compare different models



### A. evaluate models ####

# construct 2 linear models
lmfit <-  lm(Sepal.Width ~  Sepal.Length +  Petal.Width + Petal.Length , data = iris)
lmfit2 <- lm(Sepal.Width ~  Sepal.Length                               , data = iris)

## ANOVA for 1 model
# before
(single.anovaTest <- anova(lmfit))
# after
tidy(single.anovaTest)


## ANOVA for 2 models
# before
(double.anovaTest <- anova(lmfit, lmfit2))
# after
tidy(double.anovaTest)



### B. fitting multiple models ####

# construct multple models
list_model <- list(
  model1 = lm(Sepal.Length ~  Sepal.Width +  Petal.Width + Petal.Width  , data = iris),
  model2 = lm(Sepal.Length ~  Sepal.Width +  Petal.Width                , data = iris),
  model3 = lm(Sepal.Length ~  Sepal.Width                               , data = iris)
  
)


# compare model performance with ggplot

library(ggplot2)
list_model %>%
  lapply(., glance) %>%
  do.call(rbind,.) %>%
  mutate(model = names(list_model)) %>%
  
  ggplot(data = ., aes(x = model, y = AIC)) +
  geom_bar(stat = "identity")
