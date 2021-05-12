library(ggplot2)
library(ggpubr)

# Read the data from the file.
data <- read.csv("diamond.csv")

# Format the categorical variables.
terms_cut <- c(data$cut[0])
for(val in data$cut) {
  if(!is.element(val, terms_cut)){
    terms_cut <- c(terms_cut, val)
  }
}

terms_color <- c(data$color[0])
for(val in data$color) {
  if(!is.element(val, terms_color)){
    terms_color <- c(terms_color, val)
  }
}

data$cut <- factor(data$cut, levels = terms_cut)
data$color <- factor(data$color, levels = terms_color)
data$clarity <- factor(data$clarity, levels = c("I1", "SI2", "SI1", "VS2", "VS1", "VVS2", "VVS1", "IF"))

# Plot the data with least-squares regression line and LOESS curve.
ggplot(data=data, mapping=aes(x=price, y=carat)) +
  geom_point(mapping=aes(colour=color, shape=cut, alpha=clarity)) +
  geom_smooth(method=lm) +
  stat_cor(label.x=5) +
  geom_smooth(colour="red") +
  xlab("Diamond Price") +
  ylab("Diamond Carat") + 
  theme_bw()

# We can see from the data that as the diamond price increases, the diamond carat increases as well.
# The cut types seem to be scattered throughout, with all types of cuts being found in every price range, so diamond price may not depend on this variable but this is not definite.
# The clarity values of "SI1", "SI2", and "I1" seem to have a higher carat and a higher price range than others.
# This shows that diamond price does depend on clarity.
# The price of the diamond also depends on color, where color F and E are primarily the cheaper ones and color J tends to be at the pricier range.
# Since we are seeing three categorical variables in one plot, it's difficult to quickly see relationships, but these capture the overall behavior. 

library(magrittr)

# Using pipes (%>%) write the following operation:
print(exp(round(log(3.4), 2)), 7)

3.4 %>% log() %>%
  round(2) %>% 
  exp() %>%
  print(7)







