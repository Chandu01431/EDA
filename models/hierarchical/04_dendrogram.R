# ============================================
# TASK 5.4: DENDROGRAM VISUALIZATION
# ============================================

library(cluster)
library(dendextend)
library(tidyverse)

print("========================================")
print("CREATING DENDROGRAMS")
print("========================================\n")

# Load model
hc_model <- readRDS("models/hierarchical/hc_model.rds")

# ========== PLOT 1: BASIC DENDROGRAM ==========
print("Creating basic dendrogram...\n")

png("models/hierarchical/dendrogram_basic.png", width = 1200, height = 800, res = 100)

plot(hc_model,
     main = "Hierarchical Clustering Dendrogram - Training Data (80%)",
     xlab = "Customer Index",
     ylab = "Distance (Ward Linkage)",
     cex = 0.8)

# Add horizontal line at k=5 cut
abline(h = 75, col = "red", lty = 2, lwd = 3)
text(80, 78, "k=5 cut level", col = "red", cex = 1.2, fontface = "bold")

dev.off()

print("✓ Saved: dendrogram_basic.png")

# ========== PLOT 2: DENDROGRAM WITH K=5 COLORING ==========
print("Creating colored dendrogram (k=5 clusters)...\n")

png("models/hierarchical/dendrogram_colored_k5.png", width = 1200, height = 800, res = 100)

# Convert to dendrogram and color by k=5
dend <- as.dendrogram(hc_model)
dend <- color_branches(dend, k = 5, col = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00"))

plot(dend,
     main = "Hierarchical Clustering Dendrogram - Colored by k=5 Clusters",
     ylab = "Distance (Ward Linkage)",
     cex = 0.8)

dev.off()

print("✓ Saved: dendrogram_colored_k5.png")

# ========== PLOT 3: TRUNCATED DENDROGRAM (CLEANER) ==========
print("Creating truncated dendrogram (easier to read)...\n")

png("models/hierarchical/dendrogram_truncated.png", width = 1200, height = 800, res = 100)

plot(hc_model,
     main = "Hierarchical Clustering - Truncated Dendrogram",
     xlab = "Cluster",
     ylab = "Distance",
     cex = 1,
     hang = -1)

# Add line at cut point for k=5
abline(h = 75, col = "red", lty = 2, lwd = 2)

dev.off()

print("✓ Saved: dendrogram_truncated.png")

# ========== DENDROGRAM INTERPRETATION ==========
print("\n========== DENDROGRAM INTERPRETATION ==========\n")

print("What the dendrogram shows:")
print("- Vertical axis (height): Distance between clusters")
print("- Horizontal axis: Individual customers")
print("- Red line: Where to cut tree for k=5 clusters")
print("- Branches: Merges of similar customers/clusters")
print("\nHow to read it:")
print("- Tall branches early = customers very different")
print("- Short branches early = customers very similar")
print("- Branches merge at heights showing similarity levels")

# ========== CLUSTER CUT ANALYSIS ==========
print("\n========== ANALYZING CUT HEIGHT ==========\n")

# Check last few merges
print("Final merges (which clusters combine last?):")
n_obs <- nrow(hc_model$merge) + 1

for (i in (nrow(hc_model$merge)-4):nrow(hc_model$merge)) {
  height <- hc_model$height[i]
  cluster_count <- n_obs - i
  print(paste("Merge at height", round(height, 2), ":", cluster_count, "->", 
              cluster_count - 1, "clusters"))
}

print("\n✓ Dendrograms created!")

print("\n✓ Task 5.4 Complete!")
