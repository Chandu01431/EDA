# ============================================
# TASK 5.10: HIERARCHICAL STABILITY ANALYSIS
# ============================================

library(tidyverse)
library(cluster)

print("========================================")
print("HIERARCHICAL CLUSTERING - STABILITY ANALYSIS")
print("========================================\n")

# Load data
hc_clusters_train <- readRDS("models/hierarchical/hc_clusters_training.rds")
hc_clusters_test <- readRDS("models/hierarchical/hc_clusters_test.rds")
cluster_profiles_hc_train <- readRDS("models/hierarchical/cluster_profiles_hc_train.rds")
cluster_profiles_hc_test <- readRDS("models/hierarchical/cluster_profiles_hc_test.rds")
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
test_data_scaled <- readRDS("models/kmeans/test_data_scaled.rds")

print("1. CLUSTER SIZE DISTRIBUTION (Training vs Testing)")
print("==================================================\n")

train_sizes <- as.data.frame(table(hc_clusters_train))
colnames(train_sizes) <- c("Cluster", "Train_Count")
train_sizes$Train_Pct <- round(train_sizes$Train_Count / 160 * 100, 1)

test_sizes <- as.data.frame(table(hc_clusters_test))
colnames(test_sizes) <- c("Cluster", "Test_Count")
test_sizes$Test_Pct <- round(test_sizes$Test_Count / 40 * 100, 1)

size_comparison <- full_join(train_sizes, test_sizes, by = "Cluster")
print(size_comparison)

# ========== 2. CENTROID COMPARISON ==========
print("\n2. CENTROID STABILITY (Income & Spending)")
print("===========================================\n")

centroid_comparison <- full_join(
  cluster_profiles_hc_train %>% 
    select(HC_Cluster, Train_Income = Avg_Income, Train_Spending = Avg_Spending),
  cluster_profiles_hc_test %>%
    select(HC_Cluster, Test_Income = Avg_Income, Test_Spending = Avg_Spending),
  by = "HC_Cluster"
) %>%
  mutate(
    Income_Diff = abs(Train_Income - Test_Income),
    Spending_Diff = abs(Train_Spending - Test_Spending)
  )

print(centroid_comparison)

avg_income_diff <- mean(centroid_comparison$Income_Diff, na.rm = TRUE)
avg_spending_diff <- mean(centroid_comparison$Spending_Diff, na.rm = TRUE)

cat(sprintf("\nAverage centroid drift (Income):  %.1f units\n", avg_income_diff))
cat(sprintf("Average centroid drift (Spending): %.1f units\n", avg_spending_diff))

# ========== 3. SILHOUETTE COMPARISON ==========
print("\n3. SILHOUETTE SCORE COMPARISON")
print("===============================\n")

silhouette_train <- silhouette(hc_clusters_train, dist(train_data_scaled))
avg_sil_train <- mean(silhouette_train[, 3])

combined_scaled <- rbind(train_data_scaled, test_data_scaled)
combined_dist <- dist(combined_scaled, method = "euclidean")
combined_hc <- hclust(combined_dist, method = "ward.D2")
combined_clusters <- cutree(combined_hc, k = 5)
test_clusters <- combined_clusters[(nrow(train_data_scaled) + 1):length(combined_clusters)]

silhouette_test <- silhouette(test_clusters, dist(test_data_scaled))
avg_sil_test <- mean(silhouette_test[, 3])

cat(sprintf("Training Silhouette Score: %.4f\n", avg_sil_train))
cat(sprintf("Testing Silhouette Score:  %.4f\n", avg_sil_test))
cat(sprintf("Difference: %.4f\n", abs(avg_sil_train - avg_sil_test)))

# ========== 4. OVERALL CONCLUSION ==========
print("\n\n========== STABILITY CONCLUSION ==========\n")

if (avg_income_diff < 5 && avg_spending_diff < 5 && abs(avg_sil_train - avg_sil_test) < 0.05) {
  cat("✓✓✓ HIERARCHICAL CLUSTERS ARE HIGHLY STABLE ✓✓✓\n")
  cat("The 5-cluster solution generalizes well to unseen data.\n")
} else {
  cat("~ Clusters show some variation between train/test\n")
  cat("Consider: Re-training on full dataset for production use.\n")
}

print("\n✓ Stability analysis complete!")
print("✓ Task 5.10 Complete!")

