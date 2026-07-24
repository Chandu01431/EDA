# ============================================
# TASK 4.7 & 4.8: CLUSTER INTERPRETATION & STABILITY ANALYSIS
# ============================================
# PREREQUISITE: Run 01_kmeans_setup.R and 04_kmeans_model.R first.
# ============================================

library(tidyverse)

# ---- Load clustered data from train and test ----
train_df <- read.csv("models/kmeans/train_data_clustered.csv")
test_df  <- read.csv("models/kmeans/test_data_clustered.csv")

# Combine both splits for overall profiles
full_df <- rbind(train_df, test_df)

# ---- TASK 4.7: Cluster Profile Interpretation ----
cat("--- CLUSTER PROFILES (Full Dataset - 200 customers) ---\n")

# Summarize each cluster: count, average demographics, gender split
profiles <- full_df %>%
  group_by(KMeans_Cluster) %>%
  summarise(
    Count         = n(),
    Pct           = round(n() / nrow(full_df) * 100, 1),
    Avg_Age       = round(mean(Age), 1),
    Avg_Income    = round(mean(Annual_Income), 1),
    Avg_Spending  = round(mean(Spending_Score), 1),
    Pct_Female    = round(sum(Gender == "Female") / n() * 100, 1),
    .groups = "drop"
  )

print(profiles)

# ---- Label each cluster based on Income + Spending profile ----
profiles <- profiles %>%
  mutate(Segment = case_when(
    Avg_Income > 70 & Avg_Spending > 70  ~ "VIP / Loyal Spenders",
    Avg_Income > 70 & Avg_Spending < 40  ~ "Careful / Frugal",
    Avg_Income < 40 & Avg_Spending > 70  ~ "Impulsive / Generous",
    Avg_Income < 40 & Avg_Spending < 40  ~ "Conservative / Sensible",
    TRUE                                  ~ "Average Spenders"
  ))

cat("\n--- CLUSTER LABELS ---\n")
print(profiles[, c("KMeans_Cluster", "Segment", "Count", "Avg_Income", "Avg_Spending")])

# Save cluster profiles
write.csv(profiles, "models/kmeans/cluster_profiles.csv", row.names = FALSE)
cat("✓ Saved: models/kmeans/cluster_profiles.csv\n")

# ---- TASK 4.8: Stability Analysis (Train vs Test) ----
cat("\n--- STABILITY ANALYSIS: TRAIN vs TEST ---\n")

train_profile <- train_df %>%
  group_by(KMeans_Cluster) %>%
  summarise(
    Train_Income   = round(mean(Annual_Income), 1),
    Train_Spending = round(mean(Spending_Score), 1),
    .groups = "drop"
  )

test_profile <- test_df %>%
  group_by(KMeans_Cluster) %>%
  summarise(
    Test_Income   = round(mean(Annual_Income), 1),
    Test_Spending = round(mean(Spending_Score), 1),
    .groups = "drop"
  )

# Merge to compare side by side
stability <- merge(train_profile, test_profile, by = "KMeans_Cluster", all = TRUE)
stability$Inc_Diff    <- abs(stability$Train_Income   - stability$Test_Income)
stability$Spend_Diff  <- abs(stability$Train_Spending - stability$Test_Spending)

print(stability)

cat("\nMean Income difference  (Train vs Test):", round(mean(stability$Inc_Diff,   na.rm = TRUE), 2), "k$\n")
cat("Mean Spending difference (Train vs Test):", round(mean(stability$Spend_Diff, na.rm = TRUE), 2), "points\n")

# ---- Save full clustered dataset ----
write.csv(full_df, "data/clustered/mall_customers_kmeans.csv", row.names = FALSE)
cat("✓ Saved: data/clustered/mall_customers_kmeans.csv\n")

cat("\n✓ Task 4.7 & 4.8 Complete!\n")
