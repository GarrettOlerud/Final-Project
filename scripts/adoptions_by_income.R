source("summary.R")
source("pet_adoptions.R")
library("dplyr")
library("ggplot2")
library("choroplethr")
library("choroplethrZip")

brackets_adoptions_pet <- brackets_adoptions %>%
  group_by(Zip) %>%
  tally(Total_Adoptions)
colnames(brackets_adoptions_pet) <- c("region", "value")

brackets_adoptions_1 <- brackets_adoptions %>%
  group_by(Most_Common_Bracket) %>%
  tally(Total_Adoptions)

brackets_adoptions_1$lab <- as.character(brackets_adoptions_1$n)


# Create plot
ggplot(data = brackets_adoptions_1) +
  geom_bar(mapping = aes(x = brackets_adoptions_1$Most_Common_Bracket, 
                         y = brackets_adoptions_1$n), stat = "identity", fill = "midnight blue") +
  labs(x = "Income Bracket", y = "Pet Adoptions") +
  geom_text(mapping = aes(x = brackets_adoptions_1$Most_Common_Bracket, 
                          y = brackets_adoptions_1$n, label = brackets_adoptions_1$lab), vjust = -0.15) +
  ggtitle("Pet Adoptions by Income Bracket") +
  theme(axis.text.x  = element_text(angle=-45, hjust=0,colour="black")) +
  scale_x_discrete(breaks = brackets_adoptions_1$Most_Common_Bracket,
                   limits = c("$1 under $25,000", 
                              "$25,000 under $50,000",
                              "$50,000 under $75,000",
                              "$100,000 under $200,000",
                              "$200,000 or more"))

# Create choropleth of pet adoptions in Seattle
data("zip.regions")
head(zip.regions)

pet_map <- zip_choropleth(brackets_adoptions_pet,
                          zip_zoom = zip_codes,
                          title = "Total Pet Adoptions in Each Seattle Zipcode",
                          legend = "Number of Adoptions"
)

