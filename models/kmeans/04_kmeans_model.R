# ============================================
# TASK 4.4 & 4.5: BUILD K-MEANS MODEL & TEST VALIDATION
# ============================================

library(cluster)
library(tidyverse)

# Load training and test data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")
test_data_scaled <- readRDS("models/kmeans/test_data_scaled.rds")
test_df_original <- readRDS("models/kmeans/test_df_original.rds")

print("Building K-Means Model on TRAINING DATA (160 customers)...")
set.seed(42)  # For reproducibility

# Train model
kmeans_model <- kmeans(
  train_data_scaled,
  centers = 5,
  iter.max = 100,
  nstart = 25,
  algorithm = "Hartigan-Wong"
)

# Save model
saveRDS(kmeans_model, "models/kmeans/kmeans_model_k5.rds")
print("✓ Saved models/kmeans/kmeans_model_k5.rds")

# ========== TRAIN PERFORMANCE ==========
print("\n========== TRAINING SET PERFORMANCE ==========")
print(paste("Train WCSS:", round(kmeans_model$tot.withinss, 2)))
silhouette_train <- silhouette(kmeans_model$cluster, dist(train_data_scaled))
avg_silhouette_train <- mean(silhouette_train[, 3])
print(paste("Train Avg Silhouette Width:", round(avg_silhouette_train, 3)))

# ========== APPLY TO TEST SET (VALIDATION) ==========
print("\n========== TEST SET VALIDATION ==========")

# Function to assign test points to closest cluster center
predict_kmeans <- function(newdata, centers) {
  # Calculate Euclidean distance to each cluster center
  dists <- apply(newdata, 1, function(row) {
    apply(centers, 1, function(center) {
      sum((row - center)^2)
    })
  })
  # If 1D center matrix, handle dimensions
  if (is.null(dim(dists))) {
    return(which.min(dists))
  }
  apply(dists, 2, which.min)
}

test_clusters <- predict_kmeans(as.matrix(test_data_scaled), kmeans_model$centers)
test_df_original$KMeans_Cluster <- test_clusters
train_df_original$KMeans_Cluster <- kmeans_model$cluster

print("✓ Successfully assigned test observations to nearest cluster centers.")

# Calculate silhouette coefficient for test data
silhouette_test <- silhouette(test_clusters, dist(test_data_scaled))
avg_silhouette_test <- mean(silhouette_test[, 3])
print(paste("Test Avg Silhouette Width:", round(avg_silhouette_test, 3)))

# Save clustered outputs
write.csv(train_df_original, "models/kmeans/train_data_clustered.csv", row.names = FALSE)
write.csv(test_df_original, "models/kmeans/test_data_clustered.csv", row.names = FALSE)

# Save test clusters and profiles
saveRDS(test_clusters, "models/kmeans/test_clusters.rds")

print("\n✓ Task 4.4 & 4.5 Complete!")
