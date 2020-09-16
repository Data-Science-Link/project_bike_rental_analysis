# Data Science for the SchWIN

## Table of Contents
- [Background](#background)
- [Objective](#objective)
- [Data Processing and Validation](#data-processing-and-validation)
- [Exploratory Data Analysis](#exploratory-data-analaysis)
- [Modeling](#modeling)
	- [Revenue Forecasting](#revenue-forecasting)
	- [Sponsorship or Advertising](#sponsorship-or-advertising)
- [Conclusions](#conclusions)

## Background
Over the decade, the number of bike share programs and popularity of such programs have grown drastically, with over 207 million trips taken in the U.S since 2010 [1]. Aside from being a cost efficient and environmentally friendly mode of transportation for short work commutes or excursions for fun, it also offers the benefit of exercise for the rider.

However, from a bike share program operator’s perspective, there are many factors to consider to ensure it is operating smoothly and growing. This includes taking into account  the rider experience, rider safety, bike availability, bike maintenance, bike theft/ vandalism, trip pricing, and acquisition of program sponsors.

## Objective
The objective of our project is to extract insights from Citi Bike NYC (hereafter referred to as Citi Bike) business operations (and other cities taken as reference) to inform the creation of a successful bike share program in another city. By doing so, a prospective company can optimize their business model upon deployment in a new city.

## Data Processing and Validation
The main dataset used in this analysis was Citi Bike Trip Histories [2]. Each row/observation represented a single trip. Variables included trip duration, start station, end station, user type, etc. In total there were 142 csv files organized by year, month, and state (NYC or NJ). Analyzing all 99 million observations within Jupyter notebook was deemed computationally infeasible due to the memory limitations of most personal computers. To overcome this limitation, we created two resources. 

The first resource was a 5% random subsample of the entire dataset. This subsample allowed us to discover high-level trends throughout program history. For instance, with this resource we were able to answer the following: “Which hour of the day, day of the week, and month of the year are most popular for Citi Bike rides?” 

The second resource was a SQL database. By connecting SQL with Jupyter Notebook, we were able to make targeted queries that extracted information from all 99 million observations. For instance, with a query we were able to answer the question “In the history of Citi Bike, how many people have ridden from station A to station B?” In contrast, if we were only using the 5% random subsample we would have only been able to answer “In the history of Citi Bike, what proportion of rides have gone from station A to station B?”

The 5% random subsample was validated through comparing the sampled values of imbalanced features against the true values of imbalanced features. For example, let's assume that from a SQL query we determine 12% of all rides start from the Times Square docking station. In our random subsample we find that 11.8% of all rides start from Times Square. In the next random subsample we find that 12.5% of all rides start from Times Square. This process was repeated 40 times, and the results for each station were plotted on a histogram to see whether the random sample (11.8%, 12.5%, …) accurately depicted the true value of the unbalanced feature (12%). Upon experimentation with multiple subsample percentages (1%, 5%, 10%), we found the 5% subsample to be representative of the full dataset.

## Exploratory Data Analysis
The following list displays key takeaways from the EDA process.

- Customer Type – The majority of NYC, SF, and DC bike share users are city residents who anticipate/believe that they will bike on a consistent basis.

  ![image](/documentation/images/subscriber_vs_customer.png)

- Hourly Demand – We can deduce that the increase in ridership during weekdays is due to the bikes’ use by commuters, while for the weekends bikes are used quite evenly throughout the afternoon.

  ![image](/documentation/images/time_of_day_hrs.png)

- Monthly Demand – There is a seasonality inherent to the bike share operations, in that during the warmer months, riding bikes is safer and more enjoyable, and thus more users (both Subscribers and Customers) utilize the bike share program. The increase of Customers during the warmer months is likely due to tourists who visit New York and utilize Citi Bike during their stay.

  ![image](/documentation/images/annual_ridership.png)

- Temperature vs. Fleet Size – In NYC, Citi Bike has historically moved 15% of their bikes into storage each winter.

  ![image](/documentation/images/temperature_bike_fleet_size.png)

- Trip Duration – Given the rider behavior, the takeaway for operators is to keep the max distance between stations to be around a 10-15 minute ride. 

  ![image](/documentation/images/trip_duration.png)

- Bike Rebalancing – Bike rebalancing is a process by which bikes are moved from docking stations with surplus to docking stations with shortages to meet anticipated bike demand. Rebalancing is one of the major operational considerations in setting up a bike share program.

  ![image](/documentation/images/bike_rebalancing_pt1.png)

  ![image](/documentation/images/bike_rebalancing_pt2.png)

- Revenue – Annual membership makes up the majority of Citi Bike’s revenue, although in recent years its growth has begun to plateau.

  ![image](/documentation/images/revenue.png)

## Modeling

### Revenue Forecasting
We forecasted Citi Bike’s revenue and ridership, using an ARIMA model, in order to benchmark Citi Bike’s performance during the COVID-19 lockdown. As you can see in the graphs below, both the ridership (top left), and revenue (top right) follow a seasonal trend. Every year, demand peaks in the summer and early fall, drops steeply in the winter, and picks back up in the spring. Each year this cycle repeats itself.

What is interesting about the daily ridership is that aside from the larger more visible annual seasonality, there is also a smaller seasonal trend per week (observed through ACF and PACF plots). Citi Bike demand is higher on weekdays than weekends. However, it was difficult to fit a good model to take into account the larger seasonality along with the smaller seasonality, so we decided to aggregate daily ridership by month to build a monthly-ridership seasonal ARIMA model for our analytical purposes.

- ARIMA Time Series Forecasting

  ![image](/documentation/images/time_series_forecasting.png)

Because of the COVID-19 disruption to business, we excluded ridership data starting from March 2020 as the lockdown began mid March, and shows an immediate decrease in bike usage due to the pandemic. We only excluded April 2020 from the revenue, as there is an apparent lag in revenue reporting. Next, we split the data for training and testing, the last 12 months of each set were used as testing data, and all data prior was used for training. We were able to fit two time series models that gave a 13.9% and 10% MAPE, for revenue and monthly rides, respectively. The two plots on the second row above illustrate the projected revenue and monthly ridership for 12 months afterwards with a confidence interval of 80% and 95%.

### Sponsorship or Advertising

Citi Bike and others organizations have on average contributed $12.1 million per year to Citi Bike. As mentioned above, these sponsorships are the second largest revenue source for the business. Despite the tremendous value of these sponsorships, the year to year giving of donors can be quite erratic (standard deviation of $2.3 million). From 2018 to 2019 all revenue streams grew except for sponsorship. Sponsorship decreased by $5.2 million and drove the overall business growth rate from 9.8% in 2018 to -2.8% in 2019. In short, sponsorship has provided a large amount of revenue for Citi Bike but has been irregular from year to year.

Our group wanted to investigate whether sacrificing sponsors for general advertising on the bikes (e.g. Broadway musical ads, restaurant ads, etc.) would provide more revenue and greater consistency in year to year financial reporting. To do so, we divided sponsorship by the total number of rides in a given year ($/ride). This Annual Sponsorship per Ride is a proxy for the cost of putting the Citibank logo on each bike. Throughout the years, Citibank and other sponsors have on average paid $1.03 per ride (see figure below).

- Sponsorship growth rate 

  ![image](/documentation/images/sponsorship.png)

How does the average Annual Sponsorship per Ride of $1.03 compare to traditional advertisements? In other words, is the advertising cost on Citi Bikes currently higher or lower than the going rate for billboards or taxi cab advertisements? One estimate of taxi cab advertising claimed that on any given day, taxi-top advertisements cost $1.75 per 1000 impressions [4].

We asked ourselves, “On a single Citi Bike ride how many people need to see the bike advertisement for the value of advertising to equate that of the taxi?” The answer was “On each Citi Bike ride, 590 onlookers are necessary for sponsorship to be just as cheap as taxi cab advertising.” To interpret this result let us consider two fictional scenarios.

- Sponsorship vs. Advertising Comparison 

  ![image](/documentation/images/sponshorship_table.png)

Currently, we recommend Citi Bike to stay with their sponsors because these contributions likely outcompete the market value of advertising. We recommend that Citi Bike study the number of impressions made on an average bike ride. With this value in hand, they can either switch to open market advertising or encourage current sponsors to give at a flat rate per ride so that advertising does not continue to become cheaper for the sponsors.

## Conclusions

Our exploratory data analysis and modelling uncovered transferable business insights which can be organized into three categories; sponsorship, operations, and revenue.

#### Sponsorship
With respect to sponsorships, we found that Citi Bike annually generated $12 million from their sponsors. The sponsorship cost per ride has decreased from $2 to $0.5. If sponsorship costs per ride continue to decrease, we would advise Citi Bike to study the number of Citi Bike impressions made on a given ride. With this value, Citi Bike can determine when it would become more profitable to sacrifice Citi Bike sponsors for open market advertising.

#### Operations
As temperature drops, Citi Bike operators have historically moved bikes from the streets to storage, in order to reduce damage (such as rust, or vandalism) and idling of unutilized bikes. From our analysis, it appears that Citi Bike moves approximately 15% of their fleet into storage each winter. Associated transportation and storage costs should be considered when implementing a bike share program in a similar climate. Additionally, bike rebalancing is a necessary process to counteract the unsteady flow of bikes to and from various docking stations. We found that for every 100 bike rides that occur, Citi Bike operators rebalance 7. Associated labor and transportation costs should be considered when implementing a docking station bike share model in any city.

#### Revenue
Over the course of Citi Bike’s program history, annual subscriptions have accounted for 42% of total revenue. From 2017 - 2019 annual subscriptions have flatlined with a growth rate of approximately zero (-0.2%). Assuming that this plateau of subscriptions is nationally applicable, we recommend that bike share program managers decrease the cost of casual ridership to attract new customers into the subscription base. Additionally, through comparative analysis of NYC, SF, and DC, we found that the majority of rides are under 20 minutes. Knowing this, program managers could offer generous subscription rules (unlimited rides less than 3 hours) while knowing that very few people will actually take advantage of these benefits.

Additionally, Citi Bike has not been entirely immune to COVID-19 financial impacts.  Despite low April 2020 revenue in comparison to projected values,  the $2.8 million observed is still comparable to Citi Bike’s April 2018 revenue. There also appears to be a nation-wide increase in demand for bikes since the start of the pandemic, as people look for socially distanced alternatives to traditional modes of public transportation [5]. In light of this, it is fair to conclude that Citi Bike is still able to remain a fully operating business, despite the state mandated lockdown. Assuming similar levels of population density, other bike share program managers can expect the continuation of a viable pandemic business model as people move from crowded public transit to comparatively safe bike transit.