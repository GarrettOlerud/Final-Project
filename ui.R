
# Set working directory then read in relevant libraries and data
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(ggmap)
source("summary.R")
pet_data <- read.csv("data/seattle_pet_licenses.csv", stringsAsFactors = FALSE)
tax_data <- read.delim("data/wa_incomes_zip_code.csv", 
                       stringsAsFactors = FALSE) # S/O to Adele for rescuing us
# from this _tab_ seperated file.
ui <- fluidPage(theme = "style.css",
        "Animal adoptions and tax brackets?",
      tabPanel(
       titlePanel("Page 1"),
        headerPanel("subheading"),
          sidebarLayout("widgets / descriptive paragraph"),
            mainPanel(plotOutput("plot_pet")))
        )