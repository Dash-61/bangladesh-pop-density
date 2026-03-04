# Statistical Visualizations in R

# Load required libraries
library(ggplot2)
library(dplyr)

# Sample data: Bangladesh Population Density
population_density <- data.frame(
  Region = c('Dhaka', 'Chittagong', 'Khulna', 'Rajshahi', 'Barisal'),
  Density = c(23000, 13000, 6000, 4000, 3000)
)

# Generate a bar plot
ggplot(population_density, aes(x = Region, y = Density)) +
  geom_bar(stat = 'identity', fill = 'skyblue') +
  theme_minimal() +
  labs(title = 'Population Density of Bangladesh by Region',
       x = 'Region',
       y = 'Population Density (per sq.km)')

# Save the plot
ggsave('population_density_plot.png')