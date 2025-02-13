## In this file we parse the tax bracket data from the summary.R file 
##and prepare it to be used in our choropleth map.  
##We then implement this parsed data into a cholorpleth map.



# Bring in relevant libraries, sources, and set working directory
source("scripts/summary.R")
library("choroplethr")
library("choroplethrZip")
library("dplyr")

# Parse for relevant data
tax_with_lat <- tax_with_lat %>%
  select(zip, Adjusted.Gross.Income, Number.of.returns, latitude, longitude)

# Break down by zipcode to find most frequent tax bracket in each area
tax_with_lat <- tax_with_lat %>%
  group_by(zip) %>%
  mutate(
    total_area_returns = sum(Number.of.returns),
    bracket_proportion = Number.of.returns / total_area_returns
  )
max_bracket <- tax_with_lat %>%
  group_by(zip) %>%
  filter(bracket_proportion == max(bracket_proportion)) %>%
  select(zip, Adjusted.Gross.Income)

# Change column names and format of internal data
colnames(max_bracket) <- c("region", "value")
max_bracket[max_bracket[, "value"] ==
  "$100,000 under $200,000", "value"] <- "E: $100,000 - $200,000"
max_bracket[max_bracket[, "value"] ==
  "$1 under $25,000", "value"] <- "A: $1 - $25,000"
max_bracket[max_bracket[, "value"] ==
  "$25,000 under $50,000", "value"] <- "B: $25,000 - $50,000"
max_bracket[max_bracket[, "value"] ==
  "$50,000 under $75,000", "value"] <- "C: $50,000 - $75,000"
max_bracket[max_bracket[, "value"] ==
  "$200,000 or more", "value"] <- "F: $200,000 or more"
max_bracket[max_bracket[, "value"] ==
  "$75,000 under $100,000", "value"] <- "D: $75,000 - $100,000"

# Remove double max values objectively
max_bracket <- max_bracket %>%
  group_by(region) %>%
  top_n(1)

# Begin choropleth map: bring in zipcode data and zoom to specific zip_codes
data("zip.regions")
head(zip.regions)

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

# Tax choropleth map
tax_map <- zip_choropleth(max_bracket,
  zip_zoom = zip_codes,
  title = "Most Prevalent Income Bracket in Each Seattle Zipcode",
  legend = "Tax Bracket"
) +
  coord_map()
