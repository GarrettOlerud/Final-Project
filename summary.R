# Set working directory then read in relevant libraries and data 
install.packages("zipcode")
install.packages("dplyr")
library(zipcode)
library(dplyr)
pet_data <- read.csv("data/seattle_pet_licenses.csv", stringsAsFactors = FALSE)
tax_data <- read.delim("data/wa_incomes_zip_code.csv", 
                       stringsAsFactors = FALSE) 
# S/O to Adele for rescuing us
# from this _tab_ seperated file.

pet_data_zip <- pet_data %>% group_by(zip_code)

joined_data <- left_join(pet_data, tax_data, by = )

#Recommend using tax bracket bins and now joining data sets
#Don't join dataframes if it makes no sense