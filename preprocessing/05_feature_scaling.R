# 05_feature_scaling.R
# Scale numeric features (Age, Annual_Income, Spending_Score)

# Load dataset and clean/encode
df <- read.csv("data/raw/Mall_Customers.csv", stringsAsFactors = FALSE)
names(df) <- c("CustomerID", "Gender", "Age", "Annual_Income", "Spending_Score")

# Scale numeric columns
numeric_cols <- c("Age", "Annual_Income", "Spending_Score")
df_scaled_features <- scale(df[, numeric_cols])

# Convert back to data frame and inspect
df_scaled_features <- as.data.frame(df_scaled_features)

cat("Summary of scaled features (mean should be ~0 and standard deviation should be 1):\n")
print(summary(df_scaled_features))

cat("\nStandard Deviation of scaled features:\n")
cat("Age SD:", sd(df_scaled_features$Age), "\n")
cat("Annual Income SD:", sd(df_scaled_features$Annual_Income), "\n")
cat("Spending Score SD:", sd(df_scaled_features$Spending_Score), "\n")
