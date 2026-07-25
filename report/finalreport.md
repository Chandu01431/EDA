# 📑 Final Project Report: Mall Customer Segmentation

**Project**: Mall Customer Segmentation using Unsupervised Learning
**Techniques**: Exploratory Data Analysis, K-Means Clustering, Hierarchical Clustering
**Language/Tools**: R (tidyverse, ggplot2, cluster, factoextra, dendextend)
**Date**: July 2026

---

## 1. Executive Summary

This project analyzes the behavior of 200 mall customers to identify distinct, actionable customer segments for targeted marketing. Using `Annual Income` and `Spending Score` as the primary clustering features, two independent unsupervised learning methods — **K-Means** and **Hierarchical (Ward linkage) Clustering** — were applied and validated against each other and across an 80/20 train-test split.

Both methods converge on the same result: **5 well-separated, stable customer segments**, with strong agreement between algorithms (**Adjusted Rand Index ≈ 0.85**) and consistent performance on unseen data (silhouette score ~0.54 on both train and test sets). Each segment has been translated into a customer persona with a corresponding marketing strategy.

**Key business takeaway**: The largest segment (Low Income, Low Spending — ~29%) is price-sensitive and should be targeted with discounts, while the highest-value segment (High Income, High Spending — ~19%) warrants loyalty and exclusivity programs to protect and grow revenue.

---

## 2. Objectives

1. Understand the underlying structure of mall customer demographics and spending behavior.
2. Identify natural customer segments using unsupervised clustering.
3. Validate segment stability and robustness (train/test split, cross-algorithm agreement).
4. Translate statistical clusters into interpretable business personas.
5. Recommend targeted marketing strategies per segment.

---

## 3. Dataset

| Attribute | Detail |
|---|---|
| Source file | `data/raw/Mall_Customers.csv` |
| Records | 200 customers |
| Features | `CustomerID`, `Gender`, `Age`, `Annual Income (k$)`, `Spending Score (1-100)` |
| Missing values | 0 |
| Duplicate rows | 0 |

---

## 4. Methodology

The project followed a standard unsupervised ML pipeline:

```
Raw Data
   │
   ▼
Data Cleaning & Preprocessing  (quality checks, renaming, encoding, scaling)
   │
   ▼
Exploratory Data Analysis      (univariate, bivariate, correlation analysis)
   │
   ▼
Feature Selection & PCA        (select Annual_Income + Spending_Score)
   │
   ├──────────────► K-Means Clustering (k=5, 80/20 split)
   │
   └──────────────► Hierarchical Clustering (Ward linkage, k=5, 80/20 split)
   │
   ▼
Cluster Comparison & Validation (ARI, silhouette, stability)
   │
   ▼
Business Interpretation & Marketing Recommendations
```

---

## 5. Data Preprocessing

Full detail: [`preprocessing/DATA_CLEANING_REPORT.md`](preprocessing/DATA_CLEANING_REPORT.md)

- **Quality checks**: No missing values (`sum(is.na(df)) == 0`), no duplicates.
- **Renaming**: `Annual Income (k$)` → `Annual_Income`, `Spending Score (1-100)` → `Spending_Score`.
- **Encoding**: `Gender` mapped to `Gender_Encoded` (Female = 1, Male = 2).
- **Scaling**: `Age`, `Annual_Income`, `Spending_Score` standardized to z-scores (mean = 0, sd = 1) for distance-based clustering.
- **Outputs**: `mall_customers_original.csv` (interpretable scale), `mall_customers_scaled.csv` (model-ready).

---

## 6. Exploratory Data Analysis

Full detail: [`eda/EDA_SUMMARY_REPORT.md`](eda/EDA_SUMMARY_REPORT.md)

### 6.1 Univariate Findings

| Feature | Range | Mean | Median | Notes |
|---|---|---|---|---|
| Age | 18–70 | 38.85 | 36 | Concentrated between 25–50 |
| Annual Income | $15k–$137k | $60.56k | $61.5k | Few outliers above $130k |
| Spending Score | 1–100 | 50.2 | 50 | Low: 69, Medium: 53, High: 78 customers |
| Gender | — | — | — | Female 56% (112), Male 44% (88) |

### 6.2 Bivariate & Correlation Findings

