# =============================================================
# Bangladesh Population Density - Statistical Visualizations
# =============================================================
# This script generates additional statistical visualizations
# for the population density project
# =============================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(gridExtra)

# =============================================================
# 1. Load Data
# =============================================================
# Read the population statistics by division
pop_stats <- read.csv('data/Bangladesh_Statistics_Summary.csv')

# =============================================================
# 2. Population Distribution by Division (Bar Chart)
# =============================================================
p1 <- ggplot(pop_stats, aes(x = reorder(Division, -Population), y = Population)) +
  geom_bar(stat = "identity", fill = "#2E86C1", alpha = 0.8) +
  labs(
    title = "Population Distribution by Division",
    x = "Division",
    y = "Population",
    subtitle = "2025 Population Statistics"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 10, color = "gray50")
  ) +
  scale_y_continuous(labels = function(x) paste0(x/1e6, "M"))

# =============================================================
# 3. Population Percentage Pie Chart
# =============================================================
pop_stats$Percentage <- (pop_stats$Population / sum(pop_stats$Population)) * 100

p2 <- ggplot(pop_stats, aes(x = "", y = Population, fill = Division)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  labs(
    title = "Population Distribution - Pie Chart",
    subtitle = "Percentage by Division"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray50", hjust = 0.5),
    legend.position = "right"
  )

# =============================================================
# 4. Cumulative Population Distribution
# =============================================================
pop_stats_sorted <- pop_stats %>%
  arrange(desc(Population)) %>%
  mutate(
    Cumulative = cumsum(Population),
    Cumulative_Pct = (Cumulative / sum(Population)) * 100
  )

p3 <- ggplot(pop_stats_sorted, aes(x = reorder(Division, -Population))) +
  geom_col(aes(y = Population), fill = "#27AE60", alpha = 0.7, name = "Population") +
  geom_line(aes(y = Cumulative / 100000, group = 1), color = "#E74C3C", size = 1) +
  labs(
    title = "Cumulative Population Distribution",
    x = "Division",
    y = "Population"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(size = 14, face = "bold")
  )

print("Statistical visualizations generated successfully!")
