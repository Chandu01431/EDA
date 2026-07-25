# ============================================
# TASK 5.8: APPLY HIERARCHICAL MODEL TO TEST DATA
# ============================================

library(tidyverse)
library(cluster)

print("========================================")
print("APPLYING HIERARCHICAL CLUSTERING TO TEST DATA")
print("========================================\n")

# Load data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
test_data_scaled <- readRDS("models/kmeans/test_data_scaled.rds")
test_df_original <- readRDS("models/kmeans/test_df_original.rds")
hc_model <- readRDS("models/hierarchical/hc_model.rds")

print("Loading test data (40 customers)...")

# ========== COMBINE TRAIN + TEST FOR HIERARCHICAL CLUSTERING ==========
print("\nCombining train and test data for hierarchical clustering...")
print("(Hierarchical clustering needs all data to find cluster structure)\n")

combined_scaled <- rbind(train_data_scaled, test_data_scaled)

# Compute distance on combined data
combined_dist <- dist(combined_scaled, method = "euclidean")

# Run hierarchical clustering on combined data
combined_hc <- hclust(combined_dist, method = "ward.D2")

# Cut tree at k=5
combined_clusters <- cutree(combined_hc, k = 5)

# Extract test cluster assignments (last 40 observations)
test_clusters <- combined_clusters[(nrow(train_data_scaled) + 1):length(combined_clusters)]

print("✓ Test cluster assignments extracted!")

# ========== CLUSTER SIZES ON TEST DATA ==========
print("\n========== HC CLUSTER SIZES (TEST DATA) ==========\n")

test_cluster_sizes <- table(test_clusters)
print(test_cluster_sizes)

# ========== ADD CLUSTERS TO TEST DATA ==========
test_df_original$HC_Cluster <- test_clusters

# ========== TEST DATA CLUSTER PROFILES ==========
print("\n========== HC CLUSTER PROFILES (TEST DATA) ==========\n")

cluster_profiles_hc_test <- test_df_original %>%
  group_by(HC_Cluster) %>%
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

print(cluster_profiles_hc_test)

# ========== COMPARE TRAIN vs TEST ==========
print("\n========== CLUSTER STABILITY: TRAIN vs TEST ==========\n")

cluster_profiles_hc_train <- readRDS("models/hierarchical/cluster_profiles_hc_train.rds")

print("TRAINING Cluster Profiles:")
print(cluster_profiles_hc_train)

print("\nTEST Cluster Profiles:")
print(cluster_profiles_hc_test)

# ========== SAVE RESULTS ==========
saveRDS(test_clusters, "models/hierarchical/hc_clusters_test.rds")
saveRDS(cluster_profiles_hc_test, "models/hierarchical/cluster_profiles_hc_test.rds")
write.csv(test_df_original, "models/hierarchical/test_data_hc_clustered.csv", row.names = FALSE)

print("\n✓ Test results saved!")
print("✓ Task 5.8 Complete!")

