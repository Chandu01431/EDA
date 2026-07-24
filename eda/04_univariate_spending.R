# ============================================
# TASK 2.4: UNIVARIATE ANALYSIS - SPENDING SCORE
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== PLOT 1: SPENDING HISTOGRAM ==========
p1 <- ggplot(df, aes(x = Spending_Score)) +
  geom_histogram(binwidth = 5, fill = "coral", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Spending Score",
    x = "Spending Score (1-100)",
    y = "Frequency",
    subtitle = "Fairly uniform distribution across all spending levels"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p1)

# Save
ggsave("eda/plots/05_spending_histogram.png", p1, width = 8, height = 6, dpi = 300)
print("✓ Saved: 05_spending_histogram.png")

# ========== PLOT 2: SPENDING DENSITY ==========
p2 <- ggplot(df, aes(x = Spending_Score)) +
  geom_density(fill = "coral", alpha = 0.6, color = "darkred") +
  geom_rug(alpha = 0.3, color = "darkred") +
  labs(
    title = "Density Plot of Spending Score",
    x = "Spending Score (1-100)",
    y = "Density",
    subtitle = "Smooth distribution showing spending patterns"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p2)

# Save
ggsave("eda/plots/06_spending_density.png", p2, width = 8, height = 6, dpi = 300)
print("✓ Saved: 06_spending_density.png")

# ========== STATISTICS ==========
print("\n========== SPENDING SCORE STATISTICS (1-100) ==========")
print(paste("Min Spending:", min(df$Spending_Score)))
print(paste("Max Spending:", max(df$Spending_Score)))
print(paste("Mean Spending:", round(mean(df$Spending_Score), 2)))
print(paste("Median Spending:", median(df$Spending_Score)))
print(paste("Std Deviation:", round(sd(df$Spending_Score), 2)))
print(paste("Q1 (25th percentile):", quantile(df$Spending_Score, 0.25)))
print(paste("Q3 (75th percentile):", quantile(df$Spending_Score, 0.75)))

# Count how many are low vs high spenders
low_spenders <- sum(df$Spending_Score < 40)
medium_spenders <- sum(df$Spending_Score >= 40 & df$Spending_Score < 60)
high_spenders <- sum(df$Spending_Score >= 60)

print("\n========== SPENDING CATEGORIES ==========")
print(paste("Low Spenders (1-39):", low_spenders, "customers"))
print(paste("Medium Spenders (40-59):", medium_spenders, "customers"))
print(paste("High Spenders (60-100):", high_spenders, "customers"))

print("\n✓ Task 2.4 Complete!")
