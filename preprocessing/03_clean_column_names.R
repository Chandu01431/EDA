# 03_clean_column_names.R
# Rename column names to be clean and consistent (no special characters or spaces)

# Load raw dataset
df <- read.csv("data/raw/Mall_Customers.csv", stringsAsFactors = FALSE)

cat("Original column names:\n")
print(names(df))

# Rename messy columns
# "Annual.Income..k.." -> "Annual_Income"
# "Spending.Score..1.100." -> "Spending_Score"
names(df)[names(df) == "Annual.Income..k.."] <- "Annual_Income"
names(df)[names(df) == "Spending.Score..1.100."] <- "Spending_Score"

# Just in case R parsed them with spaces/dots:
# Let's map standard R names or clean them explicitly
names(df) <- c("CustomerID", "Gender", "Age", "Annual_Income", "Spending_Score")

cat("\nCleaned column names:\n")
print(names(df))
