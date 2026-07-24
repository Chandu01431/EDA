# ============================================
# TASK 4.8: STABILITY ANALYSIS (TRAIN vs TEST)
# ============================================

library(tidyverse)
library(cluster)

# Load data
kmeans_model <- readRDS("models/kmeans/kmeans_model_trained.rds")
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
test_data_scaled <- readRDS("models/kmeans/test_data_scaled.rds")
cluster_profiles_train <- readRDS("models/kmeans/cluster_profiles_train.rds")
cluster_profiles_test <- readRDS("models/kmeans/cluster_profiles_test.rds")

print("========== K-MEANS STABILITY ANALYSIS ==========")
print("Comparing model performance on Training (80%) vs Testing (20%)\n")

# ========== 1. CLUSTER SIZE COMPARISON ==========
print("1. CLUSTER SIZE DISTRIBUTION")
print("   (Comparing proportion of customers in each cluster)")

train_sizes <- cluster_profiles_train %>% 
  mutate(Pct = round(Count / sum(Count) * 100, 1)) %>%
  select(KMeans_Cluster, Train_Count = Count, Train_Pct = Pct)

test_sizes <- cluster_profiles_test %>%
  mutate(Pct = round(Count / sum(Count) * 100, 1)) %>%
  select(KMeans_Cluster, Test_Count = Count, Test_Pct = Pct)

size_comparison <- full_join(train_sizes, test_sizes, by = "KMeans_Cluster")

print(size_comparison)

# ========== 2. CENTROID COMPARISON ==========
print("\n2. CENTROID COMPARISON (Original Scale)")
print("   (Comparing average income and spending)")

centroid_comparison <- full_join(
  cluster_profiles_train %>% 
    select(KMeans_Cluster, Train_Income = Avg_Income, Train_Spending = Avg_Spending),
  cluster_profiles_test %>%
    select(KMeans_Cluster, Test_Income = Avg_Income, Test_Spending = Avg_Spending),
  by = "KMeans_Cluster"
) %>%
  mutate(
    Income_Diff = abs(Train_Income - Test_Income),
    Spending_Diff = abs(Train_Spending - Test_Spending),
    Income_Similarity = round((1 - Income_Diff / pmax(Train_Income, Test_Income)) * 100, 1),
    Spending_Similarity = round((1 - Spending_Diff / pmax(Train_Spending, Test_Spending)) * 100, 1)
  )

print(centroid_comparison)

# ========== 3. SILHOUETTE COMPARISON ==========
print("\n3. SILHOUETTE SCORE COMPARISON")

# Training silhouette
silhouette_train <- silhouette(kmeans_model$cluster, dist(train_data_scaled))
avg_sil_train <- mean(silhouette_train[, 3])

# Testing silhouette - re-predict
centers <- kmeans_model$centers
predict_cluster <- function(newdata) {
  n_new <- nrow(newdata)
  n_centers <- nrow(centers)
  distances <- matrix(NA, n_new, n_centers)
  for (i in 1:n_centers) {
    distances[, i] <- sqrt(rowSums((newdata - matrix(rep(centers[i, ], n_new), 
                                                      nrow = n_new, byrow = TRUE))^2))
  }
  apply(distances, 1, which.min)
}

test_clusters <- predict_cluster(test_data_scaled)
silhouette_test <- silhouette(test_clusters, dist(test_data_scaled))
avg_sil_test <- mean(silhouette_test[, 3])

cat(sprintf("Training Silhouette Score: %.4f\n", avg_sil_train))
cat(sprintf("Testing Silhouette Score:  %.4f\n", avg_sil_test))
cat(sprintf("Difference: %.4f\n", abs(avg_sil_train - avg_sil_test)))

if (abs(avg_sil_train - avg_sil_test) < 0.05) {
  cat("✓ Clusters are STABLE - scores are very close!\n")
} else if (abs(avg_sil_train - avg_sil_test) < 0.10) {
  cat("~ Clusters are MODERATELY STABLE - acceptable variation\n")
} else {
  cat("⚠ Clusters show INSTABILITY - investigate further\n")
}

# ========== 4. WITHIN-CLUSTER VARIANCE COMPARISON ==========
print("\n4. WITHIN-CLUSTER VARIANCE COMPARISON")

cat(sprintf("Training: Total within-cluster SS = %.2f\n", kmeans_model$tot.withinss))
cat(sprintf("Training: Between-cluster SS = %.2f\n", kmeans_model$betweenss))

cat(sprintf("\nTraining Within-Cluster SS per point: %.2f\n", 
            kmeans_model$tot.withinss / nrow(train_data_scaled)))

# ========== 5. OVERALL STABILITY CONCLUSION ==========
print("\n\n========== STABILITY CONCLUSION ==========")

income_diffs <- centroid_comparison$Income_Diff
spending_diffs <- centroid_comparison$Spending_Diff

avg_income_diff <- mean(income_diffs, na.rm = TRUE)
avg_spending_diff <- mean(spending_diffs, na.rm = TRUE)

cat(sprintf("Average centroid drift (Income):  %.1f units\n", avg_income_diff))
cat(sprintf("Average centroid drift (Spending): %.1f units\n", avg_spending_diff))
cat(sprintf("Silhouette difference: %.4f\n", abs(avg_sil_train - avg_sil_test)))

if (avg_income_diff < 5 && avg_spending_diff < 5 && abs(avg_sil_train - avg_sil_test) < 0.05) {
  cat("\n✓✓✓ CLUSTERS ARE HIGHLY STABLE ✓✓✓\n")
  cat("The 5-cluster solution generalizes well to unseen data.\n")
  cat("Recommendation: Use k=5 for customer segmentation.\n")
} else {
  cat("\n~ Clusters show some variation between train/test\n")
  cat("Consider: Re-training on full dataset for production use.\n")
}

print("\n✓ Stability analysis complete!")
print("✓ Task 4.8 Complete!")
