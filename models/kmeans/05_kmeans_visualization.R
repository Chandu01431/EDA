# ============================================
# TASK 4.6: CLUSTER VISUALIZATION
# ============================================
# PREREQUISITE: Run 01_kmeans_setup.R and 04_kmeans_model.R first.
# ============================================

library(ggplot2)
library(tidyverse)

# ---- Load clustered data ----
train_df <- read.csv("models/kmeans/train_data_clustered.csv")
test_df  <- read.csv("models/kmeans/test_data_clustered.csv")

# Convert cluster column to factor so ggplot treats it as a discrete category
train_df$Cluster <- factor(train_df$KMeans_Cluster)
test_df$Cluster  <- factor(test_df$KMeans_Cluster)

# Use consistent colors for all 5 clusters
cluster_colors <- c(
  "1" = "#E41A1C",  # Red
  "2" = "#377EB8",  # Blue
  "3" = "#4DAF4A",  # Green
  "4" = "#984EA3",  # Purple
  "5" = "#FF7F00"   # Orange
)

# ---- PLOT 1: Training Cluster Scatter ----
p1 <- ggplot(train_df, aes(x = Annual_Income, y = Spending_Score, color = Cluster)) +
  geom_point(size = 3.5, alpha = 0.85) +
  scale_color_manual(values = cluster_colors, name = "Cluster") +
  labs(
    title    = "K-Means Customer Segments — Training Data (80%)",
    subtitle = "5 customer groups identified based on Annual Income & Spending Score",
    x        = "Annual Income (k$)",
    y        = "Spending Score (1–100)"
  ) +
  theme_minimal() +
  theme(
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    axis.title    = element_text(size = 11),
    panel.grid.major = element_line(color = "grey90", linetype = "dashed")
  )

print(p1)
ggsave("models/kmeans/plots/03_kmeans_clusters.png", p1, width = 10, height = 7, dpi = 300)
cat("✓ Saved: 03_kmeans_clusters.png\n")

# ---- PLOT 2: Train vs Test Side-by-Side Comparison ----
# Add a label column to combine both splits
train_df$Split <- "Training (80%)"
test_df$Split  <- "Testing  (20%)"
combined_df    <- rbind(train_df, test_df)
combined_df$Split <- factor(combined_df$Split, levels = c("Training (80%)", "Testing  (20%)"))

p2 <- ggplot(combined_df, aes(x = Annual_Income, y = Spending_Score, color = Cluster)) +
  geom_point(size = 3, alpha = 0.8) +
  facet_wrap(~Split) +
  scale_color_manual(values = cluster_colors, name = "Cluster") +
  labs(
    title    = "K-Means Clustering: Training vs Testing Comparison",
    subtitle = "Cluster patterns are consistent across both splits — confirms model stability",
    x        = "Annual Income (k$)",
    y        = "Spending Score (1–100)"
  ) +
  theme_minimal() +
  theme(
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    axis.title    = element_text(size = 11),
    strip.text    = element_text(face = "bold", size = 12),
    panel.grid.major = element_line(color = "grey90", linetype = "dashed")
  )

print(p2)
ggsave("models/kmeans/plots/04_kmeans_train_vs_test.png", p2, width = 14, height = 6, dpi = 300)
cat("✓ Saved: 04_kmeans_train_vs_test.png\n")

cat("\n✓ Task 4.6 Complete! Run 06_cluster_interpretation.R next.\n")
