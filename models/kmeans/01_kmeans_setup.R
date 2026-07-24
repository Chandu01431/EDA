# ============================================
# TASK 4.1: K-MEANS SETUP & 80-20 TRAIN-TEST SPLIT
# ============================================
# This script is the ENTRY POINT.
# Run this first — it creates and saves the train/test split RDS files
# which are required by scripts 02, 03, 04, 05, and 06.
# ============================================

library(cluster)
library(factoextra)
library(tidyverse)

# ---- Step 1: Load cleaned data from preprocessing stage ----
df_scaled   <- read.csv("data/cleaned/mall_customers_scaled.csv")
df_original <- read.csv("data/cleaned/mall_customers_original.csv")

cat("Dataset loaded successfully!\n")
cat("Total customers:", nrow(df_scaled), "\n")

# ---- Step 2: Select features for clustering ----
# Annual_Income and Spending_Score are chosen because:
# - They are nearly independent (correlation ≈ 0.01)
# - They show 5 visually distinct blobs in the scatter plot
features <- c("Annual_Income", "Spending_Score")

# Extract only the two clustering features
data_scaled   <- df_scaled[,   features]
data_original <- df_original[, features]

cat("\nFeatures for clustering:", paste(features, collapse = ", "), "\n")

# ---- Step 3: Create 80-20 Train-Test Split ----
set.seed(42)  # Fix seed so every run gives the SAME split

n          <- nrow(data_scaled)           # 200 customers
train_size <- round(0.8 * n)             # 160 for training
train_idx  <- sample(1:n, size = train_size, replace = FALSE)

# Scaled splits (used for model training and evaluation)
train_data_scaled <- data_scaled[train_idx, ]
test_data_scaled  <- data_scaled[-train_idx, ]

# Original scale splits (used for interpretable cluster profiles)
train_data_original <- data_original[train_idx, ]
test_data_original  <- data_original[-train_idx, ]

# Full original dataframe splits (used for adding cluster labels later)
train_df_original <- df_original[train_idx, ]
test_df_original  <- df_original[-train_idx, ]

# ---- Step 4: Verify the split ----
cat("\n--- TRAIN-TEST SPLIT VERIFICATION ---\n")
cat("Training set:", nrow(train_data_scaled), "rows (80%)\n")
cat("Testing  set:", nrow(test_data_scaled),  "rows (20%)\n")
cat("Total:       ", nrow(train_data_scaled) + nrow(test_data_scaled), "rows\n")

# ---- Step 5: Save all splits as RDS files ----
# These are REAL R data objects — readable by readRDS() in subsequent scripts
saveRDS(train_data_scaled,   "models/kmeans/train_data_scaled.rds")
saveRDS(test_data_scaled,    "models/kmeans/test_data_scaled.rds")
saveRDS(train_data_original, "models/kmeans/train_data_original.rds")
saveRDS(test_data_original,  "models/kmeans/test_data_original.rds")
saveRDS(train_df_original,   "models/kmeans/train_df_original.rds")
saveRDS(test_df_original,    "models/kmeans/test_df_original.rds")

cat("\n✓ All splits saved to models/kmeans/ folder\n")
cat("✓ Task 4.1 Complete! Run 02_elbow_method.R next.\n")
