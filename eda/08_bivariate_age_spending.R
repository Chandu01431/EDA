# ============================================
# TASK 2.8: BIVARIATE ANALYSIS - AGE vs SPENDING SCORE
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== CORRELATION ==========
correlation <- cor(df$Age, df$Spending_Score)
print(paste("Correlation (Age vs Spending):", round(correlation, 3)))

# ========== PLOT: SCATTER WITH REGRESSION LINE ==========
p <- ggplot(df, aes(x = Age, y = Spending_Score)) +
  geom_point(size = 3, alpha = 0.6, color = "coral") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", alpha = 0.2, linewidth = 1.5) +
  labs(
    title = "Age vs Spending Score",
    x = "Age (years)",
    y = "Spending Score (1-100)",
    subtitle = paste("Moderate negative correlation (r = ", round(correlation, 3), "). Older customers spend less.")
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p)

# Save
ggsave("eda/plots/11_age_vs_spending.png", p, width = 8, height = 6, dpi = 300)
print("✓ Saved: 11_age_vs_spending.png")

print("\n✓ Task 2.8 Complete!")
