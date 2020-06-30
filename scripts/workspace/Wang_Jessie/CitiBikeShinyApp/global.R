#loading libraries
library(shiny)
library(shinydashboard)
library(DT)
library(leaflet)
library(dplyr)
library(plotly)
library(viridis)
library(tidyverse)
library(lubridate)
library(janitor)

#reading in data 
citibike <-read.csv('./Data/testshiny.csv')
heat <-read.csv('./Data/heat.csv')
year_report <-read.csv('./Data/year_report.csv', stringsAsFactors = FALSE)
df_month_day_hour <-read.csv('./Data/df_month_day_hour.csv', stringsAsFactors = FALSE)
hourly_grouped <-read.csv('./Data/hourly_grouped.csv', stringsAsFactors = FALSE)

