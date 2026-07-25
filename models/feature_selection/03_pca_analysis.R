# ============================================
# TASK 3.3: PRINCIPAL COMPONENT ANALYSIS (PCA)
# ============================================

library(tidyverse)

cat("========================================\n")
cat("PRINCIPAL COMPONENT ANALYSIS (PCA)\n")
cat("========================================\n\n")

# ============================================
# LOAD SCALED FEATURES
# ============================================

scaled_features <- readRDS(
  "models/feature_selection/scaled_features.rds"
)

cat("✓ Scaled features loaded successfully!\n\n")

# ============================================
# PERFORM PCA
# ============================================

pca_model <- prcomp(
  scaled_features,
  center = TRUE,
  scale. = TRUE
)

cat("✓ PCA completed successfully!\n\n")

# ============================================
# PCA SUMMARY
# ============================================

print(summary(pca_model))

cat("\nVariance Explained:\n")
print(pca_model$sdev^2 / sum(pca_model$sdev^2))

# ============================================
# SAVE PCA MODEL
# ============================================

saveRDS(
  pca_model,
  "models/feature_selection/pca_model.rds"
)

# ============================================
# SAVE PCA SCORES
# ============================================

pca_scores <- as.data.frame(pca_model$x)

write.csv(
  pca_scores,
  "models/feature_selection/pca_scores.csv",
  row.names = FALSE
)

# ============================================
# PCA VISUALIZATION
# ============================================

png(
  "models/feature_selection/pca_plot.png",
  width = 1200,
  height = 800,
  res = 120
)

plot(
  pca_scores$PC1,
  pca_scores$PC2,
  pch = 19,
  col = "blue",
  xlab = "Principal Component 1",
  ylab = "Principal Component 2",
  main = "PCA Projection of Mall Customers"
)

grid()

dev.off()

cat("\n✓ PCA plot saved successfully.\n")

cat("\n========================================\n")
cat("PCA COMPLETED SUCCESSFULLY\n")
cat("========================================\n")
