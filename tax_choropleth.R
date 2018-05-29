# Bring in relevant libraries, sources, and set working directory
source("summary.R")
library(choroplethr)
library(choroplethrZip)
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

colnames(max_bracket) <- c("region", "value")
max_bracket[max_bracket[, "value"] == "$100,000 under $200,000", "value"] <- "200000"
max_bracket[max_bracket[, "value"] == "$1 under $25,000", "value"] <- "25000"
max_bracket[max_bracket[, "value"] == "$25,000 under $50,000", "value"] <- "50000"
max_bracket[max_bracket[, "value"] == "$50,000 under $75,000", "value"] <- "75000"
max_bracket[max_bracket[, "value"] == "$200,000 or more", "value"] <- "200001"
max_bracket[max_bracket[, "value"] == "$75,000 under $100,000", "value"] <- "100000"

max_bracket <- max_bracket %>%
  group_by(region) %>%
  top_n(1)


# Begin choropleth map: bring in zipcode data and filter out relevant "fip"
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

# Get King County FIP
sea_fips <- zip.regions[zip.regions$region %in% zip_codes, ]
sea_fips <- sea_fips$county.fips.numeric
sea_fips <- unique(sea_fips)

# Tax choropleth map
zip_choropleth(max_bracket,
               zip_zoom = zip_codes,
               title = "Most Prevalent Income Bracket in Each Seattle Zipcode",
               legend = "Tax Bracket") +
  coord_map()

