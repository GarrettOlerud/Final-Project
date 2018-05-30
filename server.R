library(dplyr)
library(ggplot2)
library(ggmap)
library(DT)
source("summary.r")
source("tax_choropleth.R")
library("choroplethr")
library("choroplethrZip")
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
 output$tax_pleth <- renderPlot({zip_choropleth(max_bracket,
                                                           zip_zoom = zip_codes,
                                                           title = "Most Prevalent Income Bracket in Each Seattle Zipcode",
                                                           legend = "Tax Bracket")
})
  # Data tables for third page
  output$top_5_cats_df <- DT::renderDataTable({top_5_cats_df
 })
 output$top_5_dogs_df <- DT::renderDataTable({top_5_dogs_df
   })
 output$pet_data <- DT::renderDataTable({pet_data})
})