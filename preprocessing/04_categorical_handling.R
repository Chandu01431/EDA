# 04_categorical_handling.R
# Encode Gender (categorical) into numeric values for models

# Load raw dataset and clean column names
df <- read.csv("data/raw/Mall_Customers.csv", stringsAsFactors = FALSE)
names(df) <- c("CustomerID", "Gender", "Age", "Annual_Income", "Spending_Score")

cat("Gender summary before encoding:\n")
print(table(df$Gender))

# Encode Gender (categorical) into numeric
# Female -> 1, Male -> 2 (or based on factor levels)
df$Gender_Encoded <- as.numeric(factor(df$Gender))

cat("\nGender sample after encoding (Gender vs Gender_Encoded):\n")
print(head(df[, c("Gender", "Gender_Encoded")]))
