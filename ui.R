# Set working directory then read in relevant libraries and data
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(ggmap)
library(DT)
library(shinythemes)
source("summary.R")
pet_data <- read.csv("data/seattle_pet_licenses.csv",
  stringsAsFactors = FALSE,
  na.strings = c("", " ", "NA", "   ", "     ")
)
tax_data <- read.delim("data/wa_incomes_zip_code.csv",
  stringsAsFactors = FALSE
) # S/O to Adele for rescuing us
# from this _tab_ seperated file.

# Begin UI

ui <- navbarPage(
  theme = shinytheme("sandstone"),
  # tab 1
  "Final",
  tabPanel(
    titlePanel("Overview"),
    mainPanel(
      "Welcome to the spring 2018 Info 201 final project by Madi Hess,
              Spencer Knapp, and Garrett Olerud.  The data used in this project comes from",
      a("Link to Data", href = "https://www.kaggle.com/aaronschlegel/seattle-pet-licenses/version/1"),
      " and includes information on the zipcodes of pet adoptions and the primary and secondary breed of
              the dog or cat adopted.  There is also information about the tax brackets and how many people fall into
              each of the brackets and filing statuses by zipcode.  The goal of this project is to discover the relationships 
              between the frequency of pet adoptions and the wealth of the area."
    )
  ),
  tabPanel(
    titlePanel("Pet Adoptions by Zipcode"),
    headerPanel("Select"),
    sidebarPanel(("Use the dropdown selector to choose the
                  the data you would like to see plotted.
                  Each option plots the pet
                  adoptions from 2005 - 2017 using zipcode
                  for either: All Pets, Cats, or Dogs.")),
    # define widgets and choices
    tabsetPanel(
      type = "tabs",
      tabPanel("All pets Adopted", plotOutput("plot_pet")),
      tabPanel("Just Dogs", plotOutput("dog_plot")),
      tabPanel("Just Cats", plotOutput("cat_plot"))
    )
  ),
  # second page
  tabPanel(
    titlePanel("Seattle Income Information"),
    headerPanel("Seattle Tax Returns"),
    sidebarPanel("These maps show the tax return information for the zip code
                 areas in the city of Seattle. On the left, you can see the most
                 prevalent income brackets in each Seattle zip code in 2015.
                 Please explore other tabs for more specific income prevalence
                 information."),
    mainPanel(
      plotOutput("tax_pleth")
    )
  ),



  # third page
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
    tabsetPanel(
      type = "tabs",
      tabPanel("Top Cats", DT::dataTableOutput("top_5_cats_df")),
      tabPanel("Top Dogs", DT::dataTableOutput("top_5_dogs_df")),
      tabPanel("Total", DT::dataTableOutput("pet_data"))
    )
  ),
  # fourth page
  tabPanel(
    titlePanel("Conclusion & Insights"),
    headerPanel("something insightful"),
    sidebarPanel(
      checkboxGroupInput("work",
                         label = "please",
                         choices = brackets_adoptions$Zip,
                         selected = NULL)),
    mainPanel(
      plotOutput("plot_44")
    ))
)

