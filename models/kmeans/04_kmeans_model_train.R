# ============================================
# TASK 4.4: BUILD K-MEANS MODEL (k=5) ON TRAINING DATA
# ============================================

library(cluster)
library(tidyverse)

# Load training data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")

print("Building K-Means Model on TRAINING DATA (160 customers)")
print("k = 5 clusters")

# ========== BUILD K-MEANS MODEL ==========
set.seed(42)  # For reproducibility

kmeans_model <- kmeans(
  train_data_scaled,
  centers = 5,          # Number of clusters
  iter.max = 100,       # Maximum iterations
  nstart = 25,          # 25 random starts
  algorithm = "Hartigan-Wong"
)

print("\n✓ K-Means model trained!")

# ========== MODEL SUMMARY ==========
print("\n========== MODEL SUMMARY ==========")
print(paste("Number of clusters: ", kmeans_model$centers[1, 1], "×", 
            nrow(kmeans_model$centers), sep = ""))
print(paste("Cluster sizes (training data):", 
            paste(table(kmeans_model$cluster), collapse = ", ")))
print(paste("Total iterations: ", kmeans_model$iter, sep = ""))
print(paste("Converged: ", kmeans_model$converged, sep = ""))

# ========== CLUSTER CENTERS (SCALED) ==========
print("\n========== CLUSTER CENTERS (SCALED) ==========")
print(kmeans_model$centers)

# ========== CLUSTER SIZES ==========
print("\n========== CLUSTER SIZES (TRAINING DATA) ==========")
cluster_sizes <- table(kmeans_model$cluster)
print(cluster_sizes)
print(paste("Total:", sum(cluster_sizes)))

# ========== WITHIN-CLUSTER SUM OF SQUARES ==========
print("\n========== MODEL PERFORMANCE ==========")
print(paste("Total within-cluster sum of squares: ", 
            round(kmeans_model$tot.withinss, 2), sep = ""))
print(paste("Between-cluster sum of squares: ", 
            round(kmeans_model$betweenss, 2), sep = ""))

# Calculate silhouette coefficient for training data
silhouette_train <- silhouette(kmeans_model$cluster, dist(train_data_scaled))
avg_silhouette_train <- mean(silhouette_train[, 3])

print(paste("Average silhouette width (training): ", 
            round(avg_silhouette_train, 3), sep = ""))

# ========== ADD CLUSTER ASSIGNMENTS TO TRAINING DATA ==========
train_df_original$KMeans_Cluster <- kmeans_model$cluster

# ========== CLUSTER PROFILES (TRAINING DATA) ==========
print("\n========== CLUSTER PROFILES (TRAINING DATA - ORIGINAL SCALE) ==========")

cluster_profiles_train <- train_df_original %>%
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

print(cluster_profiles_train)

# ========== SAVE MODEL AND DATA ==========
saveRDS(kmeans_model, "models/kmeans/kmeans_model_trained.rds")
saveRDS(cluster_profiles_train, "models/kmeans/cluster_profiles_train.rds")
write.csv(train_df_original, "models/kmeans/train_data_clustered.csv", row.names = FALSE)

print("\n✓ Model saved to: kmeans_model_trained.rds")
print("✓ Training data with clusters saved to: train_data_clustered.csv")
print("✓ Cluster profiles saved to: cluster_profiles_train.rds")

print("\n✓ Task 4.4 Complete!")

