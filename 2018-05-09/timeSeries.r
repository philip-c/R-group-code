## CLEAR ALL ##
rm(list = ls())

library('TTR')              # MA Smoothing
library('forecast')         # tsclean()
library('tseries')          # Time Series Object
library('depmixS4')         # HMM
library('quantmod')         # Technical Analysis (Bollinger Bands plot)

## PARAMETERS ##

# Time Series #
t <- 0:100
sig1 <- 1
sig2 <- 100
m1 <- 0
m2 <- 0

# Smoothing #
MA_Steps <- 5


## GENERATE A TIME SERIES
set.seed(601)
x1 <- rnorm(n = length(t) - 1, mean = m1,  sd = sqrt(sig1))
x2 <- rnorm(n = length(t) - 1, mean = m2,  sd = sqrt(sig2))
x <- c(x1, x2)
x <- tail(c(0, cumsum(x)),-50)                               # Cumulative Sum
x[13] <- x[123]*0.1
x[89] <- NA

tsObj = ts(x)
tsObj <- tsclean(tsObj, replace.missing = TRUE)

any(is.na(tsObj))


## MA Smoothing ##
clean_y <- ma(tsObj, order = MA_Steps)            # The wider MA_steps, the smoother the series


# Plots
layout(1:1)
plot(1:length(tsObj), tsObj, type = "l")
lines(clean_y, type = 'line', col = 'red')


# Technical Analysis Plot
chartSeries(
  tsObj,
  #type = c(),
  theme = chartTheme("white"),
  TA = c(addBBands())
)

# Hidden Markov Model
mod1 <- depmix(tsObj ~ 1, data = data.frame(tsObj), nstates = 1)
mod1 <- fit(mod1, verbose = TRUE)
print(mod1)

mod2 <- depmix(tsObj ~ 1, data = data.frame(tsObj), nstates = 2, trstart = runif(4))         # two states model has a better likelihood
mod2 <- fit(mod2, verbose = TRUE)
print(mod2)


# Regimes
post_probs <- posterior(mod2)
layout(1:2)
plot(1:length(tsObj), tsObj, type = "l")
lines(clean_y, type = 'line', col = 'red')
matplot(post_probs[,-1], type='l', main='Regime Posterior Probabilities', ylab='Probability')
legend(x='topright', c('Low Volatility','High Volatility'), fill=1:2, bty='n')