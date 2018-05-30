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
  df <- reactive({
    x <- get(input$xcol)
  })
  
  output$plot_pet <- renderPlot({ggmap(my_map)+
                                  geom_jitter(aes(x = df$longitude, y = df$latitude),
                                              data = df,
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
 output$pet_data <- DT::renderDataTable({pet_data})

#Visual on tab 4
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
})
