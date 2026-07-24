# ============================================
# TASK 2.10: GENDER BREAKDOWN BOXPLOTS
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== PLOT 1: GENDER VS INCOME ==========
p1 <- ggplot(df, aes(x = Gender, y = Annual_Income, fill = Gender)) +
  geom_boxplot(alpha = 0.7, color = "black") +
  geom_jitter(alpha = 0.2, width = 0.2, color = "darkgrey") +
  labs(
    title = "Annual Income Distribution by Gender",
    x = "Gender",
    y = "Annual Income (k$)",
    subtitle = "Comparing income spreads between Male and Female customers"
  ) +
  scale_fill_manual(values = c("Female" = "#FF69B4", "Male" = "#4169E1")) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "none"
  )

print(p1)

# Save
ggsave("eda/plots/13_gender_vs_income.png", p1, width = 8, height = 6, dpi = 300)
print("✓ Saved: 13_gender_vs_income.png")

# ========== PLOT 2: GENDER VS SPENDING SCORE ==========
p2 <- ggplot(df, aes(x = Gender, y = Spending_Score, fill = Gender)) +
  geom_boxplot(alpha = 0.7, color = "black") +
  geom_jitter(alpha = 0.2, width = 0.2, color = "darkgrey") +
  labs(
    title = "Spending Score Distribution by Gender",
    x = "Gender",
    y = "Spending Score (1-100)",
    subtitle = "Comparing spending score spreads between Male and Female customers"
  ) +
  scale_fill_manual(values = c("Female" = "#FF69B4", "Male" = "#4169E1")) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "none"
  )

print(p2)

# Save
ggsave("eda/plots/14_gender_vs_spending.png", p2, width = 8, height = 6, dpi = 300)
print("✓ Saved: 14_gender_vs_spending.png")

# ========== STATISTICAL COMPARISONS ==========
print("\n========== GENDER STATISTICS ==========")
# Income
male_inc_mean <- mean(df$Annual_Income[df$Gender == "Male"])
female_inc_mean <- mean(df$Annual_Income[df$Gender == "Female"])
cat("Mean Annual Income (Male):", round(male_inc_mean, 2), "k$\n")
cat("Mean Annual Income (Female):", round(female_inc_mean, 2), "k$\n")

# Spending
male_spend_mean <- mean(df$Spending_Score[df$Gender == "Male"])
female_spend_mean <- mean(df$Spending_Score[df$Gender == "Female"])
cat("\nMean Spending Score (Male):", round(male_spend_mean, 2), "\n")
cat("Mean Spending Score (Female):", round(female_spend_mean, 2), "\n")

print("\n✓ Task 2.10 Complete!")
