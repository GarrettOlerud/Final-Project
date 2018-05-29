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
# Remove non-Seattle zipcodes. Source: https://stackoverflow.com/questions/
# 21200057/selecting-rows-of-which-the-value-of-the-variable-is-equal-to-certain-
# vector?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

pet_data_zip <- pet_data %>% group_by(zip_code) %>% select(zip_code)

# map <- ggplot(pet_data,aes(longitude,latitude)) +
# geom_polygon(aes(x=long,y=lat,group=group),color='gray',fill=NA,alpha=.35)+
# geom_point(aes(color = count),size=.15,alpha=.25) +
# xlim(-125,-65)+ylim(20,50)


# Recommend using tax bracket bins and now joining data sets
# Don't join dataframes if it makes no sense

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


#Find most top 5 adopted dogs and cats by breed
most_adopted <- pet_data_with_lat %>% select(primary_breed,
                                              species, zip, city, latitude, longitude)
#Function from David Arenburg
#https://tinyurl.com/yafunvtp

# Working on most_adopted_pets visualization below
most_adopted <- pet_data_with_lat %>% select(
  primary_breed,
  species, zip, city, latitude, longitude
)
# Function from David Arenburg
# https://tinyurl.com/yafunvtp


freqfunc <- function(x, n) {
  tail(sort(table(unlist(strsplit(as.character(x), ", ")))), n)
}

# Top 5 Dogs dataframe
most_adopted_dogs <- most_adopted %>% filter(species == "Dog")
top_5_dogs <- freqfunc(most_adopted_dogs$primary_breed, 5)
top_5_dogs_df <- data.frame(top_5_dogs) %>% arrange(desc(Freq))
colnames(top_5_dogs_df) <- c("Dog Breed", "Frequency")

# Top 5 Cats dataframe
most_adopted_cats <- most_adopted %>% filter(species == "Cat")
top_5_cats <- freqfunc(most_adopted_cats$primary_breed, 5)
top_5_cats_df <- data.frame(top_5_cats) %>% arrange(desc(Freq))


#Find 5 post popular dog names and 5 most popular cat names

colnames(top_5_cats_df) <- c("Cat Breed", "Frequency")
#fiter data to be just cats or dogs for plotting
cat_plot <- pet_data_with_lat %>% filter(species == "Cat")
dog_plot <- pet_data_with_lat %>% filter(species == "Dog")

