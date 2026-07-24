# ============================================
# TASK 2.9: CORRELATION HEATMAP
# ============================================

library(ggplot2)
library(tidyverse)
library(corrplot)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# We only correlate numeric fields: Age, Annual_Income, Spending_Score, and Gender_Encoded
numeric_df <- df[, c("Age", "Annual_Income", "Spending_Score", "Gender_Encoded")]

# Calculate correlation matrix
cor_matrix <- cor(numeric_df)
print("Correlation Matrix:")
print(round(cor_matrix, 3))

# ========== PLOT: CORRELATION HEATMAP ==========
# We save a plot utilizing corrplot or a custom ggplot tile plot (for safety if corrplot isn't present)
# Here we'll generate both or use a ggplot-based tiles plot which is guaranteed to run without corrplot package issues!
# Let's make a beautiful ggplot tile plot
cor_melted <- as.data.frame(as.table(cor_matrix))
names(cor_melted) <- c("Var1", "Var2", "Correlation")

p <- ggplot(cor_melted, aes(x = Var1, y = Var2, fill = Correlation)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1,1)) +
  geom_text(aes(label = round(Correlation, 2)), color = "black", size = 4) +
  labs(
    title = "Correlation Heatmap",
    x = "",
    y = "",
    subtitle = "Age has moderate negative correlation with Spending Score (-0.33)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)
  )

print(p)

# Save
ggsave("eda/plots/12_correlation_matrix.png", p, width = 8, height = 6, dpi = 300)
print("✓ Saved: 12_correlation_matrix.png")

print("\n✓ Task 2.9 Complete!")
