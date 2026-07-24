# ============================================
# TASK 4.7 & 4.8: CLUSTER INTERPRETATION & STABILITY
# ============================================

library(tidyverse)

# Load clustered datasets
train_df <- read.csv("models/kmeans/train_data_clustered.csv")
test_df <- read.csv("models/kmeans/test_data_clustered.csv")

# Combine for overall interpretation
full_df <- rbind(train_df, test_df)

# ========== CLUSTER PROFILE ANALYSIS ==========
print("Creating Cluster Profiles (Original Scale)...")

# Define cluster labels based on profile centroids
# Let's compute average values to check centers
centroids <- full_df %>%
  group_by(KMeans_Cluster) %>%
  summarise(
    Count = n(),
    Pct = round(n() / nrow(full_df) * 100, 1),
    Avg_Age = round(mean(Age), 1),
    Avg_Income = round(mean(Annual_Income), 1),
    Avg_Spending = round(mean(Spending_Score), 1),
    Prop_Female = round(sum(Gender == "Female") / n() * 100, 1)
  )

print(centroids)

# Add custom cluster labels based on demographics:
# Cluster definitions:
# High Income, High Spending -> VIP/Loyal Spenders
# High Income, Low Spending -> Careful/Frugal
# Medium Income, Medium Spending -> Average Spenders
# Low Income, High Spending -> Impulsive/Generous
# Low Income, Low Spending -> Conservative/Sensible

centroids$Segment_Name <- case_when(
  centroids$Avg_Income > 70 & centroids$Avg_Spending > 70 ~ "VIP/Loyal Spenders",
  centroids$Avg_Income > 70 & centroids$Avg_Spending < 40 ~ "Careful/Frugal",
  centroids$Avg_Income >= 40 & centroids$Avg_Income <= 70 & centroids$Avg_Spending >= 40 & centroids$Avg_Spending <= 60 ~ "Average Spenders",
  centroids$Avg_Income < 40 & centroids$Avg_Spending > 70 ~ "Impulsive/Generous",
  centroids$Avg_Income < 40 & centroids$Avg_Spending < 40 ~ "Conservative/Sensible",
  TRUE ~ "Other"
)

print("\nLabeled Cluster Profiles:")
print(centroids)

# Save cluster profiles CSV
write.csv(centroids, "models/kmeans/cluster_profiles.csv", row.names = FALSE)
print("✓ Saved models/kmeans/cluster_profiles.csv")

# ========== STABILITY SUMMARY STATS ==========
print("\n========== STABILITY ANALYSIS SUMMARY ==========")
train_profiles <- train_df %>%
  group_by(KMeans_Cluster) %>%
  summarise(Avg_Inc_Train = mean(Annual_Income), Avg_Spend_Train = mean(Spending_Score))

test_profiles <- test_df %>%
  group_by(KMeans_Cluster) %>%
  summarise(Avg_Inc_Test = mean(Annual_Income), Avg_Spend_Test = mean(Spending_Score))

stability <- merge(train_profiles, test_profiles, by = "KMeans_Cluster")
stability$Inc_Diff <- abs(stability$Avg_Inc_Train - stability$Avg_Inc_Test)
stability$Spend_Diff <- abs(stability$Avg_Spend_Train - stability$Avg_Spend_Test)

print(stability)
cat("\nMean Income Difference (Train vs Test):", round(mean(stability$Inc_Diff), 2), "k$\n")
cat("Mean Spending Difference (Train vs Test):", round(mean(stability$Spend_Diff), 2), "\n")

# ========== SAVE COMBINED CLUSTERED DATASET TO DATA/CLUSTERED ==========
# Match format CustomerID, Gender, Age, Annual_Income, Spending_Score, Gender_Encoded, KMeans_Cluster
write.csv(full_df, "data/clustered/mall_customers_kmeans.csv", row.names = FALSE)
print("✓ Saved data/clustered/mall_customers_kmeans.csv")

print("\n✓ Task 4.7 & 4.8 Complete!")
