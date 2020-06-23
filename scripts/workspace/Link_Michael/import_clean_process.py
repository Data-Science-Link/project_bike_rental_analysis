def cleaning_your_bike(path):
    
    '''
    Processes compiled from https://github.com/jessiewangxin/Data_Science_for_the_SchWIN/blob/master/scripts/workspace/Wang_Jessie/CitiBike%20EDA%20Jessie.ipynb
    '''
    
    import pandas as pd
    import numpy as np
    
    dataframe = pd.read_csv(path,\
                            dtype={"tripduration":float,\
                                   "starttime":object,\
                                   "stoptime":object,\
                                   "start_station_id":float,\
                                   "start_station_name":object,\
                                   "start_station_latitude":float,\
                                   "start_station_longitude":float,\
                                   "end_station_id":float,\
                                   "end_station_name":object,\
                                   "end_station_latitude":float,\
                                   "end_station_longitude":float,\
                                   "bikeid":int,\
                                   "usertype":object,\
                                   "birth_year":object,\
                                   "gender":int,\
                                   "counter":int,\
                                   "year":int,\
                                   "age":int})
        
    # remove trips that are longer than 1 hour 
    dataframe = dataframe.loc[dataframe['tripduration']<= 60*60]
    
    #remove longitude and latitude outside of New York area 
    dataframe = dataframe.loc[(dataframe['start_station_latitude']>40) & (dataframe['start_station_latitude']<41)] 
    dataframe = dataframe.loc[(dataframe['end_station_longitude']>-74.5) & (dataframe['end_station_longitude']<-73.5)]
    
    #converting time to date time for pandas
    dataframe['start_time'] = pd.to_datetime(dataframe['starttime'])
    dataframe['stop_time'] = pd.to_datetime( dataframe['stoptime'])
    
    #drop missing end lat and long
    dataframe = dataframe.dropna(subset=['end_station_latitude', 'end_station_latitude'])
    dataframe = dataframe.dropna(subset=['start_station_id', 'start_station_name',\
                                        'end_station_id','end_station_name'])
    #start time variables 
    dataframe['year'] = dataframe['start_time'].dt.year
    
    #defining months
    dataframe['month'] = dataframe['start_time'].dt.month
    dataframe.loc[dataframe['month'] == 1, ['month']] = 'January'
    dataframe.loc[dataframe['month'] == 2, ['month']] = 'February'
    dataframe.loc[dataframe['month'] == 3, ['month']] = 'March'
    dataframe.loc[dataframe['month'] == 4, ['month']] = 'April'
    dataframe.loc[dataframe['month'] == 5, ['month']] = 'May'
    dataframe.loc[dataframe['month'] == 6, ['month']] = 'June'
    dataframe.loc[dataframe['month'] == 7, ['month']] = 'July'
    dataframe.loc[dataframe['month'] == 8, ['month']] = 'August'
    dataframe.loc[dataframe['month'] == 9, ['month']] = 'September'
    dataframe.loc[dataframe['month'] == 10, ['month']] = 'October'
    dataframe.loc[dataframe['month'] == 11, ['month']] = 'November'
    dataframe.loc[dataframe['month'] == 12, ['month']] = 'December'
    
    
    dataframe['start_date'] = dataframe['start_time'].dt.date
    dataframe['time_of_day'] = dataframe['start_time'].dt.time
    dataframe['hour_of_day'] = dataframe['start_time'].dt.hour #0 to 23 
    
    #defining days of the week and weekend 
    dataframe['week_day'] = dataframe['start_time'].dt.weekday #0 to 7 
    dataframe['weekend'] = [1 if 5<=x<=6 else 0 for x in dataframe['week_day']]
    dataframe.loc[dataframe['week_day'] == 0, ['week_day']] = 'Monday'
    dataframe.loc[dataframe['week_day'] == 1, ['week_day']] = 'Tuesday'
    dataframe.loc[dataframe['week_day'] == 2, ['week_day']] = 'Wednesday'
    dataframe.loc[dataframe['week_day'] == 3, ['week_day']] = 'Thursday'
    dataframe.loc[dataframe['week_day'] == 4, ['week_day']] = 'Friday'
    dataframe.loc[dataframe['week_day'] == 5, ['week_day']] = 'Saturday'
    dataframe.loc[dataframe['week_day'] == 6, ['week_day']] = 'Sunday'

    
    #stop time variables 
    dataframe['stop_date'] = dataframe['stop_time'].dt.date
    dataframe['stop_hour'] = dataframe['stop_time'].dt.hour
    dataframe['end_time_of_day'] = dataframe['stop_time'].dt.time
    
    return dataframe