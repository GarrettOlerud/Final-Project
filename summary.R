# Set working directory then read in relevant libraries and data
library(dplyr)
library(maps)
library("ggplot2")
library(zipcode)
data(zipcode)
library("stringr")
pet_data <- read.csv("data/seattle_pet_licenses.csv",
  stringsAsFactors = FALSE,
  na.strings = c("", " ", "NA", "   ", "     ")
)
tax_data <- read.delim("data/wa_incomes_zip_code.csv",
  stringsAsFactors = FALSE
)
# S/O to Adele for rescuing us from this _tab_ seperated file.

# Filter for only relevant zip codes
zip_codes <- c(
  "98101", "98102", "98103", "98104",
  "98105", "98106", "98107", "98108",
  "98109", "98112", "98115", "98116",
  "98117", "98118", "98119", "98121",
  "98122", "98125", "98126", "98133",
  "98134", "98136", "98144", "98146",
  "98154", "98164", "98174", "98177",
  "98178", "98195", "98199"
)

# Clean pet_data
pet_data <- pet_data[!is.na(pet_data$zip_code), ] # Remove NAs
# Source:https://stackoverflow.com/questions/11254524/omit-rows-containing-
# specific-column-of-na?utm_medium=organic&utm_source=google_rich_qa&utm_
# campaign=google_rich_qa

pet_data <- pet_data[pet_data$zip_code %in% zip_codes, ]
# Remove non-Seattle zipcodes. 
# Source: https://stackoverflow.com/questions/21200057/selecting-rows-of-which-
# the-value-of-the-variable-is-equal-to-certain-vector?utm_medium=organic&utm_
# source=google_rich_qa&utm_campaign=google_rich_qa

pet_data_zip <- pet_data %>% group_by(zip_code) %>% select(zip_code)

# Attach lat and long to pet_data using zipcode package
colnames(pet_data)[which(names(pet_data) == "zip_code")] <- "zip"
colnames(zipcode)[which(names(zipcode) == "zip_code")] <- "zip"
colnames(tax_data)[which(names(tax_data) == "Zip.Code")] <- "zip"
pet_data_with_lat <- left_join(pet_data, zipcode, by = "zip")

# And the same for tax_data
colnames(tax_data)[1] <- "zip"
tax_data <- tax_data[tax_data$zip %in% zip_codes, ] # Only Seattle zipcodes
tax_data[, 1] <- as.character(tax_data[, 1]) # Make character to join with zipcode
tax_with_lat <- left_join(tax_data, zipcode, by = "zip")

