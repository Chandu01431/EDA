# ============================================
# TASK 5.2: COMPUTE DISTANCE MATRIX
# ============================================

library(cluster)
library(tidyverse)

print("========================================")
print("COMPUTING DISTANCE MATRIX")
print("========================================\n")

# Load training data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")

print(paste("Input data: ", nrow(train_data_scaled), " customers x ", 
            ncol(train_data_scaled), " features\n", sep = ""))

# ========== COMPUTE DISTANCE MATRIX ==========
print("Computing Euclidean distance matrix...")
print("This measures how far apart each customer is from every other customer\n")

distance_matrix <- dist(train_data_scaled, method = "euclidean")

print("✓ Distance matrix computed!")

# ========== DISTANCE MATRIX PROPERTIES ==========
print("\n========== DISTANCE MATRIX PROPERTIES ==========\n")

print(paste("Matrix class:", class(distance_matrix)))
print(paste("Matrix size: ", nrow(train_data_scaled), " x ", nrow(train_data_scaled), sep = ""))
print(paste("Total pairwise distances:", length(distance_matrix)))

# Get some statistics about distances
distances_as_vector <- as.numeric(distance_matrix)

print(paste("\nDistance statistics:"))
print(paste("  Minimum distance:", round(min(distances_as_vector), 3)))
print(paste("  Maximum distance:", round(max(distances_as_vector), 3)))
print(paste("  Mean distance:", round(mean(distances_as_vector), 3)))
print(paste("  Median distance:", round(median(distances_as_vector), 3)))

# ========== INTERPRET DISTANCES ==========
print("\n========== DISTANCE INTERPRETATION ==========\n")

print("Distance matrix explains:")
print("- How similar/different customers are from each other")
print("- Used by hierarchical clustering to group similar customers")
print("- Smaller distances = more similar customers")
print("- Larger distances = more different customers")

print("\nExample: First 5 customers distances to customer 1:")
dist_matrix_full <- as.matrix(distance_matrix)
print(round(dist_matrix_full[1, 1:5], 3))

# ========== SAVE DISTANCE MATRIX ==========
saveRDS(distance_matrix, "models/hierarchical/distance_matrix.rds")

print("\n========== SAVE COMPLETE ==========")
print("✓ Distance matrix saved to: distance_matrix.rds")
print("✓ Ready for hierarchical clustering")

print("\n✓ Task 5.2 Complete!")

