# ============================================
# TASK 4.7: CLUSTER PROFILE INTERPRETATION (FIXED)
# ============================================

library(tidyverse)

# Load data and model
cluster_profiles_train <- readRDS("models/kmeans/cluster_profiles_train.rds")
train_df_original <- readRDS("models/kmeans/train_df_original.rds")
kmeans_model <- readRDS("models/kmeans/kmeans_model_trained.rds")

# Ensure KMeans_Cluster column exists in train_df_original
train_df_original$KMeans_Cluster <- kmeans_model$cluster

print("========== CLUSTER PROFILE INTERPRETATION ==========")
print("Interpreting what each cluster represents...\n")

# ========== ASSIGN CLUSTER LABELS ==========
cluster_labels <- list(
  "1" = "High Income, Low Spending",
  "2" = "High Income, High Spending", 
  "3" = "Middle Income, Middle Spending",
  "4" = "Low Income, High Spending",
  "5" = "Low Income, Low Spending"
)

print("========== CLUSTER LABELS ==========")
for (i in 1:5) {
  cat(sprintf("Cluster %d: %s\n", i, cluster_labels[[as.character(i)]]))
}

# ========== DETAILED ANALYSIS FOR EACH CLUSTER ==========
print("\n========== DETAILED CLUSTER ANALYSIS ==========")

for (i in 1:5) {
  label <- cluster_labels[[as.character(i)]]
  
  cluster_data <- train_df_original %>% 
    filter(KMeans_Cluster == i)
  
  profile <- cluster_profiles_train %>% 
    filter(KMeans_Cluster == i)
  
  cat(sprintf("\n%s\n", paste(rep("=", 50), collapse = "")))
  cat(sprintf("CLUSTER %d: %s\n", i, label))
  cat(sprintf("%s\n", paste(rep("=", 50), collapse = "")))
  
  cat(sprintf("Size: %d customers (%.1f%% of training data)\n", 
              profile$Count, profile$Count / 160 * 100))
  
  # FIX: Changed %d to %.0f for numeric/decimal columns in profile
  cat(sprintf("Income Range: $%.0fk - $%.0fk (Avg: $%.0fk)\n", 
              profile$Min_Income, profile$Max_Income, profile$Avg_Income))
  cat(sprintf("Spending Range: %.0f - %.0f (Avg: %.0f)\n", 
              profile$Min_Spending, profile$Max_Spending, profile$Avg_Spending))
  
  # Customer description
  cat("\nCustomer Profile:\n")
  
  if (i == 1) {
    cat("  • High earners who spend conservatively\n")
    cat("  • Likely financially cautious or saving-oriented\n")
    cat("  • May be older, established professionals\n")
    cat("  • Marketing strategy: Premium products, value-focused messaging\n")
  } else if (i == 2) {
    cat("  • Affluent customers who spend freely\n")
    cat("  • Ideal target market for luxury/premium products\n")
    cat("  • Likely high disposable income, brand-conscious\n")
    cat("  • Marketing strategy: Exclusive offers, loyalty programs\n")
  } else if (i == 3) {
    cat("  • Average income and spending\n")
    cat("  • The 'average customer' segment\n")
    cat("  • Balanced financial behavior\n")
    cat("  • Marketing strategy: Broad appeal, mid-range products\n")
  } else if (i == 4) {
    cat("  • Lower income but high spenders\n")
    cat("  • May prioritize lifestyle over savings\n")
    cat("  • Potential target for credit/financing offers\n")
    cat("  • Marketing strategy: Aspirational products, payment plans\n")
  } else if (i == 5) {
    cat("  • Budget-conscious customers with limited spending\n")
    cat("  • Price-sensitive, value-driven purchases\n")
    cat("  • May have limited disposable income\n")
    cat("  • Marketing strategy: Discounts, bundle deals, essentials\n")
  }
}

# ========== MARKETING RECOMMENDATIONS ==========
print("\n\n========== MARKETING RECOMMENDATIONS ==========")
print("Based on cluster analysis:")

recommendations <- data.frame(
  Cluster = 1:5,
  Label = unlist(cluster_labels),
  Strategy = c(
    "Premium value products, long-term investment offerings, retirement planning services",
    "Exclusive member perks, early access to new products, premium brand collaborations",
    "Mid-range product bundles, seasonal promotions, balanced mix of essentials and treats",
    "Buy-now-pay-later options, student/youth discounts, aspirational entry-level products",
    "Discount programs, loyalty points, budget-friendly bundles, essential item promotions"
  )
)

print(recommendations)

# ========== SAVE RESULTS ==========
if (!dir.exists("models/kmeans")) {
  dir.create("models/kmeans", recursive = TRUE)
}

write.csv(cluster_profiles_train, "models/kmeans/cluster_profiles.csv", row.names = FALSE)
write.csv(recommendations, "models/kmeans/marketing_recommendations.csv", row.names = FALSE)

print("\n✓ Cluster profiles saved to: cluster_profiles.csv")
print("✓ Marketing recommendations saved to: marketing_recommendations.csv")
print("✓ Task 4.7 Complete!")
