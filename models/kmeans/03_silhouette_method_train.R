# ============================================
# TASK 4.3: SILHOUETTE METHOD ON TRAINING DATA (80%)
# ============================================

library(cluster)
library(factoextra)

# Load training data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")

cat("========================================\n")
cat(" SILHOUETTE METHOD - TRAINING DATA\n")
cat("========================================\n")

# Create folder if it doesn't exist
if (!dir.exists("models/kmeans")) {
  dir.create("models/kmeans", recursive = TRUE)
}

# ============================================
# SILHOUETTE PLOT
# ============================================

png(
  filename = "models/kmeans/silhouette_plot_training.png",
  width = 10,
  height = 7,
  units = "in",
  res = 100
)

fviz_nbclust(
  train_data_scaled,
  FUNcluster = kmeans,
  method = "silhouette",
  k.max = 10,
  nstart = 25
) +
  labs(
    title = "Silhouette Method for Optimal k (Training Data - 80%)",
    x = "Number of Clusters (k)",
    y = "Average Silhouette Width",
    subtitle = "Highest value indicates the optimal number of clusters"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 12)
  )

dev.off()

cat("✓ Silhouette plot saved successfully.\n\n")

# ============================================
# CALCULATE SILHOUETTE SCORES
# ============================================

distance_matrix <- dist(train_data_scaled)

silhouette_scores <- numeric(9)

for (k in 2:10) {
  
  km <- kmeans(
    train_data_scaled,
    centers = k,
    nstart = 25,
    iter.max = 100
  )
  
  ss <- silhouette(km$cluster, distance_matrix)
  
  silhouette_scores[k - 1] <- mean(ss[, 3])
}

silhouette_df <- data.frame(
  k = 2:10,
  Avg_Silhouette = round(silhouette_scores, 4)
)

cat("========== SILHOUETTE SCORES ==========\n")
print(silhouette_df)

# ============================================
# BEST K
# ============================================

best_index <- which.max(silhouette_df$Avg_Silhouette)

best_k <- silhouette_df$k[best_index]
best_score <- silhouette_df$Avg_Silhouette[best_index]

cat("\n========================================\n")
cat("BEST NUMBER OF CLUSTERS\n")
cat("========================================\n")
cat("Optimal k :", best_k, "\n")
cat("Best Silhouette Score :", best_score, "\n\n")

cat("Interpretation:\n")

if (best_score >= 0.71) {
  cat("Strong cluster structure\n")
} else if (best_score >= 0.51) {
  cat("Reasonable cluster structure\n")
} else if (best_score >= 0.26) {
  cat("Weak cluster structure\n")
} else {
  cat("No substantial cluster structure\n")
}

cat("\nTask 4.3 Completed Successfully.\n")

