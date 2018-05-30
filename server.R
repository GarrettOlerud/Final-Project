library(dplyr)
library(ggplot2)
library(ggmap)
library(DT)
library("choroplethr")
library("choroplethrZip")
source("scripts/summary.R")
source("scripts/tax_choropleth.R")
source("scripts/adoptions_by_income.R")
source("scripts/pet_adoptions.R")

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
             fill = "midnight blue", width = 0.5) +
    labs(x = "Income Bracket", y = "Pet Adoptions") +
    geom_text(mapping = aes(x = brackets_adoptions_1$Most_Common_Bracket, 
                            y = brackets_adoptions_1$n,
                            label = brackets_adoptions_1$lab), vjust = -0.15) +
    ggtitle("Pet Adoptions by Income Bracket") +
    theme(panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x  = element_text(angle=-45, hjust=0,colour="black"),
          text = element_text(size=20),
          plot.title = element_text(hjust = 0.5)) +
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