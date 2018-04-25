## Aliou Mballo, ESS 
## R group presentation
## April 25, 2018

setwd("/Users/mballo/Dropbox/R_Group_FAO")

data=read.csv("data.csv", header=T, sep=",", row.names=1)
View(data)

#These data are from FAOSTAT and cover only countries that have all the information on
#production of maize, area_harvested for maize, imports for maize and rural population
#The data are for year 2010

#Let's check the outliers for each variable
par(mfrow=c(2,2))
boxplot(data$Production, col="blue")
boxplot(data$Area_harvested, col="red")
boxplot(data$Imports)
boxplot(data$Rural_pop, col="green")

#Let's check the outliers when we crossed production variable and the other
boxplot(data$Area_harvested*data$Production, col="blue")
boxplot(data$Imports*data$Production)
boxplot(data$Rural_pop*data$Production)

#Let's use the logarithm to deflate our variables
data=log(data+1)

###We would like to know what determine the maize production between the following variables: area harvested
#imports and rural population.

##Our model will be: production(i)=Beta(1)area_harvested(i) + Beta(2)imports(i) + Beta(3)Rural_population (i)+ Epsilon(i)

#Let's remember that the estimation of the coefficients is: hat(Beta)=(X'X)^(-1)X'Y

###Let's visualize the dependant variable and the other
par(mfrow=c(1,1))
plot(Production~Area_harvested, data=data, xlab="Area_harvested", ylab="Production", col="blue")
plot(Production~Imports, data=data, xlab="Imports", ylab="Production")
plot(Production~Rural_pop, data=data, xlab="Rural population", ylab="Production")

#Let's check the correlation between our variables
cor(data)
View(cor(data))

##Let calculate the coefficients manually
#Here we will use the matrix multiplication, the function matrix transpose and the reverse matrix function solve
#We are not going to consider the intercept here. Otherwise, we will need to add a variable with 1 everywhere
data_bis=as.matrix(data.frame(data, row.names=NULL), dimnames=NULL)
coef=solve(t(data_bis[,2:4])%*%data_bis[,2:4])%*%(t(data_bis[,2:4])%*%data_bis[,1])
coef


##Let run our model using lm function
model1=lm(Production~Area_harvested+Imports+Rural_pop, data=data)
summary(model1)

#If you want the model without intercept, you add -1
#For example
model_without_intercept=lm(Production~Area_harvested+Imports+Rural_pop-1, data=data)
summary(model_without_intercept)

#Here the estimations are the same than what we got from the manual calculation using the matrix

#Here the model is performed meaning it calculated the inverse of X'X. We can check that during the validation
#it is because the arguments "singular.ok" TRUE by default meaning a singular fit is not an error

#In the model, it is shown that the rural population does not influence the production of maize
#The residual standard deviation is 0.8363
#The R square that give the the share of the dependant variable explained by the independant one
#We can say 93.8% of the production is explained by the model.

coefs=model1$coefficients #for the coefficients
res1=model1$residuals #to have the residuals

###Analysis of the residuals

#Let's check the outliers in the models by using the studentalized residuals for each individual i which are
#the standardized residuals but where the variance of residuals is calculated without considering the element i
plot(rstudent(model1), pch=".", ylab="Studentilazed residuals")
abline(h=c(-2,2))

#Let's check the homocedasticity assumption of the errors. For that, we are going to use a function called "lowess" 
#Cleveland, 1979, tha calculate the absolue value of the residuals with an estimation of the trend of the residuals.
#If we noticed a monotonous trend, we might suspect heterocedasticy of the residuals. 
#We rae going to drawn the lowess line in the graph we already made for the outliers
lines(lowess(rstudent(model1)))

#We notice some countries like Tajikistan, Cabo Verde and Botswana seems to be outliers
#and can influence the model, we might need to take more attention wiht them and decide whether or
#not we keep them in the analysis

#Normality test (let's use Kolmogorov-Smirnov)
ks.test(res1,"pnorm", mean=0, sd=1)
plot(model1, which=2, sub="", main="")



##Let's check influential observation
#An influential observation is an observation that, if we remove it, will bring big variation
#in the estimation of the coefficients (Cook, 1977). We will compare the statistics with
#F(p,n-p)(0.1) as desirable threshold and F(p,n-p)(0.5) as worrying threshold.
plot(cooks.distance(model1),type="h",ylab="Cook distance")
abline(h=c(2*3/nrow(data), 3*3/nrow(data)))

plot(influence(model1)$hat, type="h", ylab="hii")
abline(h=c(2*3/nrow(data), 3*3/nrow(data)))

#Comparison of two models
#Let's do a model removing the variable "rural population". We are going to perform a Fisher test
model2=lm(Production~Area_harvested+Imports, data=data)
summary(model2)

res2=model2$coefficients

Fish=((sum((res2)^2)-sum((res1^2)))/(sum(res1)^2))*((nrow(data)-3-1)/2)
Fish>qf(0.5,2,nrow(data)-3-1)

#The calculated quantile is greater than the calculated Fisher, meaning that the second model is better than the first
#one in terms of estimations

#Something really important: depending whether you want to predict or just estimate, you will select one of the model

#Let's do the test using the Chow statistic to see the stability of the model 1.
install.packages("strucchange")
library("strucchange")
sctest(model1, type="Chow", point=75)
#The p-value is 0.042 meaning the model is not stable

#Let's do some predictions
#To do that, we will need to divide our data base into two. So we are going to use the first 130 rows for the estimations
#And the 33 remaining for prediction

model3=lm(Production~Area_harvested+Imports+Rural_pop, data=data[1:130,])
predict1=predict(model3,data[131:163,])
predict_comparison=cbind(data[131:163,1],predict1)
View(predict_comparison)


