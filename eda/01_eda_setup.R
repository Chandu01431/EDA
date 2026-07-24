# ============================================
# TASK 2.1: EDA SETUP & DATA LOADING
# ============================================

# Load required libraries
library(tidyverse)
library(ggplot2)
library(corrplot)
library(GGally)

# Load cleaned data from Role 1
# This data has been cleaned, scaled, and is ready for analysis
df <- read.csv("data/cleaned/mall_customers_original.csv")

# Display basic information
print("Dataset loaded successfully!")
print("Dataset dimensions:")
print(dim(df))
print("\nFirst 10 rows:")
print(head(df, 10))
print("\nData types:")
print(str(df))
print("\nBasic statistics:")
print(summary(df))

# Check column names
print("\nColumn names:")
print(colnames(df))
