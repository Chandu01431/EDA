# ============================================
# TASK 5.9: K-MEANS vs HIERARCHICAL COMPARISON
# ============================================

library(tidyverse)
library(cluster)
library(factoextra)
library(mclust)

print("========================================")
print("METHOD COMPARISON: K-MEANS vs HIERARCHICAL")
print("========================================\n")

# ============================================
# LOAD DATA
# ============================================

kmeans_model <- readRDS("models/kmeans/kmeans_model_trained.rds")
hc_model <- readRDS("models/hierarchical/hc_model.rds")
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")

kmeans_clusters <- kmeans_model$cluster
hc_clusters <- readRDS("models/hierarchical/hc_clusters_training.rds")

print("✓ Both models loaded successfully!\n")

# ============================================
# 1. CLUSTER SIZE COMPARISON
# ============================================

print("1. CLUSTER SIZE DISTRIBUTION")
print("===============================\n")

km_sizes <- table(kmeans_clusters)
hc_sizes <- table(hc_clusters)

size_compare <- data.frame(
  Cluster = sort(unique(kmeans_clusters)),
  KMeans_Count = as.numeric(km_sizes),
  KMeans_Pct = round(as.numeric(km_sizes) / sum(km_sizes) * 100, 1),
  Hierarchical_Count = as.numeric(hc_sizes),
  Hierarchical_Pct = round(as.numeric(hc_sizes) / sum(hc_sizes) * 100, 1)
)

print(size_compare)

# ============================================
# 2. CLUSTER OVERLAP
# ============================================

print("\n2. CLUSTER OVERLAP (Cross-tabulation)")
print("======================================\n")

cross_table <- table(
  KMeans = kmeans_clusters,
  Hierarchical = hc_clusters
)

print(cross_table)

agreement <- sum(diag(cross_table)) / sum(cross_table) * 100

cat(sprintf("\nSimple Agreement Rate : %.2f%%\n", agreement))

# ============================================
# 3. ADJUSTED RAND INDEX
# ============================================

print("\n3. ADJUSTED RAND INDEX")
print("=======================\n")

ari <- adjustedRandIndex(kmeans_clusters, hc_clusters)

cat(sprintf("Adjusted Rand Index : %.3f\n\n", ari))

if (ari >= 0.70) {
  
  print("✓ Strong Agreement between methods")
  
} else if (ari >= 0.50) {
  
  print("✓ Moderate Agreement between methods")
  
} else if (ari >= 0.30) {
  
  print("✓ Weak Agreement between methods")
  
} else {
  
  print("✗ Poor Agreement between methods")
  
}

# ============================================
# 4. SILHOUETTE COMPARISON
# ============================================

print("\n4. SILHOUETTE COMPARISON")
print("=========================\n")

distance_matrix <- dist(train_data_scaled)

sil_km <- silhouette(kmeans_clusters, distance_matrix)
sil_hc <- silhouette(hc_clusters, distance_matrix)

avg_sil_km <- mean(sil_km[,3])
avg_sil_hc <- mean(sil_hc[,3])

cat(sprintf("K-Means Silhouette      : %.4f\n", avg_sil_km))
cat(sprintf("Hierarchical Silhouette : %.4f\n", avg_sil_hc))
cat(sprintf("Difference              : %.4f\n",
            abs(avg_sil_km - avg_sil_hc)))

if(avg_sil_km > avg_sil_hc){
  
  print("✓ K-Means performs slightly better")
  
} else if(avg_sil_hc > avg_sil_km){
  
  print("✓ Hierarchical performs slightly better")
  
} else{
  
  print("✓ Both methods perform equally")
  
}

# ============================================
# 5. VISUAL COMPARISON
# ============================================

print("\nCreating comparison plot...\n")

png(
  filename = "models/hierarchical/km_vs_hc_comparison.png",
  width = 1400,
  height = 700,
  res = 100
)

par(
  mfrow = c(1,2),
  mar = c(5,5,4,2)
)

# -------------------------------
# K-Means Plot
# -------------------------------

plot(
  train_data_scaled,
  col = kmeans_clusters,
  pch = 19,
  cex = 0.8,
  main = paste(
    "K-Means Clusters\nSilhouette =",
    round(avg_sil_km,3)
  ),
  xlab = "Annual Income (Scaled)",
  ylab = "Spending Score (Scaled)"
)

points(
  kmeans_model$centers,
  pch = 8,
  col = 1:length(unique(kmeans_clusters)),
  cex = 2,
  lwd = 2
)

legend(
  "topright",
  legend = paste("Cluster", sort(unique(kmeans_clusters))),
  col = sort(unique(kmeans_clusters)),
  pch = 19,
  cex = 0.8
)

# -------------------------------
# Hierarchical Plot
# -------------------------------

plot(
  train_data_scaled,
  col = hc_clusters,
  pch = 19,
  cex = 0.8,
  main = paste(
    "Hierarchical Clusters\nSilhouette =",
    round(avg_sil_hc,3)
  ),
  xlab = "Annual Income (Scaled)",
  ylab = "Spending Score (Scaled)"
)

legend(
  "topright",
  legend = paste("Cluster", sort(unique(hc_clusters))),
  col = sort(unique(hc_clusters)),
  pch = 19,
  cex = 0.8
)

dev.off()

print("✓ Comparison image saved successfully!")

# ============================================
# 6. SUMMARY TABLE
# ============================================

print("\n========================================")
print("FINAL COMPARISON SUMMARY")
print("========================================\n")

summary_table <- data.frame(
  
  Metric = c(
    "Average Silhouette Score",
    "Adjusted Rand Index"
  ),
  
  KMeans = c(
    round(avg_sil_km,4),
    "-"
  ),
  
  Hierarchical = c(
    round(avg_sil_hc,4),
    round(ari,4)
  )
  
)

print(summary_table)

cat("\n========================================\n")

if(avg_sil_km > avg_sil_hc){
  
  cat("Best Clustering Method : K-Means\n")
  
} else{
  
  cat("Best Clustering Method : Hierarchical\n")
  
}

cat(sprintf("Adjusted Rand Index : %.3f\n", ari))

cat("========================================\n")

print("✓ Comparison Complete!")
print("✓ Task 5.9 Completed Successfully!")

