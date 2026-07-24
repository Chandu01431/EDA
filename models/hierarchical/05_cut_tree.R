# ============================================
# TASK 5.5: CUT TREE AT k=5
# ============================================

library(cluster)
library(tidyverse)

print("========================================")
print("CUTTING DENDROGRAM AT k=5")
print("========================================\n")

# Load model and training data
hc_model <- readRDS("models/hierarchical/hc_model.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")

# ========== CUT TREE AT k=5 ==========
print("Cutting tree to create 5 clusters...\n")

hc_clusters <- cutree(hc_model, k = 5)

print("✓ Tree cut successfully!")
print(paste("Cluster assignments created for", length(hc_clusters), "customers"))

# ========== CLUSTER SIZES ==========
print("\n========== HIERARCHICAL CLUSTER SIZES (TRAINING) ==========\n")

cluster_sizes <- table(hc_clusters)
print("Cluster sizes:")
print(cluster_sizes)

print("\nCluster percentages:")
cluster_pct <- round(cluster_sizes / sum(cluster_sizes) * 100, 1)
for (i in 1:length(cluster_sizes)) {
  print(paste("Cluster", i, ":", cluster_sizes[i], "customers (", 
              cluster_pct[i], "%)", sep = ""))
}

# Check balance
min_size <- min(cluster_sizes)
max_size <- max(cluster_sizes)
balance_ratio <- max_size / min_size

print(paste("\nBalance ratio (max/min):", round(balance_ratio, 2)))
if (balance_ratio < 3) {
  print("✓ GOOD: Clusters are balanced")
} else if (balance_ratio < 5) {
  print("⚠ WARNING: Some imbalance")
} else {
  print("❌ PROBLEM: Highly imbalanced")
}

# ========== ADD CLUSTERS TO DATA ==========
print("\n========== ADDING CLUSTER ASSIGNMENTS ==========\n")

train_df_original$HC_Cluster <- hc_clusters

print("✓ Cluster assignments added to training data")

# Display sample
print("\nFirst 10 customers with HC clusters:")
print(head(train_df_original[, c("CustomerID", "Annual_Income", "Spending_Score", "HC_Cluster")], 10))

# ========== CLUSTER PROFILES ==========
print("\n========== HIERARCHICAL CLUSTER PROFILES (ORIGINAL SCALE) ==========\n")

cluster_profiles_hc <- train_df_original %>%
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

print(cluster_profiles_hc)

# ========== SAVE RESULTS ==========
saveRDS(hc_clusters, "models/hierarchical/hc_clusters_training.rds")
saveRDS(cluster_profiles_hc, "models/hierarchical/cluster_profiles_hc_train.rds")
write.csv(train_df_original, "models/hierarchical/train_data_hc_clustered.csv", row.names = FALSE)

print("\n========== SAVE COMPLETE ==========")
print("✓ Cluster assignments saved")
print("✓ Profiles saved")
print("✓ Data with clusters saved")

print("\n✓ Task 5.5 Complete!")
