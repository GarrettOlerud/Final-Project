library(dplyr)
library(ggplot2)
library(ggmap)
library(DT)
source("summary.r")
source("tax_choropleth.R")
library("choroplethr")
library("choroplethrZip")
#Set location and build map for ggmap
my_location <- "University of Washington"
my_map <- get_map(
  location = my_location,
  source = "google",
  maptype = "roadmap",
  crop = FALSE,
  zoom = 11
)
ggmap(my_map)
#Start the shiny server
shinyServer(function(input, output) {
#Output plot for first tab

  output$plot_pet <- renderPlot({
    ggmap(my_map) +
      geom_jitter(aes(x = pet_data_with_lat$longitude,
                      y = pet_data_with_lat$latitude),
        data = pet_data_with_lat,
        alpha = .5,
        color = "darkred",
        size = .1,
        width = .01,
        height = .01
      )
  })
  output$dog_plot <- renderPlot({
    ggmap(my_map) +
      geom_jitter(aes(x = dog_plot$longitude, y = dog_plot$latitude),
        data = dog_plot,
        alpha = .5,
        color = "darkred",
        size = .1,
        width = .01,
        height = .01
      )
  })
  output$cat_plot <- renderPlot({
    ggmap(my_map) +
      geom_jitter(aes(x = cat_plot$longitude, y = cat_plot$latitude),
        data = cat_plot,
        alpha = .5,
        color = "darkred",
        size = .1,
        width = .01,
        height = .01
      )
  })
#Output plot for second tab
  output$tax_pleth <- renderPlot({
    # Create map
    zip_choropleth(max_bracket,
      zip_zoom = zip_codes,
      title =
        "Most Prevalent Income Bracket in Each Seattle Zipcode",
      legend = "Tax Bracket"
    )
  })
#Output data tables for third page
  output$top_5_cats_df <- DT::renderDataTable({
    top_5_cats_df
  })
  output$top_5_dogs_df <- DT::renderDataTable({
    top_5_dogs_df
  })
  output$pet_data <- DT::renderDataTable({
    pet_data
  })

#Output plot for fourth page
output$plot_4 <- renderPlot({
    df = filter(brackets_adoptions, Zip == input$work)
    x <- input$work
    y <- pull(df, input$Total_Adoptions)
    
    plot_44 <- ggplot() +
      geom_bar(mapping = aes(x = x, y = y), stat = "identity") +
      scale_y_continuous(limits = c(0, 6500)) +
      labs(x = input$work, y = "Total Adoptions", title = Please)
    return(plot_44)
  })
})