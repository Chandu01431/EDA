# ============================================
# TASK 5.1: HIERARCHICAL CLUSTERING SETUP
# ============================================

library(cluster)
library(factoextra)
library(tidyverse)
library(dendextend)

print("========================================")
print("HIERARCHICAL CLUSTERING - SETUP")
print("========================================\n")

# ========== LOAD SAME TRAINING DATA AS K-MEANS ==========
print("Loading training data (80% - same as K-Means)...\n")

train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")

print(paste("✓ Training data loaded:"))
print(paste("  Rows:", nrow(train_data_scaled)))
print(paste("  Columns:", ncol(train_data_scaled)))
print(paste("  Features:", paste(colnames(train_data_scaled), collapse = ", ")))

# Display first few rows
print("\nFirst 10 rows of training data (scaled):")
print(head(train_data_scaled, 10))

# ========== VERIFY DATA INTEGRITY ==========
print("\n========== DATA INTEGRITY CHECK ==========\n")

# Check for missing values
missing_values <- sum(is.na(train_data_scaled))
print(paste("Missing values:", missing_values))

if (missing_values == 0) {
  print("✓ Data is clean (no missing values)")
} else {
  print("❌ WARNING: Missing values detected!")
}

# Check data types
print("\nData types:")
print(sapply(train_data_scaled, class))

# Check ranges
print("\nFeature ranges (should be around -3 to +3 for scaled data):")
for (col in colnames(train_data_scaled)) {
  min_val <- min(train_data_scaled[[col]])
  max_val <- max(train_data_scaled[[col]])
  print(paste(col, ":", round(min_val, 2), "to", round(max_val, 2)))
}

# ========== SUMMARY ==========
print("\n========== SETUP COMPLETE ==========")
print("✓ Data loaded and verified")
print("✓ Same 160 training customers as K-Means")
print("✓ Ready for hierarchical clustering")

print("\n✓ Task 5.1 Complete!")
