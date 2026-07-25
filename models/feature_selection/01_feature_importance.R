# ============================================
# TASK 3.1: FEATURE SELECTION
# ============================================

library(tidyverse)

cat("========================================\n")
cat("FEATURE SELECTION\n")
cat("========================================\n\n")

# ============================================
# LOAD DATASET
# ============================================

df <- read.csv("data/cleaned/mall_customers_original.csv")

cat("Dataset Loaded Successfully!\n\n")

cat("Dataset Dimensions:\n")
print(dim(df))

cat("\nColumn Names:\n")
print(names(df))

# ============================================
# SELECT FEATURES FOR CLUSTERING
# ============================================

selected_features <- df %>%
  select(Annual_Income, Spending_Score)

cat("\nSelected Features:\n")
print(names(selected_features))

# ============================================
# SUMMARY STATISTICS
# ============================================

cat("\nSummary Statistics:\n")
print(summary(selected_features))

# ============================================
# CORRELATION
# ============================================

cat("\nCorrelation Matrix:\n")
print(cor(selected_features))

# ============================================
# VISUALIZATION
# ============================================

png(
  filename = "models/feature_selection/selected_features_plot.png",
  width = 1200,
  height = 800,
  res = 120
)

plot(
  selected_features$Annual_Income,
  selected_features$Spending_Score,
  pch = 19,
  col = "steelblue",
  xlab = "Annual Income (k$)",
  ylab = "Spending Score",
  main = "Selected Features for Clustering"
)

grid()

dev.off()

cat("\n✓ Scatter plot saved successfully.\n")

# ============================================
# SAVE SELECTED FEATURES
# ============================================

dir.create(
  "models/feature_selection",
  recursive = TRUE,
  showWarnings = FALSE
)

write.csv(
  selected_features,
  "models/feature_selection/selected_features.csv",
  row.names = FALSE
)

saveRDS(
  selected_features,
  "models/feature_selection/selected_features.rds"
)

cat("\n✓ Selected features saved successfully.\n")

# ============================================
# FEATURE IMPORTANCE REPORT
# ============================================

cat("\n========================================\n")
cat("FEATURE SELECTION REPORT\n")
cat("========================================\n")

cat("Selected Features:\n")
cat("1. Annual_Income\n")
cat("2. Spending_Score\n\n")

cat("Reason:\n")
cat("- Annual Income represents customer's earning capacity.\n")
cat("- Spending Score represents customer's purchasing behaviour.\n")
cat("- These two features are the most important for customer segmentation.\n")
cat("- They are used as input for K-Means and Hierarchical Clustering.\n")

cat("\n✓ Feature Selection Completed Successfully!\n")

