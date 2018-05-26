library(dplyr)
library(ggplot2)
library(ggmap)
source("summary.r")

my_location <- "University of Washington"
my_map <- get_map(location = my_location,
                    source = "google",
                      maptype = "roadmap",
                       crop = FALSE,
                         zoom = 11)
ggmap(my_map)

shinyServer(function(input, output){
  output$plot_pet <- renderPlot(ggmap(my_map)+
                                  geom_jitter(aes(x = longitude, y = latitude),
                                              data = input$xcol,
                                                alpha = .5,
                                                  color = "darkred",
                                                    size = .1,
                                                      width = .01,
                                                        height = .01))
})
