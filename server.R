library(dplyr)
library(ggplot2)
library(ggmap)
library(DT)
source("summary.r")
source("tax_choropleth.R")
source("adoptions_by_income.R")
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
#Output plot for Pet Adoptions by Zipcode
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
#Output plot for Seattle Income Information
  output$tax_pleth <- renderPlot({
    # Create map
    zip_choropleth(max_bracket,
      zip_zoom = zip_codes,
      title =
        "Most Prevalent Income Bracket in Each Seattle Zipcode",
      legend = "Tax Bracket"
    )
  })
  output$income_pleth <- renderPlot({
    # Get variables
    df <- filter(tax_with_lat, Adjusted.Gross.Income == input$income) %>%
      select(region = zip, value = Number.of.returns)
    
    # Create map
    zip_choropleth(df,
                   zip_zoom = zip_codes,
                   title =
                     paste0(input$income, "Tax Bracket in Each Seattle Zipcode"),
                   legend = "Key"
    )
  })
#Output data tables for Top Adoptions
  output$top_5_cats_df <- DT::renderDataTable({
    top_5_cats_df
  })
  output$top_5_dogs_df <- DT::renderDataTable({
    top_5_dogs_df
  })
  output$pet_data <- DT::renderDataTable({
    pet_data
  })

#Output plots for Conclusion & Insights
  # Pets vs. Income
output$income_adoptions <- renderPlot ({
  ggplot(data = brackets_adoptions_1) +
    geom_bar(mapping = aes(x = brackets_adoptions_1$Most_Common_Bracket, 
                           y = brackets_adoptions_1$n), stat = "identity",
             fill = "midnight blue") +
    labs(x = "Income Bracket", y = "Pet Adoptions") +
    geom_text(mapping = aes(x = brackets_adoptions_1$Most_Common_Bracket, 
                            y = brackets_adoptions_1$n,
                            label = brackets_adoptions_1$lab), vjust = -0.15) +
    ggtitle("Pet Adoptions by Income Bracket") +
    theme(panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x  = element_text(angle=-45, hjust=0,colour="black")) +
    scale_x_discrete(breaks = brackets_adoptions_1$Most_Common_Bracket,
                     limits = c("$1 under $25,000", 
                                "$25,000 under $50,000",
                                "$50,000 under $75,000",
                                "$100,000 under $200,000",
                                "$200,000 or more"))
})
  # Total Pet Adoptions Choropleth
output$pet_pleth <- renderPlot({
  zip_choropleth(brackets_adoptions_pet,
                 zip_zoom = zip_codes,
                 title = "Total Pet Adoptions in Each Seattle Zipcode",
                 legend = "Number of Adoptions")
})
# Comparing pet adoptions by species table
  output$compare_pets <- DT::renderDataTable({compare_pets
})
}
)