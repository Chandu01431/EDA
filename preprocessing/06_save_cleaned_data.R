# 06_save_cleaned_data.R
# Preprocess the entire dataset and save original clean scale and scaled datasets

# 1. Load data
df <- read.csv("data/raw/Mall_Customers.csv", stringsAsFactors = FALSE)

# 2. Clean column names
names(df) <- c("CustomerID", "Gender", "Age", "Annual_Income", "Spending_Score")

# 3. Handle duplicates or missing values (none present in this dataset)
df <- unique(df)
df <- na.omit(df)

# 4. Encode Gender to numeric representation
# Female -> 1, Male -> 2
df$Gender_Encoded <- as.numeric(factor(df$Gender))

# Save the original clean version (with unscaled features but clean names/encodings)
write.csv(df, "data/cleaned/mall_customers_original.csv", row.names = FALSE)
cat("Saved original clean version to data/cleaned/mall_customers_original.csv\n")

# 5. Scale the numeric features
numeric_cols <- c("Age", "Annual_Income", "Spending_Score")
df_scaled <- df
df_scaled[, numeric_cols] <- scale(df[, numeric_cols])

# Save the scaled version for clustering models
write.csv(df_scaled, "data/cleaned/mall_customers_scaled.csv", row.names = FALSE)
cat("Saved scaled version to data/cleaned/mall_customers_scaled.csv\n")
