# ============================================
# TASK 5.6: HIERARCHICAL CLUSTER VISUALIZATION
# ============================================

library(tidyverse)
library(cluster)
library(factoextra)

print("========================================")
print("HIERARCHICAL CLUSTER VISUALIZATION")
print("========================================\n")

# Load data
hc_model <- readRDS("models/hierarchical/hc_model.rds")
hc_clusters <- readRDS("models/hierarchical/hc_clusters_training.rds")
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")

train_df_original$HC_Cluster <- as.factor(hc_clusters)

# ========== PLOT 1: SCATTER PLOT OF HIERARCHICAL CLUSTERS ==========
print("1. Creating scatter plot (original scale)...")

png("models/hierarchical/hc_clusters_original.png", width = 10, height = 8, res = 100)

ggplot(train_df_original, aes(x = Annual_Income, y = Spending_Score, 
                               color = HC_Cluster)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "Hierarchical Clusters (k=5) - Training Data (Original Scale)",
    x = "Annual Income ($k)",
    y = "Spending Score (1-100)",
    color = "HC Cluster"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

dev.off()
print("  ✓ Saved: hc_clusters_original.png")

# ========== PLOT 2: CLUSTER PLOT USING fviz ==========
print("\n2. Creating fviz cluster plot (scaled data)...")

png("models/hierarchical/hc_clusters_scaled.png", width = 10, height = 8, res = 100)

fviz_cluster(list(data = train_data_scaled, cluster = hc_clusters),
             ellipse.type = "convex",
             palette = "Set2",
             ggtheme = theme_minimal(),
             main = "Hierarchical Clusters (k=5) - Training Data (Scaled)")

dev.off()
print("  ✓ Saved: hc_clusters_scaled.png")

# ========== PLOT 3: CLUSTER SIZES BAR CHART ==========
print("\n3. Creating cluster size comparison...")

cluster_sizes <- as.data.frame(table(hc_clusters))
colnames(cluster_sizes) <- c("Cluster", "Count")

png("models/hierarchical/hc_cluster_sizes.png", width = 10, height = 7, res = 100)

ggplot(cluster_sizes, aes(x = Cluster, y = Count, fill = Cluster)) +
  geom_bar(stat = "identity", width = 0.6) +
  geom_text(aes(label = Count), vjust = -0.5, size = 5) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Hierarchical Cluster Sizes (Training Data)",
    x = "Cluster",
    y = "Number of Customers"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "none"
  )

dev.off()
print("  ✓ Saved: hc_cluster_sizes.png")

# ========== PLOT 4: CLUSTER PROFILES BAR CHART ==========
print("\n4. Creating cluster profile comparison...")

cluster_profiles_hc <- readRDS("models/hierarchical/cluster_profiles_hc_train.rds")

profile_long <- cluster_profiles_hc %>%
  select(HC_Cluster, Avg_Income, Avg_Spending) %>%
  pivot_longer(cols = c(Avg_Income, Avg_Spending), 
               names_to = "Metric", 
               values_to = "Value") %>%
  mutate(Metric = recode(Metric, 
                         Avg_Income = "Annual Income ($k)",
                         Avg_Spending = "Spending Score"))

png("models/hierarchical/hc_profiles_bar.png", width = 10, height = 7, res = 100)

ggplot(profile_long, aes(x = as.factor(HC_Cluster), y = Value, fill = as.factor(HC_Cluster))) +
  geom_bar(stat = "identity", width = 0.7) +
  facet_wrap(~ Metric, scales = "free_y", ncol = 2) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Hierarchical Cluster Profiles Comparison",
    x = "Cluster",
    y = "Average Value",
    fill = "Cluster"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

dev.off()
print("  ✓ Saved: hc_profiles_bar.png")

print("\n✓ All visualizations complete!")
print("✓ Task 5.6 Complete!")
