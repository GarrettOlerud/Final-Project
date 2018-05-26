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
  output$plot_pet <- renderPlot({ggmap(my_map)+
                                  geom_jitter(aes(x = longitude, y = latitude),
                                              data = input$xcol,
                                                alpha = .5,
                                                  color = "darkred",
                                                    size = .1,
                                                      width = .01,
                                                        height = .01)})
  output$chloro_plot <- renderPlot({#Madi just put the plot in here)
})
  output$pop_dog <- renderTable({#Spencer insert the top_5_dogs dataframe to be displayed
  })
  output$pop_cat <- renderTable({#Spencer insert the top_5_cats dataframe to be displayed
    })
})