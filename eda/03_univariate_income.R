# ============================================
# TASK 2.3: UNIVARIATE ANALYSIS - INCOME
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== PLOT 1: INCOME HISTOGRAM ==========
p1 <- ggplot(df, aes(x = Annual_Income)) +
  geom_histogram(binwidth = 10, fill = "forestgreen", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Annual Income",
    x = "Annual Income (k$)",
    y = "Frequency",
    subtitle = "Wide spread from 15k to 137k annual income"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p1)

# Save
ggsave("eda/plots/03_income_histogram.png", p1, width = 8, height = 6, dpi = 300)
print("✓ Saved: 03_income_histogram.png")

# ========== PLOT 2: INCOME BOXPLOT ==========
p2 <- ggplot(df, aes(y = Annual_Income)) +
  geom_boxplot(fill = "forestgreen", alpha = 0.6, color = "darkgreen", size = 1) +
  geom_jitter(alpha = 0.2, width = 0.1, color = "darkgreen") +
  labs(
    title = "Boxplot of Annual Income",
    y = "Annual Income (k$)",
    subtitle = "Shows median (line), quartiles (box), and outliers (points)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p2)

# Save
ggsave("eda/plots/04_income_boxplot.png", p2, width = 6, height = 8, dpi = 300)
print("✓ Saved: 04_income_boxplot.png")

# ========== STATISTICS ==========
print("\n========== INCOME STATISTICS (k$) ==========")
print(paste("Min Income:", min(df$Annual_Income)))
print(paste("Max Income:", max(df$Annual_Income)))
print(paste("Mean Income:", round(mean(df$Annual_Income), 2)))
print(paste("Median Income:", median(df$Annual_Income)))
print(paste("Std Deviation:", round(sd(df$Annual_Income), 2)))
print(paste("Q1 (25th percentile):", quantile(df$Annual_Income, 0.25)))
print(paste("Q3 (75th percentile):", quantile(df$Annual_Income, 0.75)))

print("\n✓ Task 2.3 Complete!")
