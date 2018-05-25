# Bring in relevant libraries, sources, and set working directory
source("summary.R")

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
max_area_bracket <- tax_with_lat %>%
  group_by(zip) %>%
  filter(bracket_proportion == max(bracket_proportion))

