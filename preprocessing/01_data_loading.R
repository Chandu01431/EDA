# 01_data_loading.R
# Load raw customer dataset from CSV file

# Define path to raw data file
raw_data_path <- "data/raw/Mall_Customers.csv"

# Load dataset using read.csv
if (file.exists(raw_data_path)) {
  df <- read.csv(raw_data_path, stringsAsFactors = FALSE)
  cat("Dataset loaded successfully.\n")
  cat("Dimensions of dataset:", dim(df)[1], "rows and", dim(df)[2], "columns.\n")
  
  # Print the first few rows to verify loading
  print(head(df))
} else {
  stop("Error: Raw data file not found at ", raw_data_path)
}
