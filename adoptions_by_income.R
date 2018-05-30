source("summary.R")
source("pet_adoptions.R")
library("dplyr")
library("ggplot2")

brackets_adoptions_1 <- brackets_adoptions %>%
  group_by(Most_Common_Bracket) %>%
  tally(Total_Adoptions)


# Create plot
plotted_bar <- ggplot(data = brackets_adoptions_1) +
    geom_bar(mapping = aes(x = brackets_adoptions_1$Most_Common_Bracket, fill = brackets_adoptions_1$n)) +
    labs(x = "Income Bracket", y = "Pet Adoptions") +
    ggtitle("Pet Adoptions by Income Bracket")