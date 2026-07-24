# ============================================
# TASK 2.2: UNIVARIATE ANALYSIS - AGE
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== PLOT 1: AGE HISTOGRAM ==========
p1 <- ggplot(df, aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Customer Ages",
    x = "Age (years)",
    y = "Frequency",
    subtitle = "Most customers are between 25-50 years old"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p1)

# Save the plot
ggsave("eda/plots/01_age_histogram.png", p1, width = 8, height = 6, dpi = 300)
print("✓ Saved: 01_age_histogram.png")

# ========== PLOT 2: AGE DENSITY ==========
p2 <- ggplot(df, aes(x = Age)) +
  geom_density(fill = "steelblue", alpha = 0.6, color = "darkblue") +
  geom_rug(alpha = 0.3) +
  labs(
    title = "Density Plot of Customer Ages",
    x = "Age (years)",
    y = "Density",
    subtitle = "Smooth distribution showing age concentration"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p2)

# Save the plot
ggsave("eda/plots/02_age_density.png", p2, width = 8, height = 6, dpi = 300)
print("✓ Saved: 02_age_density.png")

# ========== STATISTICS ==========
print("\n========== AGE STATISTICS ==========")
print(paste("Min Age:", min(df$Age)))
print(paste("Max Age:", max(df$Age)))
print(paste("Mean Age:", round(mean(df$Age), 2)))
print(paste("Median Age:", median(df$Age)))
print(paste("Std Deviation:", round(sd(df$Age), 2)))
print(paste("25th Percentile:", quantile(df$Age, 0.25)))
print(paste("75th Percentile:", quantile(df$Age, 0.75)))

print("\n✓ Task 2.2 Complete!")
