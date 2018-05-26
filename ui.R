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
  "A8",
  tabPanel(
    titlePanel("Midwest Poverty"),
    headerPanel("Select Midwest Poverty Data"),
    sidebarPanel(
      selectInput("xcola", "x variable", names(pet_data_with_lat)),
      sliderInput("decimal", "Poverty Percentage:",
                  min = 81, max = 100,
                  value = 81, step = 1
      ),
      selected = names(df_m)[[2]]
    ),
    mainPanel(
      plotlyOutput("plot_pet")
    )
  ))