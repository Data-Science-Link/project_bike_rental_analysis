function(input,output,session){
  
#DATA TAB 
  # output$table=DT::renderDataTable({
  #   datatable(airbnb,rownames = F) %>% 
  #     formatStyle(input$selected,background = 'skyblue',
  #                 fontWeight ='bold')
  # })
  
#data used for the interactive annual map
mapdata1 <- reactive({
  citibike %>% 
  mutate(monthcount = ifelse(citibike$year==2013, 7, ifelse(citibike$year==2020,5,12))) %>% 
  filter(citibike$year==input$loopyear,start_station_name!='NYCBS Depot - SSP',start_station_name!='NYCBS Test',
  start_station_name!='8D OPS 01') %>%
  group_by(year,start_station_name,start_station_latitude,start_station_longitude) %>%
  summarise(count=sum(counter/monthcount)) 
   })
    
  #adding colors for the map (map tab)
  mapcolors <- colorNumeric(palette = "Spectral",domain = 0:700)
  #boroughcolors <- colorNumeric(palette = "Set1",domain = mapdata$price_bucket)
  
  #MAP - annual
  output$map1 <- renderLeaflet({
    mapdata1() %>% 
      leaflet() %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      addCircleMarkers(~start_station_longitude, ~start_station_latitude, 
                       color= ~mapcolors(count),
                       fillOpacity = 1,
                       radius=3,
                       label = ~start_station_name) %>% 
      addLegend('bottomright', 
                pal=mapcolors, 
                values=~count, 
                title = "count") 
    
  })
  
  #bubbledata
  bubble_data <- reactive({
    year_report = year_report %>%  
      mutate(Rides_per_Day= round(year_report$Rides*20/year_report$Days,0), 
             text = paste("Year: ", Year,  
                          "\nNumber of Docks: ", Docks, 
                          "\nRide per Day: ", Rides_per_Day, sep=""))
  })
  
  #Bubble plot
  output$leBubblePlot <- renderPlotly({
    ggplotly(ggplot(bubble_data(),
                    aes(x=Year, y=Docks, color=Year, size = Rides_per_Day,text=text)) +
               geom_point(alpha=0.7) +
               scale_size(range = c(5, 15)) +
               scale_fill_viridis(discrete=TRUE, guide=FALSE) +
               theme_bw() +
               xlab("Year") + 
               ylab("Number of Docks") +
               ggtitle("Annual Business Growth") +
               theme(legend.position = "none"),
               tooltip="text") %>% layout(autosize = FALSE, height = 425,width=650)
  })
  
  output$heatplot <- renderPlot({
    heat %>% filter(year==2013, hour_of_day>5 & hour_of_day < 23) %>% 
      ggplot(aes(hour_of_day, week_day, fill= counter)) + 
      geom_tile() +
      scale_fill_viridis(direction=-1) +
      xlab('Time of Day') + 
      ylab('') +
      scale_y_discrete(labels= c('Monday', 'Tuesday', 'Wednesday','Thursday','Fridy','Saturday','Sunday'))  +
      scale_x_discrete(labels= c(5:23)) 

  })
  

  #data for hourly view map
  mapdata2 <- reactive({
    df_month_day_hour %>% 
      filter(start_station_name!='NYCBS Depot - SSP',start_station_name!='NYCBS Test',
             start_station_name!='8D OPS 01') %>%
      filter(season==input$season, hour_of_day==input$looptime)
  })
  
  mapcolors2 <- colorNumeric(palette = "BuPu",domain = 0:300)
  #MAP - hourly
  output$map2 <- renderLeaflet({
    mapdata2() %>% 
      leaflet() %>% 
      addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
               attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
      addCircleMarkers(~start_station_longitude, ~start_station_latitude, 
                       color= ~mapcolors2(counter*20),
                       fillOpacity = 1,
                       radius=3,
                       label = ~start_station_name) %>% 
      addLegend('bottomright', 
                pal=mapcolors2, 
                values=~counter*20, 
                title = "count") 
    
  })
  
  statuspal <- colorFactor(c("#440154FF","#414487FF","#CA0020","#22A884FF"), domain = hourly_grouped$status_sum)
  
  #data for hourly view map
  mapdata3 <- reactive({
    hourly_grouped %>% 
      filter(year == 2019, season == input$season, hour == input$looptime,
             X_lat>40,X_lat<41)
  })

  #DOCKS - hourly
  output$map3 <- renderLeaflet({
    mapdata3() %>% 
      leaflet() %>% addProviderTiles('CartoDB.Positron') %>% 
      addCircleMarkers(lng=~X_long, lat=~X_lat, color = ~statuspal(status_sum), popup = ~status_sum, label=~dock_name, radius=3) %>% 
      addLegend('bottomright', pal=statuspal, values=~status_sum)
  })
  
  #data for hourly view map
  mapdata4 <- reactive({
    df_month_day_hour %>% 
      filter(start_station_name!='NYCBS Depot - SSP',start_station_name!='NYCBS Test',
             start_station_name!='8D OPS 01') %>%
      filter(month==input$month, hour_of_day==input$looptime2)
  })
  
  mapcolors4 <- colorNumeric(palette = "PuRd",domain = 0:200)
  #MAP - hourly
  output$map4 <- renderLeaflet({
    mapdata4() %>% 
      leaflet() %>% 
      addProviderTiles('CartoDB.Positron') %>% 
      addCircleMarkers(~start_station_longitude, ~start_station_latitude, 
                       color= ~mapcolors4(counter*20),
                       fillOpacity = 1,
                       radius=3,
                       label = ~start_station_name) %>% 
      addLegend('bottomright', 
                pal=mapcolors4, 
                values=~counter*20, 
                title = "count") 
    
  })
  
  
}