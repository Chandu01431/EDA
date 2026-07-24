# 02_data_quality_check.R
# Check data structure, missing values, and duplicate rows

# Load raw dataset
df <- read.csv("data/raw/Mall_Customers.csv", stringsAsFactors = FALSE)

# 1. Check structure
cat("--- Data Structure ---\n")
str(df)

# 2. Check summary statistics
cat("\n--- Data Summary ---\n")
print(summary(df))

# 3. Check dimensions
cat("\n--- Dimensions ---\n")
print(dim(df))

# 4. Check for missing values (NAs)
cat("\n--- Missing Values Check ---\n")
na_count <- sum(is.na(df))
cat("Total number of missing values (NAs):", na_count, "\n")
print(colSums(is.na(df)))

# 5. Check for duplicate rows
cat("\n--- Duplicate Rows Check ---\n")
duplicate_count <- sum(duplicated(df))
cat("Total number of duplicate rows:", duplicate_count, "\n")
