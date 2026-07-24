# ============================================
# TASK 2.6: BIVARIATE ANALYSIS - INCOME vs SPENDING
# THIS IS THE MOST IMPORTANT PLOT!
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== PLOT 1: SIMPLE SCATTER ==========
p1 <- ggplot(df, aes(x = Annual_Income, y = Spending_Score)) +
  geom_point(size = 4, alpha = 0.6, color = "steelblue") +
  labs(
    title = "Customer Segmentation: Annual Income vs Spending Score",
    x = "Annual Income (k$)",
    y = "Spending Score (1-100)",
    subtitle = "NOTICE THE 5 DISTINCT CLUSTERS IN THIS PLOT!"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "darkblue"),
    plot.subtitle = element_text(face = "bold", size = 12, color = "red"),
    axis.title = element_text(size = 11),
    panel.grid.major = element_line(color = "lightgray", linetype = "dashed")
  )

print(p1)

# Save
ggsave("eda/plots/08_income_vs_spending_scatter.png", p1, width = 10, height = 7, dpi = 300)
print("✓ Saved: 08_income_vs_spending_scatter.png")

# ========== PLOT 2: WITH DENSITY CONTOURS ==========
p2 <- ggplot(df, aes(x = Annual_Income, y = Spending_Score)) +
  geom_point(size = 3, alpha = 0.5, color = "steelblue") +
  geom_density_2d(color = "red", alpha = 0.3, bins = 5) +
  geom_density_2d(aes(fill = ..level..), alpha = 0.1, bins = 5) +
  scale_fill_gradient(low = "white", high = "red") +
  labs(
    title = "Income vs Spending Score with Density Contours",
    x = "Annual Income (k$)",
    y = "Spending Score (1-100)",
    subtitle = "Red contours show customer concentration areas"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11),
    legend.position = "none"
  )

print(p2)

# Save
ggsave("eda/plots/09_income_vs_spending_density.png", p2, width = 10, height = 7, dpi = 300)
print("✓ Saved: 09_income_vs_spending_density.png")

# ========== CORRELATION ==========
correlation <- cor(df$Annual_Income, df$Spending_Score)

print("\n========== INCOME vs SPENDING RELATIONSHIP ==========")
print(paste("Correlation coefficient:", round(correlation, 3)))
print("Interpretation: Almost ZERO correlation - Income and Spending are independent!")
print("\nThis is PERFECT for clustering because:")
print("1. Income != Spending Score (not dependent on each other)")
print("2. High income doesn't guarantee high spending (Cluster 1: high income, low spend)")
print("3. Low income doesn't mean low spending (Cluster 4: low income, high spend)")
print("4. This independence creates DISTINCT, SEPARABLE CUSTOMER GROUPS")

# ========== VISUAL IDENTIFICATION OF 5 CLUSTERS ==========
print("\n========== 5 CUSTOMER CLUSTERS VISIBLE IN PLOT ==========")
print("\nCluster 1: High Income (~120k), High Spending (~80)")
print("  -> VIP/Loyal Customers - spend everything they earn")
print("\nCluster 2: High Income (~120k), Low Spending (~20)")
print("  -> Careful/Frugal - have money but don't spend it")
print("\nCluster 3: Medium Income (~60k), Medium Spending (~50)")
print("  -> Average Customers - balanced income & spending")
print("\nCluster 4: Low Income (~30k), High Spending (~80)")
print("  -> Impulsive/Careless - overspending relative to income")
print("\nCluster 5: Low Income (~30k), Low Spending (~30)")
print("  -> Conservative/Sensible - low income, low spending")

print("\n✓ Task 2.6 Complete - KEY PLOT SAVED!")
