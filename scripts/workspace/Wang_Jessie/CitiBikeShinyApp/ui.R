#CitiBike colors 
#39A2E1
#263571
#263571

dashboardPage(skin='black',
  dashboardHeader(title='Citi Bike Project'),
  dashboardSidebar(
    sidebarMenu(
      menuItem('Annual Growth',tabName = 'map1',icon=icon('map')),
      menuItem('Supply vs Demand',tabName = 'map2',icon=icon('map')),
      menuItem('Month/Week/Hour View',tabName = 'map3',icon=icon('map')),
      menuItem('About',tabName= 'about',icon=icon('book')))),
  dashboardBody(
    tabItems(
          #Yearly View Map
          tabItem(tabName='map1',
                  #leaflet map
                  leafletOutput("map1"),
                  fluidRow(
                    column(6,
                           HTML('<br></br>'),
                           sliderInput("loopyear", "Looping Animation:",
                                       min = 2013, max = 2020,
                                       value = 1, step = 1,
                                       animate =
                                         animationOptions(interval = 1500, loop = TRUE)),
                           plotlyOutput("leBubblePlot"))
                    
                  )),
          #SUPPLY VS DEMAND MAP TAB
          tabItem(tabName='map2',
                  #leaflet map
                  sliderInput("looptime", "Looping Animation:",
                              min = 5, max = 23,
                              value = 1, step = 1,
                              animate =
                                animationOptions(interval = 1500, loop = TRUE)),
                  selectizeInput(inputId ="season",
                                 label = "Season",
                                 choices = unique(hourly_grouped$season)),
                  leafletOutput("map2"),
                  leafletOutput("map3"),
                  HTML('<br></br><br></br><br></br>')),  
          #IMONTHLY WEEKLY HOURLY VIEW MAP
          tabItem(tabName='map3',
                  #leaflet map
                  sliderInput("looptime2", "Looping Animation:",
                              min = 5, max = 23,
                              value = 1, step = 1,
                              animate =
                                animationOptions(interval = 1500, loop = TRUE)),
                  selectizeInput(inputId ="month",
                                 label = "Month",
                                 choices = unique(df_month_day_hour$month)),
                  selectizeInput(inputId ="week_day",
                                 label = "Day of Week",
                                 choices = unique(df_month_day_hour$week_day)),
                  leafletOutput("map4"),
                  HTML('<br></br><br></br><br></br>')), 
          #TEAM BIO
          tabItem(tabName='about', 
            fluidRow(
              column(6,HTML('
                              <p>Blog post link. </p>
                            ')),
              column(6,
              #INSERT IMAGE
              )))
    )
  )
)



