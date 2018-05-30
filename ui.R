# Set working directory then read in relevant libraries and data
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(ggmap)
library(DT)
library(shinythemes)
source("summary.R")
pet_data <- read.csv("data/seattle_pet_licenses.csv", stringsAsFactors = FALSE,
                     na.strings = c("", " ", "NA", "   ", "     "))
tax_data <- read.delim("data/wa_incomes_zip_code.csv",
                       stringsAsFactors = FALSE) # S/O to Adele for rescuing us
# from this _tab_ seperated file.

# Begin UI

ui <- navbarPage(
  theme = shinytheme("sandstone"),
  # tab 1
  "Final",
  tabPanel(
    titlePanel("Overview"),
    mainPanel("Welcome to the spring 2018 Info 201 final project by Madi Hess,
              Spencer Knapp, and Garrett Olerud.  The data in this project comes from",
              a("Link to Data", href="https://www.kaggle.com/aaronschlegel/seattle-pet-licenses/version/1"), " and includes")
  ),
  tabPanel(
    titlePanel("Pet Adoptions by Zipcode"),
    headerPanel("Select"),
    sidebarPanel(("Use the dropdown selector to choose the
                  the data you would like to see plotted.
                  Each option plots the pet
                  adoptions from 2005 - 2017 using zipcode
                  for All Pets, Cats, or Dogs."),
      #define widgets and choices
      selectInput("xcol",
        label = "Data Displayed",
          choices = list("pet_data_with_lat", "cat_plot", "dog_plot")),
            selected = "pet_data_with_lat"),
    #output plot
      mainPanel(
        plotOutput("plot_pet")
    )),
  #second page
  tabPanel(
    titlePanel("chloropleth Map"),
    headerPanel("something insightful"),
    sidebarPanel("descriptive paragraphs or widgets"),
    mainPanel(
      plotOutput("tax_pleth")
    )),
  #third page
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
    tabsetPanel(type = "tabs",
              tabPanel("Top Cats", DT::dataTableOutput("top_5_cats_df")),
              tabPanel("Top Dogs", DT::dataTableOutput("top_5_dogs_df")),
              tabPanel("Total", DT::dataTableOutput("pet_data")
              ))),
   #fourth page
   tabPanel(
      tabPanel(
     titlePanel("Conclusion & Insights"),
     headerPanel("something insightful"),
     sidebarPanel("descriptive paragraphs or widgets"),
     mainPanel(

       plotOutput("brackets_adoptions_plot_2")
     ))
    ))
     
    
  