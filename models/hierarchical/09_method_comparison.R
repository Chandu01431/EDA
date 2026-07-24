# ============================================
# TASK 5.9: K-MEANS vs HIERARCHICAL COMPARISON
# ============================================

library(tidyverse)
library(cluster)
library(factoextra)

print("========================================")
print("METHOD COMPARISON: K-MEANS vs HIERARCHICAL")
print("========================================\n")

# Load both models
kmeans_model <- readRDS("models/kmeans/kmeans_model_trained.rds")
hc_model <- readRDS("models/hierarchical/hc_model.rds")
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")

# Get cluster assignments
kmeans_clusters <- kmeans_model$cluster
hc_clusters <- readRDS("models/hierarchical/hc_clusters_training.rds")

print("Both models loaded successfully!\n")

# ========== 1. CLUSTER SIZE COMPARISON ==========
print("1. CLUSTER SIZE DISTRIBUTION")
print("===============================\n")

km_sizes <- table(kmeans_clusters)
hc_sizes <- table(hc_clusters)

size_compare <- data.frame(
  Cluster = 1:5,
  KMeans_Count = as.numeric(km_sizes),
  KMeans_Pct = round(as.numeric(km_sizes) / sum(km_sizes) * 100, 1),
  Hierarchical_Count = as.numeric(hc_sizes),
  Hierarchical_Pct = round(as.numeric(hc_sizes) / sum(hc_sizes) * 100, 1)
)

print(size_compare)

# ========== 2. CLUSTER OVERLAP / CROSS-TABULATION ==========
print("\n2. CLUSTER OVERLAP (Cross-tabulation)")
print("======================================\n")
print("Rows: K-Means clusters | Columns: Hierarchical clusters\n")

cross_table <- table(KMeans = kmeans_clusters, Hierarchical = hc_clusters)
print(cross_table)

# Calculate agreement rate
agreement <- sum(diag(cross_table)) / sum(cross_table) * 100
cat(sprintf("\nSimple agreement rate: %.1f%%\n", agreement))

# ========== 3. ADJUSTED RAND INDEX ==========
print("\n3. ADJUSTED RAND INDEX (ARI)")
print("=============================\n")

library(mclust)
ari <- adjustedRandIndex(kmeans_clusters, hc_clusters)
cat(sprintf("Adjusted Rand Index: %.3f\n", ari))

if (ari > 0.7) {
  print("✓ STRONG AGREEMENT: Both methods find very similar clusters!")
} else if (ari > 0.5) {
  print("~ MODERATE AGREEMENT: Reasonable consistency between methods")
} else if (ari > 0.3) {
  print("~ WEAK AGREEMENT: Methods find somewhat different patterns")
} else {
  print("❌ POOR AGREEMENT: Methods find very different cluster structures")
}

# ========== 4. SILHOUETTE COMPARISON ==========
print("\n4. SILHOUETTE SCORE COMPARISON")
print("===============================\n")

# K-Means silhouette
sil_km <- silhouette(kmeans_clusters, dist(train_data_scaled))
avg_sil_km <- mean(sil_km[, 3])

# Hierarchical silhouette
sil_hc <- silhouette(hc_clusters, dist(train_data_scaled))
avg_sil_hc <- mean(sil_hc[, 3])

cat(sprintf("K-Means Silhouette:       %.4f\n", avg_sil_km))
cat(sprintf("Hierarchical Silhouette:  %.4f\n", avg_sil_hc))
cat(sprintf("Difference:               %.4f\n", abs(avg_sil_km - avg_sil_hc)))

if (avg_sil_km > avg_sil_hc) {
  print("→ K-Means has slightly better cluster separation")
} else {
  print("→ Hierarchical has slightly better cluster separation")
}

# ========== 5. COMPARISON PLOT ==========
print("\n5. Creating comparison visualization...\n")

png("models/hierarchical/km_vs_hc_comparison.png", width = 14, height = 7, res = 100)

par(mfrow = c(1, 2))

# K-Means plot
plot(train_data_scaled, col = kmeans_clusters, pch = 19, cex = 0.8,
     main = paste("K-Means Clusters (Sil =", round(avg_sil_km, 3), ")"),
     xlab = "Annual Income (scaled)", ylab = "Spending Score (scaled)")

# Add centroids
points(kmeans_model$centers, col = 1:5, pch = 8, cex = 2, lwd = 2)

# Hierarchical plot
plot(train_data_scaled, col = hc_clusters, pch = 19, cex = 0.8,
     main = paste("Hierarchical Clusters (Sil =", round(avg_sil_hc, 3), ")"),
     xlab = "Annual Income (scaled)", ylab = "Spending Score (scaled)")

dev.off()
print("✓ Saved: km_vs_hc_comparison.png")

# ========== 6. SUMMARY ==========
print("\n\n========== COMPARISON SUMMARY ==========\n")

cat(sprintf("Metric                    K-Means     Hierarchical\n"))
cat(sprintf("────────────────────────────────────────────────\n"))
cat(sprintf("Silhouette Score          %.3f        %.3f\n", avg_sil_km, avg_sil_hc))
cat(sprintf("Adjusted Rand Index       -            %.3f\n", ari))

print("\n✓ Comparison complete!")
print("✓ Task 5.9 Complete!")
