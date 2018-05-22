# Set working directory then read in relevant libraries and data 

library("dplyr")
library("maps")

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

map <- ggplot(pet_data,aes(longitude,latitude)) +
  geom_polygon(data=us,aes(x=long,y=lat,group=group),color='gray',fill=NA,alpha=.35)+
  geom_point(aes(color = count),size=.15,alpha=.25) +
  xlim(-125,-65)+ylim(20,50)

joined_data <- left_join(pet_data, tax_data, by = )

#Recommend using tax bracket bins and now joining data sets
#Don't join dataframes if it makes no sense
