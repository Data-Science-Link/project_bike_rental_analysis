year_report <-read.csv('./Data/year_report.csv', stringsAsFactors = FALSE)

library(dplyr)
library(viridis)
year_report = year_report %>% mutate(Rides_per_Day= round(year_report$Rides*20/year_report$Days,0),
                       text = paste("Year: ", Year,  
                                    "\nNumber of Docks: ", Docks, 
                                    "\nRide per Day: ", Rides_per_Day, sep="")) %>% 
  filter(Year!=2013)

vir_7 <- magma(n=10)
seecol(vir_7)

ggplot(year_report,aes(x=Year, y=Rides_per_Day,fill=Year)) + 
  geom_bar(stat='identity',alpha=.75) +
  scale_fill_viridis(option='plasma') +
  theme_classic() + 
  ylab('Daily Rides') +
  xlab('Year')
         
ggplot(year_report,aes(x=Year, y=Docks,fill=Year)) + 
  geom_bar(stat='identity',alpha=.75) +
  scale_fill_viridis(option='plasma') +
  theme_classic() + 
  ylab('Docks') +
  xlab('Year')
