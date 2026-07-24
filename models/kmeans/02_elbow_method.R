# ============================================
# TASK 4.2: ELBOW METHOD ON TRAINING DATA (80%)
# ============================================
# PREREQUISITE: Run 01_kmeans_setup.R first to generate the RDS split files.
# ============================================

library(cluster)
library(factoextra)
library(ggplot2)

# ---- Load training data saved by 01_kmeans_setup.R ----
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")

cat("Elbow Method on TRAINING DATA (", nrow(train_data_scaled), "customers)\n")
cat("Testing k from 1 to 10...\n\n")

# ---- Elbow Method: WCSS for each k ----
# WCSS = Within-Cluster Sum of Squares
# As k increases, WCSS always decreases.
# The "elbow" is where adding more clusters gives diminishing returns.

wcss_values <- numeric(10)

for (k in 1:10) {
  km_temp <- kmeans(train_data_scaled, centers = k, nstart = 25, iter.max = 100)
  wcss_values[k] <- km_temp$tot.withinss  # Total within-cluster sum of squares
}

# Build a summary table of WCSS values
wcss_df <- data.frame(
  k        = 1:10,
  WCSS     = wcss_values,
  Decrease = c(NA, -diff(wcss_values))  # Drop in WCSS when adding one more cluster
)

cat("--- WCSS VALUES FOR EACH k ---\n")
print(wcss_df)

# ---- Plot the Elbow Curve ----
p <- ggplot(wcss_df, aes(x = k, y = WCSS)) +
  geom_line(color = "steelblue", linewidth = 1.2) +
  geom_point(size = 4, color = "steelblue") +
  geom_vline(xintercept = 5, linetype = "dashed", color = "red", linewidth = 1) +  # Mark optimal k
  annotate("text", x = 5.3, y = max(wcss_df$WCSS) * 0.9,
           label = "Optimal k = 5", color = "red", hjust = 0, size = 4) +
  scale_x_continuous(breaks = 1:10) +
  labs(
    title    = "Elbow Method for Optimal k (Training Data - 80%)",
    subtitle = "Look for the elbow — where WCSS curve flattens. Dashed red line = k=5.",
    x        = "Number of Clusters (k)",
    y        = "Total Within-Cluster Sum of Squares (WCSS)"
  ) +
  theme_minimal() +
  theme(
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    axis.title    = element_text(size = 11)
  )

print(p)

# Save the plot
ggsave("models/kmeans/plots/01_elbow_plot.png", p, width = 10, height = 7, dpi = 300)
cat("✓ Saved: models/kmeans/plots/01_elbow_plot.png\n")

cat("\n✓ Task 4.2 Complete! Run 03_silhouette_method.R next.\n")
