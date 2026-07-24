# Mall Customer Segmentation

```
mall-customer-segmentation/
│
├── data/
│   ├── raw/
│   │   └── Mall_Customers.csv
│   ├── cleaned/
│   │   ├── mall_customers_original.csv
│   │   └── mall_customers_scaled.csv
│   └── clustered/
│       ├── mall_customers_kmeans.csv
│       └── mall_customers_hierarchical.csv
│
├── preprocessing/
│   ├── 01_data_loading.R
│   ├── 02_data_quality_check.R
│   ├── 03_clean_column_names.R
│   ├── 04_categorical_handling.R
│   ├── 05_feature_scaling.R
│   ├── 06_save_cleaned_data.R
│   └── DATA_CLEANING_REPORT.md
│
├── eda/
│   ├── 01_eda_setup.R
│   ├── 02_univariate_age.R
│   ├── 03_univariate_income.R
│   ├── 04_univariate_spending.R
│   ├── 05_categorical_gender.R
│   ├── 06_bivariate_income_spending.R
│   ├── 07_bivariate_age_income.R
│   ├── 08_bivariate_age_spending.R
│   ├── 09_correlation_analysis.R
│   ├── 10_gender_breakdown.R
│   ├── plots/ (14 PNG files)
│   └── EDA_SUMMARY_REPORT.md
│
├── models/
│   ├── feature_selection/
│   │   ├── 01_feature_importance.R
│   │   ├── 02_feature_scaling_check.R
│   │   ├── 03_pca_analysis.R
│   │   └── FEATURE_SELECTION_REPORT.md
│   │
│   ├── kmeans/
│   │   ├── 01_kmeans_setup.R
│   │   ├── 02_elbow_method.R
│   │   ├── 03_silhouette_method.R
│   │   ├── 04_kmeans_model.R
│   │   ├── 05_kmeans_visualization.R
│   │   ├── 06_cluster_interpretation.R
│   │   ├── plots/ (PNG files)
│   │   ├── cluster_profiles.csv
│   │   ├── kmeans_model_k5.rds
│   │   └── KMEANS_REPORT.md
│   │
│   └── hierarchical/
│       ├── 01_hierarchical_setup.R
│       ├── 02_hierarchical_model.R
│       ├── 03_dendrogram.R
│       ├── 04_cluster_cutting.R
│       ├── 05_hc_visualization.R
│       ├── 06_hc_interpretation.R
│       ├── 07_comparison_kmeans_vs_hc.R
│       ├── plots/ (PNG files)
│       ├── cluster_profiles_hc.csv
│       ├── hc_model.rds
│       └── HIERARCHICAL_REPORT.md
│
├── presentation/
│   └── Mall_Customer_Segmentation.pptx
│
└── README.md (this file)
```

## Overview
This repository contains the complete modular structure for the **Mall Customer Segmentation** project, including data preprocessing, exploratory data analysis (EDA), feature selection, K-Means clustering, and Hierarchical Clustering models.