| Variable Pair | Correlation | Interpretation |
|---|---|---|
| Annual Income ↔ Spending Score | +0.011 | Independent — no linear relationship |
| Age ↔ Spending Score | -0.327 | Moderate negative — older customers spend less |
| Age ↔ Annual Income | +0.008 | Independent |
| Gender ↔ Spending Score | -0.058 | Negligible |

### 6.3 Key Visual Insight

The scatter plot of **Annual Income vs. Spending Score** shows **five distinct, visually separable groups**:

1. High Income, High Spending
2. High Income, Low Spending
3. Medium Income, Medium Spending
4. Low Income, High Spending
5. Low Income, Low Spending

![Income vs Spending](eda/plots/08_income_vs_spending_scatter.png)

This single chart is the primary justification for choosing `Annual_Income` and `Spending_Score` as clustering features, and for testing `k = 5`.

---

## 7. Feature Selection & PCA

Full detail: [`models/feature_selection/FEATURE_SELECTION_REPORT.md`](models/feature_selection/FEATURE_SELECTION_REPORT.md)

- `Age` was excluded from the primary clustering feature set — it correlates weakly with income and only moderately with spending, and including it blurred the clean 5-cluster structure seen in the Income–Spending plane.
- `Annual_Income` and `Spending_Score` were retained as the final clustering features: they are on comparable, well-understood business scales and produce the clearest, most interpretable segmentation.
- PCA was run as a validation step to confirm no better lower-dimensional projection existed.

![PCA Plot](models/feature_selection/pca_plot.png)

---

## 8. K-Means Clustering

Full detail: [`models/kmeans/KMEANS_REPORT.md`](models/kmeans/KMEANS_REPORT.md)

### 8.1 Choosing k

| Method | Result |
|---|---|
| Elbow Method | Diminishing returns after k=5 (WCSS drops 36.7% at k=5, then flattens) |
| Silhouette Method | Best score at k=5 (**0.547**) |

![Elbow Plot](models/kmeans/plots/01_elbow_plot.png)
![Silhouette Plot](models/kmeans/plots/02_silhouette_plot.png)

### 8.2 Final Clusters (k = 5, training data)

| Cluster | Persona | Count | Avg Income ($k) | Avg Spending |
|---|---|---|---|---|
| 1 | High Income, Low Spending | 28 (17.5%) | 88.9 | 19 |
| 2 | High Income, High Spending | 30 (18.8%) | 86.4 | 81 |
| 3 | Middle Income, Middle Spending | 35 (21.9%) | 60.1 | 49 |
| 4 | Low Income, High Spending | 20 (12.5%) | 33.2 | 73 |
| 5 | Low Income, Low Spending | 47 (29.4%) | 33.1 | 30 |

![K-Means Clusters](models/kmeans/plots/03_kmeans_clusters.png)

### 8.3 Validation

- Train silhouette: 0.547 · Test silhouette: ~0.54
- Centroid drift between train/test: < 3 units on both dimensions
- Converged in 2 iterations
- **Conclusion**: clusters generalize well to unseen customers

![Train vs Test](models/kmeans/plots/04_kmeans_train_vs_test.png)

---

## 9. Hierarchical Clustering

Full detail: [`models/hierarchical/HIERARCHICAL_REPORT.md`](models/hierarchical/HIERARCHICAL_REPORT.md)

### 9.1 Method

- Agglomerative clustering with **Ward's linkage (ward.D2)** on Euclidean distances.
- Distance matrix: 160 × 160 training customers, mean distance 2.145.
- Dendrogram cut at a height (~75) that isolates **5 clusters**, chosen because of the large jump in merge height between the 5- and 4-cluster solutions — independently confirming K-Means' choice of k=5.

![Dendrogram](models/hierarchical/plots/dendrogram_colored_k5.png)

### 9.2 Final Clusters (k = 5, training data)

| Cluster | Persona | Count | Avg Income ($k) | Avg Spending |
|---|---|---|---|---|
| 1 | High Income, Low Spending | 32 | 86.2 | 22 |
| 2 | High Income, High Spending | 28 | 88.1 | 79 |
| 3 | Middle Income, Middle Spending | 36 | 58.4 | 48 |
| 4 | Low Income, High Spending | 22 | 34.8 | 71 |
| 5 | Low Income, Low Spending | 42 | 32.5 | 28 |

