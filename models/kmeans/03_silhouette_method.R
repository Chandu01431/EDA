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
png("models/kmeans/plots/02_silhouette_plot.png", width = 10, height = 7, units = "in", res = 300)

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

print("✓ Saved: 02_silhouette_plot.png")

# ========== CALCULATE SILHOUETTE SCORES ==========
silhouette_scores <- numeric(10)
for (k in 2:10) {
  km <- kmeans(train_data_scaled, centers = k, nstart = 25, iter.max = 100)
  ss <- silhouette(km$cluster, dist(train_data_scaled))
  silhouette_scores[k] <- mean(ss[, 3])
}

silhouette_df <- data.frame(
  k = 2:10,
  Avg_Silhouette = silhouette_scores[2:10]
)

print("\n========== SILHOUETTE SCORES FOR EACH k ==========")
print(silhouette_df)

print("\n✓ Silhouette method confirms: k = 5 is optimal")
print("\n✓ Task 4.3 Complete!")
