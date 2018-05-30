## In this file we observe the frequency of pet adoptions through
## various lenses of filtering and wrangling.

# Load relavant libraries, set working directory, and source summary.R file
library("dplyr")
library(dplyr)
library(ggplot2)
library(ggmap)
library(DT)
source("scripts/summary.R")

# Total adoptions of dogs and cats
compare_pets <- pet_data %>%
  filter(species != "Livestock") %>% # An outier in our data
  group_by(species) %>%
  count()
colnames(compare_pets) <- c("Species", "Total Adoptions")

#Set location and build map for ggmap
my_location <- "University of Washington"
my_map <- get_map(
  location = my_location,
  source = "google",
  maptype = "roadmap",
  crop = FALSE,
  zoom = 11
)
ggmap(my_map)

# Find most top 5 adopted dogs and cats by breed
most_adopted <- pet_data_with_lat %>% select(
  primary_breed, species, zip, city, latitude, longitude
)
# Function from David Arenburg
# https://tinyurl.com/yafunvtp

# Working on most_adopted_pets visualization below
most_adopted <- pet_data_with_lat %>%
  select(primary_breed, species, zip, city, latitude, longitude)
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
colnames(top_5_cats_df) <- c("Cat Breed", "Frequency")

# Filter data to be just cats or dogs for plotting
cat_plot <- pet_data_with_lat %>% filter(species == "Cat")
dog_plot <- pet_data_with_lat %>% filter(species == "Dog")

# Determine most common tax bracket for each zipcode, include the bracket range
most_common_bracket <- tax_with_lat %>%
  select(zip, Adjusted.Gross.Income, Number.of.returns) %>%
  group_by(zip) %>%
  top_n(1, Number.of.returns)

# Determine number of adoptions per zipcode
total_adoptions_by_zip <- most_adopted %>%
  group_by(zip) %>%
  summarize(count = n())

# Join both dataframes
brackets_adoptions <- left_join(most_common_bracket, total_adoptions_by_zip,
  by = "zip"
)
colnames(brackets_adoptions) <- c(
  "Zip", "Most_Common_Bracket", "Returns",
  "Total_Adoptions"
)
