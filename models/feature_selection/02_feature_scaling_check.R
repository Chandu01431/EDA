# ============================================
# TASK 3.2: FEATURE SCALING
# ============================================

library(tidyverse)

cat("========================================\n")
cat("FEATURE SCALING\n")
cat("========================================\n\n")

# ============================================
# LOAD SELECTED FEATURES
# ============================================

selected_features <- readRDS(
  "models/feature_selection/selected_features.rds"
)

cat("Selected Features Loaded Successfully!\n\n")

cat("Original Data Summary:\n")
print(summary(selected_features))

# ============================================
# STANDARDIZE FEATURES
# ============================================

scaled_features <- scale(selected_features)

cat("\nScaled Data Summary:\n")
print(summary(scaled_features))

# Check Mean and Standard Deviation
cat("\nMean of Scaled Features:\n")
print(colMeans(scaled_features))

cat("\nStandard Deviation of Scaled Features:\n")
print(apply(scaled_features, 2, sd))

# ============================================
# SAVE SCALED DATA
# ============================================

saveRDS(
  scaled_features,
  "models/feature_selection/scaled_features.rds"
)

write.csv(
  as.data.frame(scaled_features),
  "models/feature_selection/scaled_features.csv",
  row.names = FALSE
)

cat("\n✓ Scaled features saved successfully!\n")

# ============================================
# VISUALIZATION
# ============================================

png(
  "models/feature_selection/scaled_features_plot.png",
  width = 1200,
  height = 800,
  res = 120
)

plot(
  scaled_features,
  col = "blue",
  pch = 19,
  main = "Scaled Features"
)

grid()

dev.off()

cat("\n✓ Scaling plot saved successfully!\n")
cat("\n✓ Task 3.2 Completed Successfully!\n")

