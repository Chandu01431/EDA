# ============================================
# TASK 5.7: HIERARCHICAL CLUSTER PROFILES
# ============================================

library(tidyverse)

print("========================================")
print("HIERARCHICAL CLUSTER PROFILE INTERPRETATION")
print("========================================\n")

# Load cluster profiles
cluster_profiles_hc <- readRDS("models/hierarchical/cluster_profiles_hc_train.rds")
train_df_original <- read.csv("models/hierarchical/train_data_hc_clustered.csv")

print("========== CLUSTER PROFILE INTERPRETATION ==========\n")

# ============================================
# ASSIGN CLUSTER LABELS
# ============================================

cluster_profiles_sorted <- cluster_profiles_hc %>%
  arrange(desc(Avg_Income))

print("Clusters sorted by income (highest to lowest):")
print(cluster_profiles_sorted)

cluster_labels <- list()

for (i in 1:nrow(cluster_profiles_sorted)) {
  
  c <- cluster_profiles_sorted$HC_Cluster[i]
  income <- cluster_profiles_sorted$Avg_Income[i]
  spending <- cluster_profiles_sorted$Avg_Spending[i]
  
  if (income > 70 && spending < 40) {
    
    cluster_labels[[as.character(c)]] <- "High Income, Low Spending"
    
  } else if (income > 70 && spending >= 60) {
    
    cluster_labels[[as.character(c)]] <- "High Income, High Spending"
    
  } else if (income >= 40 && income <= 70 &&
             spending >= 40 && spending <= 65) {
    
    cluster_labels[[as.character(c)]] <- "Middle Income, Middle Spending"
    
  } else if (income < 45 && spending >= 60) {
    
    cluster_labels[[as.character(c)]] <- "Low Income, High Spending"
    
  } else {
    
    cluster_labels[[as.character(c)]] <- "Low Income, Low Spending"
    
  }
}

print("\n========== CLUSTER LABELS ==========")

for (i in sort(unique(cluster_profiles_hc$HC_Cluster))) {
  
  cat(sprintf("HC Cluster %d: %s\n",
              i,
              cluster_labels[[as.character(i)]]))
  
}

# ============================================
# DETAILED ANALYSIS
# ============================================

print("\n========== DETAILED CLUSTER ANALYSIS ==========\n")

for (i in sort(unique(cluster_profiles_hc$HC_Cluster))) {
  
  profile <- cluster_profiles_hc %>%
    filter(HC_Cluster == i)
  
  if (nrow(profile) == 0) next
  
  label <- cluster_labels[[as.character(i)]]
  
  cat("\n==================================================\n")
  cat(sprintf("HC CLUSTER %d: %s\n", i, label))
  cat("==================================================\n")
  
  cat(sprintf("Size: %d customers (%.1f%% of training data)\n",
              profile$Count,
              profile$Count / 160 * 100))
  
  cat(sprintf("Income Range: %.1fk - %.1fk (Avg: %.1fk)\n",
              profile$Min_Income,
              profile$Max_Income,
              profile$Avg_Income))
  
  cat(sprintf("Spending Range: %.1f - %.1f (Avg: %.1f)\n",
              profile$Min_Spending,
              profile$Max_Spending,
              profile$Avg_Spending))
}

# ============================================
# COMPARE WITH K-MEANS
# ============================================

print("\n========== COMPARISON WITH K-MEANS ==========\n")

kmeans_profiles <- readRDS("models/kmeans/cluster_profiles_train.rds")

print("K-Means Cluster Profiles:")
print(kmeans_profiles)

print("\nHierarchical Cluster Profiles:")
print(cluster_profiles_hc)

print("\n✓ Cluster profiles complete!")

# ============================================
# SAVE LABELS
# ============================================

saveRDS(cluster_labels,
        "models/hierarchical/hc_cluster_labels.rds")

print("\n✓ Task 5.7 Complete!")

