# Data Cleaning Report

This document summarizes the preprocessing steps performed on the raw Mall Customers dataset to prepare it for exploratory data analysis (EDA) and clustering models.

## Preprocessing Summary

### 1. Data Quality Checks
- **Dimensions**: The dataset has 200 rows and 5 columns.
- **Missing Values (NAs)**: None detected in any column (`sum(is.na(df)) == 0`).
- **Duplicate Rows**: No duplicate records found (`sum(duplicated(df)) == 0`).

### 2. Column Renaming
To simplify scripting and remove special characters/spaces, column names were updated as follows:
- `CustomerID` -> `CustomerID`
- `Gender` -> `Gender`
- `Age` -> `Age`
- `Annual Income (k$)` -> `Annual_Income`
- `Spending Score (1-100)` -> `Spending_Score`

### 3. Categorical Variables Encoding
- Column `Gender` (categorical: `Female` / `Male`) was mapped to a new numeric column `Gender_Encoded`:
  - `Female` -> `1`
  - `Male` -> `2`
- This makes the feature compatible with distance metrics and machine learning algorithms that require numeric inputs.

### 4. Feature Scaling
- Features `Age`, `Annual_Income`, and `Spending_Score` have different ranges (e.g. income is in thousands, spending score is 1-100).
- Standard scaling (z-score normalization: `(x - mean) / sd`) was applied to center features at `mean = 0` and standard deviation `sd = 1`.
- Scaling is essential for K-Means and Hierarchical Clustering to prevent larger scale variables from dominating distance calculations.

## Saved Datasets
The following processed outputs are saved under `data/cleaned/`:
1. `mall_customers_original.csv`: Includes cleaned column names and categorical encodings with original numeric scales (useful for visualization/interpretation).
2. `mall_customers_scaled.csv`: Fully cleaned and scaled numeric columns (ready for model training).
