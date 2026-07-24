# ============================================
# TASK 2.7: BIVARIATE ANALYSIS - AGE vs INCOME
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== CORRELATION ==========
correlation <- cor(df$Age, df$Annual_Income)
print(paste("Correlation (Age vs Income):", round(correlation, 3)))

# ========== PLOT: SCATTER WITH REGRESSION LINE ==========
p <- ggplot(df, aes(x = Age, y = Annual_Income)) +
  geom_point(size = 3, alpha = 0.6, color = "forestgreen") +
  geom_smooth(method = "lm", se = TRUE, color = "red", alpha = 0.2, linewidth = 1.5) +
  labs(
    title = "Age vs Annual Income",
    x = "Age (years)",
    y = "Annual Income (k$)",
    subtitle = paste("Weak correlation (r = ", round(correlation, 3), "). Income doesn't strongly depend on age.")
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

print(p)

# Save
ggsave("eda/plots/10_age_vs_income.png", p, width = 8, height = 6, dpi = 300)
print("✓ Saved: 10_age_vs_income.png")

print("\n✓ Task 2.7 Complete!")
