library(dplyr)
library(ggplot2)
library(ggmap)
source("summary.r")

my_location <- c( lon = -120.74, lat = 47.75)
my_map <- get_map(location = my_location,
                    source = "google",
                      maptype = "roadmap",
                       crop = FALSE,
                         zoom = 6)
ggmap(my_map)

shinyServer(function(input, output){
  output$pet_plot <- renderPlot(ggmap(my_map)+
                                  geom_point(aes(x = longitude, y = latitude),
                                              data = pet_data_with_lat,
                                                alpha = .5,
                                                  color = "darkred",
                                                    size = 3)
    
  )
})
