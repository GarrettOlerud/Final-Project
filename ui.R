# Set working directory then read in relevant libraries and data
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(ggmap)
library(DT)
source("summary.R")
pet_data <- read.csv("data/seattle_pet_licenses.csv", stringsAsFactors = FALSE,
                     na.strings = c("", " ", "NA", "   ", "     "))
tax_data <- read.delim("data/wa_incomes_zip_code.csv",
                       stringsAsFactors = FALSE) # S/O to Adele for rescuing us
# from this _tab_ seperated file.

# Begin UI

ui <- navbarPage(
  theme = "style.css",
  # tab 1
  "Final",
  tabPanel(
    titlePanel("Pet Adoptions In Seattle"),
    headerPanel("Select"),
    sidebarPanel(
      selectInput("xcol",
        label = "Data Displayed",
          choices = list("pet_data_with_lat", "cat_plot", "dog_plot")),
            selected = "pet_data_with_lat"),
    mainPanel(
      plotOutput("plot_pet")
    )),
  tabPanel(
    titlePanel("chloropleth Map"),
    headerPanel("something insightful"),
    sidebarPanel("descriptive paragraphs or widgets"),
    mainPanel(
      plotOutput("chloro_plot")
    )),
  tabPanel(
    titlePanel("Top 5 adoptions"),
    headerPanel("Top 5 Dogs and Cats"),
    sidebarPanel("description of two tabels"),
    mainPanel(DT::dataTableOutput("top_5_cats_df"),
              DT::dataTableOutput("top_5_dogs_df")
    )
    ))
  