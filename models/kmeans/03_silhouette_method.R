# ============================================
# TASK 4.3: SILHOUETTE METHOD ON TRAINING DATA (80%)
# ============================================
# PREREQUISITE: Run 01_kmeans_setup.R first to generate the RDS split files.
# ============================================

library(cluster)
library(ggplot2)

# ---- Load training data saved by 01_kmeans_setup.R ----
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")

cat("Silhouette Method on TRAINING DATA (", nrow(train_data_scaled), "customers)\n")
cat("Testing k from 2 to 10...\n\n")

# ---- Silhouette Method ----
# Silhouette coefficient for each point = how similar it is to its own cluster
# vs neighbouring clusters. Range: -1 (wrong cluster) to +1 (perfect fit).
# We compute the AVERAGE silhouette for each k and pick the k with highest average.

silhouette_scores <- numeric(length = 10)  # index 1 unused (k starts at 2)

for (k in 2:10) {
  km_temp  <- kmeans(train_data_scaled, centers = k, nstart = 25, iter.max = 100)
  sil_obj  <- silhouette(km_temp$cluster, dist(train_data_scaled))
  silhouette_scores[k] <- mean(sil_obj[, 3])  # Column 3 = silhouette width per point
}

# Build summary table
sil_df <- data.frame(
  k              = 2:10,
  Avg_Silhouette = silhouette_scores[2:10]
)

cat("--- SILHOUETTE SCORES FOR EACH k ---\n")
print(sil_df)

# ---- Plot the Silhouette Curve ----
p <- ggplot(sil_df, aes(x = k, y = Avg_Silhouette)) +
  geom_line(color = "coral", linewidth = 1.2) +
  geom_point(size = 4, color = "coral") +
  geom_vline(xintercept = sil_df$k[which.max(sil_df$Avg_Silhouette)],
             linetype = "dashed", color = "red", linewidth = 1) +
  annotate("text",
           x     = sil_df$k[which.max(sil_df$Avg_Silhouette)] + 0.3,
           y     = max(sil_df$Avg_Silhouette) * 0.97,
           label = paste("Best k =", sil_df$k[which.max(sil_df$Avg_Silhouette)]),
           color = "red", hjust = 0, size = 4) +
  scale_x_continuous(breaks = 2:10) +
  labs(
    title    = "Silhouette Method for Optimal k (Training Data - 80%)",
    subtitle = "Peak = best k. Values closer to 1 mean clusters are well-separated.",
    x        = "Number of Clusters (k)",
    y        = "Average Silhouette Width"
  ) +
  theme_minimal() +
  theme(
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    axis.title    = element_text(size = 11)
  )

print(p)

# Save the plot
ggsave("models/kmeans/plots/02_silhouette_plot.png", p, width = 10, height = 7, dpi = 300)
cat("✓ Saved: models/kmeans/plots/02_silhouette_plot.png\n")

# ---- Show best k ----
best_k     <- sil_df$k[which.max(sil_df$Avg_Silhouette)]
best_score <- max(sil_df$Avg_Silhouette)
cat("\nBest k:", best_k, "| Avg Silhouette Score:", round(best_score, 3), "\n")
cat("Interpretation: 0.51-0.70 = Reasonable structure | 0.71-1.0 = Strong structure\n")

cat("\n✓ Task 4.3 Complete! Run 04_kmeans_model.R next.\n")
