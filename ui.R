# Set working directory then read in relevant libraries and data
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(ggmap)
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
          choices = c(cat_plot, dog_plot, pet_data_with_lat)),
            selected = pet_data_with_lat),
    mainPanel(
      plotOutput("plot_pet")
    ))
  )