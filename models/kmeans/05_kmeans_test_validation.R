# ============================================
# TASK 4.5: APPLY MODEL TO TEST DATA (20%) - VALIDATION
# ============================================

library(tidyverse)

# Load trained model and test data
kmeans_model <- readRDS("models/kmeans/kmeans_model_trained.rds")
test_data_scaled <- readRDS("models/kmeans/test_data_scaled.rds")
test_df_original <- readRDS("models/kmeans/test_df_original.rds")

print("Applying trained K-Means model to TEST DATA (40 customers)")

# ========== PREDICT CLUSTERS FOR TEST DATA ==========
# Use the trained centers to assign test points to nearest cluster

# Custom predict function for k-means
predict.kmeans <- function(object, newdata) {
  centers <- object$centers
  n_centers <- nrow(centers)
  n_new <- nrow(newdata)
  
  # Calculate distance to each center for each new point
  distances <- matrix(NA, nrow = n_new, ncol = n_centers)
  
  for (i in 1:n_centers) {
    distances[, i] <- sqrt(rowSums((newdata - matrix(rep(centers[i, ], n_new), 
                                                      nrow = n_new, byrow = TRUE))^2))
  }
  
  # Assign to nearest cluster
  apply(distances, 1, which.min)
}

test_clusters <- predict.kmeans(kmeans_model, newdata = test_data_scaled)

# Add cluster assignments to test data
test_df_original$KMeans_Cluster <- test_clusters

print("\n✓ Clusters predicted for test data!")

# ========== CLUSTER SIZES ON TEST DATA ==========
print("\n========== CLUSTER SIZES (TEST DATA) ==========")
test_cluster_sizes <- table(test_clusters)
print(test_cluster_sizes)
print(paste("Total:", sum(test_cluster_sizes)))

# ========== CLUSTER PROFILES ON TEST DATA ==========
print("\n========== CLUSTER PROFILES (TEST DATA - ORIGINAL SCALE) ==========")

cluster_profiles_test <- test_df_original %>%
  group_by(KMeans_Cluster) %>%
  summarise(
    Count = n(),
    Avg_Income = round(mean(Annual_Income), 1),
    Avg_Spending = round(mean(Spending_Score), 1),
    Min_Income = min(Annual_Income),
    Max_Income = max(Annual_Income),
    Min_Spending = min(Spending_Score),
    Max_Spending = max(Spending_Score),
    .groups = 'drop'
  )

print(cluster_profiles_test)

# ========== COMPARE TRAIN vs TEST PROFILES ==========
print("\n========== CLUSTER STABILITY: TRAIN vs TEST ==========")

cluster_profiles_train <- readRDS("models/kmeans/cluster_profiles_train.rds")

print("\nTRAINING DATA Cluster Profiles:")
print(cluster_profiles_train)

print("\nTEST DATA Cluster Profiles:")
print(cluster_profiles_test)

print("\n========== STABILITY ANALYSIS ==========")
print("Comparing average income and spending between train and test:")

for (c in 1:5) {
  train_row <- cluster_profiles_train %>% filter(KMeans_Cluster == c)
  test_row <- cluster_profiles_test %>% filter(KMeans_Cluster == c)
  
  if (nrow(train_row) > 0 && nrow(test_row) > 0) {
    income_diff <- abs(train_row$Avg_Income - test_row$Avg_Income)
    spending_diff <- abs(train_row$Avg_Spending - test_row$Avg_Spending)
    
    cat(sprintf("\nCluster %d:\n", c))
    cat(sprintf("  Income:  Train=%.1f, Test=%.1f, Diff=%.1f\n", 
                train_row$Avg_Income, test_row$Avg_Income, income_diff))
    cat(sprintf("  Spending: Train=%.1f, Test=%.1f, Diff=%.1f\n", 
                train_row$Avg_Spending, test_row$Avg_Spending, spending_diff))
  }
}

# ========== SILHOUETTE COEFFICIENT ON TEST DATA ==========
print("\n========== TEST DATA QUALITY ==========")

library(cluster)
silhouette_test <- silhouette(test_clusters, dist(test_data_scaled))
avg_silhouette_test <- mean(silhouette_test[, 3])

print(paste("Average silhouette width (test): ", 
            round(avg_silhouette_test, 3), sep = ""))

print("\n✓ Test validation complete!")
print("✓ Cluster assignments saved to test data")

# ========== SAVE TEST RESULTS ==========
write.csv(test_df_original, "models/kmeans/test_data_clustered.csv", row.names = FALSE)
saveRDS(cluster_profiles_test, "models/kmeans/cluster_profiles_test.rds")
saveRDS(avg_silhouette_test, "models/kmeans/test_silhouette_score.rds")

print("\n✓ Test results saved!")
print("✓ Task 4.5 Complete!")
