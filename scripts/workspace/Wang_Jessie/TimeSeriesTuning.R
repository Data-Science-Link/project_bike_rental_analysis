library(forecast)

citi_ts <- citibike <-read.csv('timeseries.csv')
revenue_ts <- citibike <-read.csv('revenuets.csv')
rides.ts <- as.ts(citi_ts$counter) 
rev.ts <- as.ts(revenue_ts$Membership.and.Usage) 

auto.arima(rides.ts)
auto.arima(rev.ts)

ridestraining <- subset(rides.ts, end=length(rides.ts)-516)
ridestest <- subset(rides.ts, start=length(rides.ts)-515)

rides.train <- Arima(ridestraining, order=c(5,1,2),
                    seasonal=c(1,0,1,7))
rides.train %>%
  forecast(h=60) %>%
  autoplot() + autolayer(ridestest) 

rides_results_test <- Arima(ridestest, model=rides.train )
accuracy(rides_results_test)
qqnorm(rides_results_test$residuals)

forecast(ridestraining, h = 60)

forecast_rides <- Arima(rides.ts,model=rides.train)

plot(forecast(forecast_rides,h=365))

forecast_rides = data.frame(forecast(forecast_rides,h=365))
##### forecast 




############################################################################
revtraining <- subset(rev.ts, end=length(rev.ts)-9)
revtest <- subset(rev.ts, start=length(rev.ts)-8)

rev.train <- Arima(revtraining, order=c(5,1,2),
                    seasonal=c(1,0,1,1), lambda=0)
rev.train %>%
  forecast(h=8) %>%
  autoplot() + autolayer(revtest)

rev_results_test <- Arima(revtest, model=rev.train )
accuracy(rev_results_test)

qqnorm(rev_results_test$residuals)