![HC Clusters](models/hierarchical/plots/hc_clusters_original.png)

---

## 10. Cross-Algorithm Validation

![Comparison](models/hierarchical/km_vs_hc_comparison.png)

| Metric | K-Means | Hierarchical |
|---|---|---|
| Silhouette (Train) | 0.547 | ~0.54 |
| Silhouette (Test) | ~0.54 | ~0.53 |
| Cluster size range | 20–47 | 22–42 |
| Adjusted Rand Index | 0.85 (agreement between the two methods) | |

**Both algorithms independently identify the same 5 segments**, defined by the same income/spending boundaries, with cluster sizes within a few customers of each other. This cross-validation gives high confidence that the segmentation reflects genuine structure in the data rather than an artifact of either algorithm.

- **K-Means** is recommended for **production deployment**: faster, scales to larger datasets, and can assign new customers to a cluster in real time.
- **Hierarchical clustering** is recommended for **exploratory analysis and validation**: it does not require pre-specifying k and the dendrogram exposes the relationships between clusters (e.g., which segments are "closer" to each other).

---

## 11. Business Interpretation & Marketing Recommendations

| Segment | Persona | Share | Recommended Strategy |
|---|---|---|---|
| 1 | High Income, Low Spending | ~17.5% | Premium value messaging; investment/retirement-style offers to convert savers into spenders |
| 2 | High Income, High Spending | ~18.8% | Highest revenue potential — exclusive perks, loyalty programs, early access to luxury lines |
| 3 | Middle Income, Middle Spending | ~21.9% | Largest "average" segment — broad-appeal, mid-range bundles and seasonal promotions |
| 4 | Low Income, High Spending | ~12.5% | Aspirational spenders — buy-now-pay-later options, entry-level aspirational products |
| 5 | Low Income, Low Spending | ~29.4% | Largest segment overall — discount programs, bundle deals, loyalty points to build volume |

Full CSV: [`models/kmeans/marketing_recommendations.csv`](models/kmeans/marketing_recommendations.csv)

---

## 12. Limitations

- The dataset is small (200 customers) and synthetic/illustrative in nature; real-world deployment would need a larger, continuously refreshed sample.
- Clustering was based on only two features (`Annual_Income`, `Spending_Score`); `Age` and `Gender` were explored but not incorporated into the final segmentation, so age- or gender-specific sub-patterns within each segment are not captured.
- The `Spending Score` is itself a derived/proprietary metric (assigned by the mall) rather than a directly observable behavior, so its real-world interpretability depends on how it was originally computed.
- K-Means assumes roughly spherical, similarly-sized clusters; while validation here was strong, this assumption may not hold if the underlying customer population shifts.

---

## 13. Conclusion

Through a structured pipeline of data cleaning, exploratory analysis, feature selection, and dual clustering methods, this project confidently identifies **5 stable, business-relevant mall customer segments**. The strong agreement between K-Means and Hierarchical Clustering (ARI ≈ 0.85) and consistent train/test performance (silhouette ≈ 0.54) validate that these segments reflect genuine patterns in customer behavior rather than modeling noise. The resulting personas and marketing recommendations provide a directly actionable foundation for targeted campaigns, resource allocation, and customer relationship strategy.

---

## 14. Project Deliverables

| Deliverable | Location |
|---|---|
| Cleaned datasets | `data/cleaned/` |
| Clustered datasets (final labels) | `data/clustered/` |
| EDA plots (14 charts) | `eda/plots/` |
| K-Means model, plots, cluster profiles | `models/kmeans/` |
| Hierarchical model, plots, cluster profiles | `models/hierarchical/` |
| Stage reports | `preprocessing/DATA_CLEANING_REPORT.md`, `eda/EDA_SUMMARY_REPORT.md`, `models/feature_selection/FEATURE_SELECTION_REPORT.md`, `models/kmeans/KMEANS_REPORT.md`, `models/hierarchical/HIERARCHICAL_REPORT.md` |
| Slide deck | `presentation/Mall_Customer_Segmentation.pptx` |
| Repository overview | `README.md` |
| This report | `FINAL_REPORT.md` |