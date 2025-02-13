# Set working directory then read in relevant libraries and data
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(ggmap)
library(DT)
library(shinythemes)
source("scripts/summary.R")

# Read in Pet data
pet_data <- read.csv("data/seattle_pet_licenses.csv",
  stringsAsFactors = FALSE,
  na.strings = c("", " ", "NA", "   ", "     ")
)
# Read in Tax data
tax_data <- read.delim("data/wa_incomes_zip_code.csv",
  stringsAsFactors = FALSE
) # S/O to Adele for rescuing us
# from this _tab_ seperated file.

# Begin UI
ui <- navbarPage(
  # set theme for entire app
  theme = shinytheme("sandstone"),
  # tab 1
  "Final",
  # first tab
  tabPanel(
    titlePanel("Overview"),
    mainPanel(
      "Welcome to the spring 2018 Info 201 final project by Madi Hess,
              Spencer Knapp, and Garrett Olerud.
      The data used in this project comes from",
      a("Link to Data",
        href = "https://www.kaggle.com/aaronschlegel/
      seattle-pet-licenses/version/1"
      ),
      " and includes information on the zipcodes of pet adoptions and
      the primary and secondary breed of the dog or cat adopted.  There
      is also information about the tax brackets and how many people
      fall into each of the brackets and filing statuses by zipcode.
      The goal of this project is to discover the relationships
      between the frequency of pet adoptions and the wealth of the area.
      We also hope to help provide potential pet-adopters with a better
      way to learn about and explore the statistics of pet adoption in
      their area"
    )
  ),
  # second tab
  tabPanel(
    titlePanel("Pet Adoptions by Zipcode"),
    headerPanel("Select"),
    sidebarPanel(("Use the dropdown selector to choose the
                  the data you would like to see plotted.
                  Each option plots the pet
                  adoptions from 2005 -
                  2017 using zipcode
                  for either: All Pets,
                  Cats, or Dogs.")),
    # create tabs to select data to be plotted
    tabsetPanel(
      type = "tabs",
      tabPanel("All pets Adopted", plotOutput("plot_pet")),
      tabPanel("Just Dogs", plotOutput("dog_plot")),
      tabPanel("Just Cats", plotOutput("cat_plot"))
    )
  ),
  # third tab
  tabPanel(
    titlePanel("Seattle Income Information"),
    headerPanel("Seattle Tax Returns"),
    sidebarPanel("These maps show the tax return information for the zip code
                 areas in the city of Seattle. On the left, you can see the most
                 prevalent income brackets in each Seattle zip code in 2015."),
    mainPanel("Most Prevalent Income Brackets", plotOutput("tax_pleth"))
    ),

  # fourth tab
  tabPanel(
    titlePanel("Top Adoptions"),
    headerPanel("Top 5 Dog and Cat Adoptions"),
    sidebarPanel("These three tables allow you to see
                 the top five breeds for both Cats and
                 Dogs as well as search for the popularity
                 of your breed of cat or dog in the Seattle
                 area with the total tab.  You can use the
                 search bar to filter down resuts even more
                 say you want to find how many Terriers there
                 are in a seattle zipcode your would type Terrier, 98107"),
    # Create tabs to select what data you want displayed
    tabsetPanel(
      type = "tabs",
      tabPanel("Top Cats", DT::dataTableOutput("top_5_cats_df")),
      tabPanel("Top Dogs", DT::dataTableOutput("top_5_dogs_df")),
      tabPanel("Total", DT::dataTableOutput("pet_data"))
    )
  ),

  # fifth tab
  tabPanel(
    titlePanel("Conclusion & Insights"),
    headerPanel("Seattle: Home of the DAWGS"),
    sidebarPanel("Certain neighborhoods tend to adopt more pets than others. 
                  This is often based on location, areas that are closer to 
                  parks and farther from the main city were more likely to adopt
                  than areas that were not. This is evident by the fact that
                  there are far more pets being adopted in area codes near Green
                  Lake and other north Seattle neighborhoods compared to the
                  center of downtown Seattle. Income seems to have some type of
                  affect on adoption rates as well, however our data does not 
                  provide individual tax returns to correspond with adoption 
                  records. Without this, we can only make an educated guess
                  that mid-level income tax brackets tend to adopt more pets
                  than those in low tax brackets or those in the highest bracket
                  . This claim does not have enough data to be fully supported
                  and should be further investigated.
                  Finally, our data clearly showed that dogs are far more likely
                  to be adopted than cats in the Seattle area. We hypothesize
                  this may be due to a dog-friendly work culture in Seattle 
                  (i.e. Amazon allowing owners to bring dogs), a higher number 
                  of dogs offered for adoption, or an incomplete data set."),
    tabsetPanel(
      type = "tabs",
      tabPanel("Income Bracket vs. Pet Adoptions", plotOutput("income_adoptions")),
      tabPanel("Total Pet Adoptions", plotOutput("pet_pleth")),
      tabPanel("Comparing Adoptions by Species", DT::dataTableOutput("compare_pets"))
    )
))
