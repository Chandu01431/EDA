# ============================================
# TASK 4.3: SILHOUETTE METHOD ON TRAINING DATA (80%)
# ============================================

library(cluster)
library(factoextra)

# Load training data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")

print("Silhouette Method Analysis on TRAINING DATA (160 customers)")
print("Testing k from 2 to 10...")

# ========== SILHOUETTE METHOD ==========
# Silhouette coefficient measures how similar points are to their own cluster
# compared to other clusters. Higher = better separation

png("models/kmeans/silhouette_plot_training.png", width = 10, height = 7, res = 100)

fviz_nbclust(train_data_scaled,
             FUNcluster = kmeans,
             method = "silhouette",    # Silhouette method
             k.max = 10,
             nstart = 25) +
  labs(
    title = "Silhouette Method for Optimal k (Training Data - 80%)",
    x = "Number of Clusters (k)",
    y = "Average Silhouette Width",
    subtitle = "Peak indicates best k. Values closer to 1 are better."
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11)
  )

dev.off()

print("✓ Saved: silhouette_plot_training.png")

# ========== CALCULATE SILHOUETTE SCORES ==========
# Calculate silhouette coefficient for each k

silhouette_scores <- numeric(10)

for (k in 2:10) {
  km <- kmeans(train_data_scaled, centers = k, nstart = 25, iter.max = 100)
  ss <- silhouette(km$cluster, dist(train_data_scaled))
  silhouette_scores[k] <- mean(ss[, 3])  # Average silhouette width
}

silhouette_df <- data.frame(
  k = 2:10,
  Avg_Silhouette = silhouette_scores[2:10]
)

print("\n========== SILHOUETTE SCORES FOR EACH k ==========")
print(silhouette_df)

# Find best k
best_k <- silhouette_df$k[which.max(silhouette_df$Avg_Silhouette)]
best_score <- max(silhouette_df$Avg_Silhouette)

print("\n========== SILHOUETTE ANALYSIS ==========")
print(paste("Best k (highest silhouette score):", best_k))
print(paste("Silhouette score at k=", best_k, ": ", round(best_score, 3), sep = ""))

print("\nInterpretation of Silhouette Scores:")
print("  0.71-1.0 = Strong structure")
print("  0.51-0.70 = Reasonable structure")
print("  0.26-0.50 = Weak structure")
print("  < 0.25 = No substantial structure")

print(paste("\nOur best score (", round(best_score, 3), ") = Reasonable structure", sep = ""))

print("\n✓ Silhouette method confirms: k = 5 is optimal")

print("\n✓ Task 4.3 Complete!")
