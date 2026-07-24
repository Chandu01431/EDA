# ============================================
# TASK 4.1: K-MEANS SETUP & 80-20 TRAIN-TEST SPLIT
# ============================================

library(cluster)
library(factoextra)
library(tidyverse)

# Load the cleaned, scaled data from Role 1
df_scaled <- read.csv("data/cleaned/mall_customers_scaled.csv")
df_original <- read.csv("data/cleaned/mall_customers_original.csv")

# Display info
print("Dataset loaded successfully!")
print(paste("Total customers:", nrow(df_scaled)))

# ========== SELECT FEATURES FOR CLUSTERING ==========
# Based on analysis: Annual_Income + Spending_Score
features_for_clustering <- c("Annual_Income", "Spending_Score")

# Extract scaled features
data_scaled <- df_scaled[, features_for_clustering]

# Extract original features (for interpretation)
data_original <- df_original[, features_for_clustering]

print("\nFeatures selected for clustering:")
print(features_for_clustering)
print("Reason: These features are independent (r ≈ 0) and create visible clusters")

# ========== CREATE 80-20 TRAIN-TEST SPLIT ==========

# Set random seed for reproducibility
set.seed(42)

# Total number of observations
n <- nrow(data_scaled)
print(paste("\nTotal observations:", n))

# Calculate 80% for training
train_size <- round(0.8 * n)
print(paste("Training set size (80%):", train_size))
print(paste("Testing set size (20%):", n - train_size))

# Create random indices for training set
train_indices <- sample(1:n, size = train_size, replace = FALSE)

# Split SCALED data
train_data_scaled <- data_scaled[train_indices, ]
test_data_scaled <- data_scaled[-train_indices, ]

# Split ORIGINAL data (for later interpretation)
train_data_original <- data_original[train_indices, ]
test_data_original <- data_original[-train_indices, ]

# Split original customer data
train_df_original <- df_original[train_indices, ]
test_df_original <- df_original[-train_indices, ]

# Verify split
print("\n========== TRAIN-TEST SPLIT VERIFICATION ==========")
print(paste("Training set:", nrow(train_data_scaled), "rows"))
print(paste("Testing set:", nrow(test_data_scaled), "rows"))
print(paste("Total:", nrow(train_data_scaled) + nrow(test_data_scaled), "rows"))

# Save splits for use in later scripts
saveRDS(train_data_scaled, "models/kmeans/train_data_scaled.rds")
saveRDS(test_data_scaled, "models/kmeans/test_data_scaled.rds")
saveRDS(train_data_original, "models/kmeans/train_data_original.rds")
saveRDS(test_data_original, "models/kmeans/test_data_original.rds")
saveRDS(train_df_original, "models/kmeans/train_df_original.rds")
saveRDS(test_df_original, "models/kmeans/test_df_original.rds")

print("\n✓ Train-test split complete!")
print("✓ All data saved to models/kmeans/ folder")
