# ============================================
# TASK 5.3: BUILD HIERARCHICAL MODEL
# ============================================

library(cluster)
library(tidyverse)

print("========================================")
print("BUILDING HIERARCHICAL CLUSTERING MODEL")
print("========================================\n")

# Load distance matrix
distance_matrix <- readRDS("models/hierarchical/distance_matrix.rds")

# ========== BUILD HIERARCHICAL MODEL ==========
print("Building hierarchical clustering model...")
print("Method: Ward linkage (minimizes within-cluster variance)")
print("Distance: Euclidean\n")

# Ward's method (ward.D2) - recommended for most applications
hc_model <- hclust(distance_matrix, method = "ward.D2")

print("✓ Model built successfully!")

# ========== MODEL PROPERTIES ==========
print("\n========== MODEL PROPERTIES ==========\n")

print(paste("Model class:", class(hc_model)))
print(paste("Method:", hc_model$method))
print(paste("Number of observations:", length(hc_model$order)))
print(paste("Height range:", round(min(hc_model$height), 3), "to", round(max(hc_model$height), 3)))

# ========== UNDERSTAND THE MODEL ==========
print("\n========== HOW HIERARCHICAL CLUSTERING WORKS ==========\n")

print("1. Start: Each customer is its own cluster (160 clusters)")
print("2. Step 1: Join 2 most similar customers -> 159 clusters")
print("3. Step 2: Join next 2 most similar -> 158 clusters")
print("4. Continue: Keep merging similar clusters")
print("5. End: All customers in one cluster")
print("\nThe dendrogram shows all these steps!")

# ========== HEIGHT ANALYSIS ==========
print("\n========== HEIGHT ANALYSIS (Where to cut tree) ==========\n")

heights <- hc_model$height
print("Last 10 merging heights (largest jumps indicate cluster separation):")
last_10_heights <- tail(heights, 10)
for (i in seq_along(last_10_heights)) {
  cluster_count <- length(heights) - i + 1
  print(paste("Merge", length(heights) - i + 1, ": Height =", 
              round(last_10_heights[i], 3), "(", cluster_count, "clusters)"))
}

print("\nLarge jump from height 65 to 80?")
print("-> This suggests good cut point around height 75 (creates 5 clusters)")

# ========== SAVE MODEL ==========
saveRDS(hc_model, "models/hierarchical/hc_model.rds")

print("\n========== SAVE COMPLETE ==========")
print("✓ Model saved to: hc_model.rds")
print("✓ Ready for dendrogram visualization")

print("\n✓ Task 5.3 Complete!")
