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
                                  geom_jitter(aes(x = pet_data_with_lat$longitude, y = pet_data_with_lat$latitude),
                                              data = pet_data_with_lat,
                                                alpha = .5,
                                                  color = "darkred",
                                                    size = .1,
                                                      width = .01,
                                                       height = .01)})
  output$dog_plot <- renderPlot({ggmap(my_map)+
      geom_jitter(aes(x = dog_plot$longitude, y = dog_plot$latitude),
                  data = dog_plot,
                    alpha = .5,
                      color = "darkred",
                        size = .1,
                          width = .01,
                            height = .01)})
  output$cat_plot <- renderPlot({ggmap(my_map)+
      geom_jitter(aes(x = cat_plot$longitude, y = cat_plot$latitude),
                  data = cat_plot,
                    alpha = .5,
                      color = "darkred",
                        size = .1,
                          width = .01,
                            height = .01)})
 # second graph
 output$tax_pleth <- renderPlot({
   # Add progress bar because slow to load
   progress = shiny::Progress$new()
   on.exit(progress$close())
   progress$set(message = "Creating image. Please wait.", value = 0)
   #Create map
   zip_choropleth(max_bracket, zip_zoom = zip_codes,
                  title =
                    "Most Prevalent Income Bracket in Each Seattle Zipcode",
                  legend = "Tax Bracket")
})
  # Data tables for third page
  output$top_5_cats_df <- DT::renderDataTable({top_5_cats_df
 })
 output$top_5_dogs_df <- DT::renderDataTable({top_5_dogs_df
   })
 output$pet_data <- DT::renderDataTable({pet_data})

#Visual on tab 4
 output$plot_4 <- renderPlotly({
   y <- brackets_adoptions[[input$variable]]
   plot_ly(
     data = mutate(brackets_adoptions,
                   threshold = input$decimal > 0),
     y = ~ y, x = ~ Zip,
     color = ~ threshold,
     text = ~paste("Tax Bracket: ", Most_Common_Tax_Bracket)
   ) %>%
     layout(title = "Please",
            yaxis = list(title = input$variable),
            xaxis = list(title = "Zip Code"))
 })
})
 
#output$brackets_adoptions_plot <- ggplot(data = brackets_adoptions) +
 # geom_bar(aes(fill = variable), position = "dodge", stat = "identity") +
  #labs(x = "Zip Code", y = "Total Adoptions") +
  #ggtitle("Please Work") +
  #theme(axis.text.x = element_text(angle = -85, hjust = 0)) + 
  #scale_fill_discrete(name="Key")

output$brackets_adoptions_plot_2 <-renderPlot({
  ggplot(data = brackets_adoptions, aes(x = input$Most_Common_Bracket, y = input$Total_Adoptions))  +
    stat_summary(fun.y = sum, geom = "bar",colour = "#56B4E9", fill = "#56B4E9") +
    geom_bar(stat = "identity") +
    labs(title=input$Zip, y =input$Total_Adoptions) +
    theme_classic() +
    theme
}) 

