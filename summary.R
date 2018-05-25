# Set working directory then read in relevant libraries and data 
library(dplyr)
library(maps)
library(zipcode)
data(zipcode)

pet_data <- read.csv("data/seattle_pet_licenses.csv", stringsAsFactors = FALSE)
tax_data <- read.delim("data/wa_incomes_zip_code.csv", 
                       stringsAsFactors = FALSE) 
# S/O to Adele for rescuing us
# from this _tab_ seperated file.

pet_data_zip <- pet_data %>% group_by(zip_code) %>% select(zip_code)

map <- ggplot(pet_data,aes(longitude,latitude)) +
  geom_polygon(data=us,aes(x=long,y=lat,group=group),color='gray',fill=NA,alpha=.35)+
  geom_point(aes(color = count),size=.15,alpha=.25) +
  xlim(-125,-65)+ylim(20,50)

joined_data <- left_join(pet_data, tax_data, by = "")

#Recommend using tax bracket bins and now joining data sets
#Don't join dataframes if it makes no sense

#Attach lat and long using zipcode package
colnames(pet_data)[which(names(pet_data) == "zip_code")] <- "zip"
colnames(zipcode)[which(names(zipcode) == "zip_code")] <- "zip"
colnames(tax_data)[which(names(tax_data) == "Zip.Code")] <- "zip"
pet_data_with_lat <- left_join(pet_data, zipcode, by = "zip")

#tax_data_clean <- clean.zipcodes(tax_data)
#tax_with_lat <- left_join(zipcode, tax_data)

#Working on most_adopted_pets visualization below
most_adopted <- pet_data_with_lat %>% select(primary_breed,
                                              species, zip, city, latitude, longitude)
#Function from David Arenburg
#https://tinyurl.com/yafunvtp

freqfunc <- function(x, n){
  tail(sort(table(unlist(strsplit(as.character(x), ", ")))), n)
}

top_5_dogs <- freqfunc(most_adopted$primary_breed, 5)
top_5_dogs_df <- data.frame(top_5_dogs) %>% arrange(desc(Freq))


most_adopted_cats <- most_adopted %>% filter(species == "Cat")

top_5_cats <- freqfunc(most_adopted_cats$primary_breed, 5)
top_5_cats_df <- data.frame(top_5_cats) %>% arrange(desc(Freq))
