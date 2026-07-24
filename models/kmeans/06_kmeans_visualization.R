# ============================================
# TASK 4.6: CLUSTER VISUALIZATION
# ============================================

library(tidyverse)
library(cluster)
library(factoextra)

# Load data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
test_data_scaled <- readRDS("models/kmeans/test_data_scaled.rds")
kmeans_model <- readRDS("models/kmeans/kmeans_model_trained.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")
test_df_original <- readRDS("models/kmeans/test_df_original.rds")

print("Creating cluster visualizations...")

# ========== VISUALIZATION 1: TRAINING DATA CLUSTERS ==========
print("\n1. Creating training data cluster plot...")

png("models/kmeans/clusters_train_scaled.png", width = 10, height = 8, res = 100)

fviz_cluster(kmeans_model,
             data = train_data_scaled,
             geom = "point",
             ellipse.type = "convex",
             palette = "Set2",
             ggtheme = theme_minimal(),
             main = "K-Means Clusters (k=5) - Training Data (80%)",
             xlab = "Annual Income (scaled)",
             ylab = "Spending Score (scaled)") +
  theme(legend.position = "bottom")

dev.off()
print("  ✓ Saved: clusters_train_scaled.png")

# ========== VISUALIZATION 2: TRAINING DATA WITH ORIGINAL SCALE ==========
print("\n2. Creating original scale cluster plot...")

train_df_original$KMeans_Cluster <- as.factor(kmeans_model$cluster)

png("models/kmeans/clusters_train_original.png", width = 10, height = 8, res = 100)

ggplot(train_df_original, aes(x = Annual_Income, y = Spending_Score, 
                               color = KMeans_Cluster)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "K-Means Clusters (k=5) - Training Data (Original Scale)",
    x = "Annual Income ($k)",
    y = "Spending Score (1-100)",
    color = "Cluster"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

dev.off()
print("  ✓ Saved: clusters_train_original.png")

# ========== VISUALIZATION 3: TEST DATA CLUSTERS ==========
print("\n3. Creating test data cluster plot...")

test_clusters <- readRDS("models/kmeans/cluster_profiles_test.rds")
# Re-predict clusters for visualization
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

test_df_original$KMeans_Cluster <- as.factor(predict_cluster(test_data_scaled))

png("models/kmeans/clusters_test_original.png", width = 10, height = 8, res = 100)

ggplot(test_df_original, aes(x = Annual_Income, y = Spending_Score, 
                              color = KMeans_Cluster)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "K-Means Clusters (k=5) - Test Data (Original Scale)",
    x = "Annual Income ($k)",
    y = "Spending Score (1-100)",
    color = "Cluster"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

dev.off()
print("  ✓ Saved: clusters_test_original.png")

# ========== VISUALIZATION 4: SIDE-BY-SIDE COMPARISON ==========
print("\n4. Creating train vs test comparison plot...")

# Combine train and test data with labels
train_plot <- train_df_original
train_plot$Dataset <- "Training (80%)"

test_plot <- test_df_original
test_plot$Dataset <- "Testing (20%)"

combined <- rbind(train_plot, test_plot)

png("models/kmeans/clusters_train_vs_test.png", width = 14, height = 7, res = 100)

ggplot(combined, aes(x = Annual_Income, y = Spending_Score, 
                      color = KMeans_Cluster)) +
  geom_point(size = 2.5, alpha = 0.7) +
  facet_wrap(~ Dataset, ncol = 2) +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "K-Means Clusters: Training vs Testing Comparison (k=5)",
    x = "Annual Income ($k)",
    y = "Spending Score (1-100)",
    color = "Cluster",
    caption = "Training: 160 customers | Testing: 40 customers"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

dev.off()
print("  ✓ Saved: clusters_train_vs_test.png")

# ========== VISUALIZATION 5: CLUSTER PROFILES BAR CHART ==========
print("\n5. Creating cluster profile comparison chart...")

cluster_profiles_train <- readRDS("models/kmeans/cluster_profiles_train.rds")

# Reshape for plotting
profile_long <- cluster_profiles_train %>%
  select(KMeans_Cluster, Avg_Income, Avg_Spending) %>%
  pivot_longer(cols = c(Avg_Income, Avg_Spending), 
               names_to = "Metric", 
               values_to = "Value") %>%
  mutate(Metric = recode(Metric, 
                         Avg_Income = "Annual Income ($k)",
                         Avg_Spending = "Spending Score"))

png("models/kmeans/cluster_profiles_bar.png", width = 10, height = 7, res = 100)

ggplot(profile_long, aes(x = as.factor(KMeans_Cluster), y = Value, fill = as.factor(KMeans_Cluster))) +
  geom_bar(stat = "identity", width = 0.7) +
  facet_wrap(~ Metric, scales = "free_y", ncol = 2) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Cluster Profiles Comparison",
    x = "Cluster",
    y = "Average Value",
    fill = "Cluster",
    caption = "Each bar shows the cluster centroid in original units"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

dev.off()
print("  ✓ Saved: cluster_profiles_bar.png")

print("\n✓ All visualizations complete!")
print("✓ Task 4.6 Complete!")
