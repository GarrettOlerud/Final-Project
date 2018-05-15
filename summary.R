# Set working directory then read in relevant libraries and data 
library("dplyr")
pet_data <- read.csv("data/seattle_pet_licenses.csv", stringsAsFactors = FALSE)
tax_data <- read.delim("data/wa_incomes_zip_code.csv", 
                       stringsAsFactors = FALSE) # S/O to Adele for rescuing us
# from this _tab_ seperated file.


