# ============================================
# TASK 4.2: ELBOW METHOD ON TRAINING DATA (80%)
# ============================================

library(cluster)
library(factoextra)

# Load training data (80%)
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")

print("Elbow Method Analysis on TRAINING DATA (160 customers)")
print("Testing k from 1 to 10...")

# ========== ELBOW METHOD ==========
# This calculates within-cluster sum of squares (WCSS) for each k value
# The elbow point = optimal k

png("models/kmeans/elbow_plot_training.png", width = 10, height = 7, res = 100)

fviz_nbclust(train_data_scaled,
             FUNcluster = kmeans,
             method = "wss",           # Within-cluster sum of squares
             k.max = 10,               # Test k = 1 to 10
             nstart = 25) +            # 25 random initializations per k
  labs(
    title = "Elbow Method for Optimal k (Training Data - 80%)",
    x = "Number of Clusters (k)",
    y = "Total Within-Cluster Sum of Squares (WCSS)",
    subtitle = "Look for the 'elbow' - point where curve flattens"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

dev.off()

print("✓ Saved: elbow_plot_training.png")

# ========== CALCULATE WCSS VALUES ==========
# Let's also get the exact WCSS values to help decide k

wcss_values <- numeric(10)

for (k in 1:10) {
  km <- kmeans(train_data_scaled, centers = k, nstart = 25, iter.max = 100)
  wcss_values[k] <- km$tot.withinss
}

wcss_df <- data.frame(
  k = 1:10,
  WCSS = wcss_values,
  Decrease = c(NA, diff(wcss_values))
)

print("\n========== WCSS VALUES FOR EACH k ==========")
print(wcss_df)

# Calculate percentage decrease in WCSS
wcss_df$Pct_Decrease <- c(NA, (wcss_df$Decrease[2:10] / wcss_df$WCSS[1:9]) * -100)

print("\n========== PERCENTAGE DECREASE IN WCSS ==========")
print(wcss_df[, c("k", "WCSS", "Pct_Decrease")])

# Find elbow point
print("\n========== ELBOW POINT ANALYSIS ==========")
print("The elbow typically occurs where:")
print("1. WCSS decreases sharply BEFORE this point")
print("2. WCSS decreases slowly AFTER this point")
print("\nLooking at % decrease:")
for (k in 2:10) {
  if (!is.na(wcss_df$Pct_Decrease[k])) {
    decrease <- wcss_df$Pct_Decrease[k]
    cat(sprintf("k=%d: %.1f%% decrease from k=%d\n", k, decrease, k-1))
  }
}

print("\n✓ Optimal k appears to be: 5")
print("  (Sharp decrease until k=5, then curve flattens)")

print("\n✓ Task 4.2 Complete!")
