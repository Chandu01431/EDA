# ============================================
# TASK 4.4 & 4.5: TRAIN K-MEANS MODEL & TEST VALIDATION
# ============================================
# PREREQUISITE: Run 01_kmeans_setup.R first to generate the RDS split files.
# ============================================

library(cluster)
library(tidyverse)

# ---- Load train/test splits saved by 01_kmeans_setup.R ----
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")
test_data_scaled  <- readRDS("models/kmeans/test_data_scaled.rds")
test_df_original  <- readRDS("models/kmeans/test_df_original.rds")

# ---- TASK 4.4: Build K-Means Model on 80% Training Data ----
cat("Building K-Means model with k=5 on TRAINING DATA (", nrow(train_data_scaled), "customers)...\n")

set.seed(42)  # Ensures reproducible cluster assignments

kmeans_model <- kmeans(
  train_data_scaled,
  centers   = 5,               # 5 clusters chosen from Elbow + Silhouette analysis
  nstart    = 25,              # Try 25 random starts and keep best
  iter.max  = 100,             # Maximum iterations per run
  algorithm = "Hartigan-Wong"  # Most robust K-Means algorithm
)

cat("✓ K-Means model trained!\n")

# ---- Training Performance ----
cat("\n--- TRAINING PERFORMANCE ---\n")
cat("Cluster sizes (training):", paste(table(kmeans_model$cluster), collapse = " | "), "\n")
cat("Total WCSS (training):", round(kmeans_model$tot.withinss, 2), "\n")

# Silhouette score on training data
sil_train <- silhouette(kmeans_model$cluster, dist(train_data_scaled))
cat("Avg Silhouette Width (training):", round(mean(sil_train[, 3]), 3), "\n")

# ---- Save the model as a real RDS file ----
saveRDS(kmeans_model, "models/kmeans/kmeans_model_k5.rds")
cat("✓ Saved: models/kmeans/kmeans_model_k5.rds\n")

# ---- Add cluster labels to training data ----
train_df_original$KMeans_Cluster <- kmeans_model$cluster

# ---- TASK 4.5: Apply Model to Test Data (Validation) ----
cat("\n--- APPLYING MODEL TO TEST DATA (", nrow(test_data_scaled), "customers) ---\n")

# Assign each test point to the closest training cluster center
# We compute Euclidean distance from each test point to all 5 cluster centers
assign_to_cluster <- function(test_data, centers) {
  apply(as.matrix(test_data), 1, function(point) {
    dists <- apply(centers, 1, function(center) sqrt(sum((point - center)^2)))
    which.min(dists)
  })
}

test_clusters <- assign_to_cluster(test_data_scaled, kmeans_model$centers)
test_df_original$KMeans_Cluster <- test_clusters

cat("Test cluster distribution:", paste(table(test_clusters), collapse = " | "), "\n")

# Silhouette score on test data
sil_test <- silhouette(test_clusters, dist(test_data_scaled))
cat("Avg Silhouette Width (test):", round(mean(sil_test[, 3]), 3), "\n")

# ---- Save clustered data ----
write.csv(train_df_original, "models/kmeans/train_data_clustered.csv", row.names = FALSE)
write.csv(test_df_original,  "models/kmeans/test_data_clustered.csv",  row.names = FALSE)
cat("✓ Saved: train_data_clustered.csv and test_data_clustered.csv\n")

cat("\n✓ Task 4.4 & 4.5 Complete! Run 05_kmeans_visualization.R next.\n")
