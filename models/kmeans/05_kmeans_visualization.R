# ============================================
# TASK 4.6: CLUSTER VISUALIZATION (ggplot2)
# ============================================

library(ggplot2)
library(tidyverse)

# Load clustered datasets
train_df <- read.csv("models/kmeans/train_data_clustered.csv")
test_df <- read.csv("models/kmeans/test_data_clustered.csv")

# Combine datasets with a source column for comparison plot
train_df$Set <- "Train (80%)"
test_df$Set <- "Test (20%)"
combined_df <- rbind(train_df, test_df)

# Define cluster colors and names
cluster_colors <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00")

# ========== PLOT: TRAINING CLUSTERS ==========
p_train <- ggplot(train_df, aes(x = Annual_Income, y = Spending_Score, color = factor(KMeans_Cluster))) +
  geom_point(size = 3.5, alpha = 0.8) +
  scale_color_manual(values = cluster_colors, name = "Cluster") +
  labs(
    title = "K-Means Cluster Segments (Training Data)",
    subtitle = "5 clearly defined segments based on Income & Spending Score",
    x = "Annual Income (k$)",
    y = "Spending Score (1-100)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.major = element_line(color = "lightgrey", linetype = "dashed")
  )

print(p_train)

# ========== PLOT: TRAIN VS TEST COMPARISON ==========
p_comparison <- ggplot(combined_df, aes(x = Annual_Income, y = Spending_Score, color = factor(KMeans_Cluster))) +
  geom_point(size = 3, alpha = 0.7) +
  facet_wrap(~Set) +
  scale_color_manual(values = cluster_colors, name = "Cluster") +
  labs(
    title = "K-Means Clustering: Train vs Test Distribution",
    subtitle = "Validation shows cluster patterns are stable and consistent across splits",
    x = "Annual Income (k$)",
    y = "Spending Score (1-100)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.major = element_line(color = "lightgrey", linetype = "dashed"),
    strip.text = element_text(face = "bold", size = 12)
  )

print(p_comparison)

# Save plots
png("models/kmeans/plots/03_kmeans_clusters.png", width = 10, height = 7, units = "in", res = 300)
print(p_train)
dev.off()
print("✓ Saved: 03_kmeans_clusters.png")

png("models/kmeans/plots/04_kmeans_train_vs_test.png", width = 12, height = 6, units = "in", res = 300)
print(p_comparison)
dev.off()
print("✓ Saved: 04_kmeans_train_vs_test.png")

print("\n✓ Task 4.6 Complete!")
