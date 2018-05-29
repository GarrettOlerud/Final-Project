library(dplyr)
library(ggplot2)
library(ggmap)
library(DT)
source("summary.r")
#set location and build map for ggmap
my_location <- "University of Washington"
my_map <- get_map(location = my_location,
                    source = "google",
                      maptype = "roadmap",
                       crop = FALSE,
                         zoom = 11)
ggmap(my_map)
#start the shiny server
shinyServer(function(input, output){
  #output plot for first page
  output$plot_pet <- renderPlot({ggmap(my_map)+
                                  geom_jitter(aes(x = input$longitude, y = input$latitude),
                                              data = input$xcol,
                                                alpha = .5,
                                                  color = "darkred",
                                                    size = .1,
                                                      width = .01,
                                                       height = .01)})
 # second graph
 # output$chloro_plot <- renderPlot({#Madi just put the plot in here)
#})
  # Data tables for third page
  output$top_5_cats_df <- DT::renderDataTable({top_5_cats_df
 })
 output$top_5_dogs_df <- DT::renderDataTable({top_5_dogs_df
   })
})