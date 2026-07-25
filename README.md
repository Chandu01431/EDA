# 🛍️ Mall Customer Segmentation — EDA & Clustering

An end-to-end **unsupervised learning** project in R that segments mall customers into actionable marketing groups using **Exploratory Data Analysis**, **K-Means**, and **Hierarchical Clustering**.

![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r&logoColor=white)
![Status](https://img.shields.io/badge/status-complete-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Dataset](#-dataset)
- [Project Structure](#-project-structure)
- [Pipeline](#-pipeline)
- [Data Cleaning](#-data-cleaning)
- [Exploratory Data Analysis](#-exploratory-data-analysis)
- [Feature Selection & PCA](#-feature-selection--pca)
- [K-Means Clustering](#-k-means-clustering)
- [Hierarchical Clustering](#-hierarchical-clustering)
- [K-Means vs Hierarchical](#-k-means-vs-hierarchical)
- [Marketing Recommendations](#-marketing-recommendations)
- [Tech Stack](#-tech-stack)
- [How to Run](#-how-to-run)
- [Presentation](#-presentation)
- [Author](#-author)

---

## 🧭 Overview

This repository walks through a complete customer segmentation workflow on the classic **Mall Customers** dataset:

1. **Preprocess** raw data (quality checks, cleaning, encoding, scaling)
2. **Explore** the data visually to uncover patterns (EDA)
3. **Select features** and validate them with PCA
4. **Cluster** customers using both **K-Means** and **Hierarchical (Ward linkage)** methods
5. **Interpret** clusters into business-friendly customer personas
6. **Recommend** targeted marketing strategies per segment

The final output is **5 well-separated, stable customer segments** based on `Annual Income` and `Spending Score`, validated with an 80/20 train-test split and cross-checked between two independent clustering algorithms (Adjusted Rand Index ≈ **0.85**).

---

## 📂 Dataset

**Source**: `data/raw/Mall_Customers.csv`

| Column | Description |
|---|---|
| `CustomerID` | Unique customer identifier |
| `Gender` | Male / Female |
| `Age` | Customer age (years) |
| `Annual Income (k$)` | Annual income in thousands of dollars |
| `Spending Score (1-100)` | Score assigned by the mall based on spending behavior |

- **Rows**: 200 customers · **Columns**: 5
- **Missing values**: 0 · **Duplicate rows**: 0

---

## 🗂 Project Structure

```
EDA/
│
├── data/
│   ├── raw/                   → Original dataset
│   ├── cleaned/                → Cleaned & scaled datasets
│   └── clustered/              → Final cluster-labeled datasets
│
├── preprocessing/               → Data quality, cleaning & scaling scripts + report
├── eda/                         → Univariate/bivariate analysis scripts + plots + summary report
├── models/
│   ├── feature_selection/       → Feature importance, scaling check, PCA
│   ├── kmeans/                  → K-Means pipeline, plots, cluster profiles, report
│   └── hierarchical/            → Hierarchical clustering pipeline, plots, dendrograms, report
│
├── presentation/                 → Summary slide deck
└── README.md
```

---

## 🔄 Pipeline

```
Raw Data → Data Cleaning → EDA → Feature Selection/PCA
        → K-Means Clustering ─┐
        → Hierarchical Clustering ─┴→ Comparison → Marketing Recommendations
```

---

## 🧹 Data Cleaning

Full detail: [`preprocessing/DATA_CLEANING_REPORT.md`](preprocessing/DATA_CLEANING_REPORT.md)

- No missing values or duplicates detected.
- Column names simplified (`Annual Income (k$)` → `Annual_Income`, `Spending Score (1-100)` → `Spending_Score`).
- `Gender` encoded numerically (`Female` → 1, `Male` → 2) for distance-based algorithms.
- `Age`, `Annual_Income`, `Spending_Score` standardized (z-score) for clustering.
- Outputs: `mall_customers_original.csv` (readable scale) and `mall_customers_scaled.csv` (model-ready).

---

## 📊 Exploratory Data Analysis

Full detail: [`eda/EDA_SUMMARY_REPORT.md`](eda/EDA_SUMMARY_REPORT.md)

### Key Insights

| Feature | Insight |
|---|---|
| **Age** | Ranges 18–70, mean **38.9 yrs**, concentrated between 25–50 |
| **Annual Income** | Ranges $15k–$137k, mean **$60.6k**, few high-income outliers |
| **Spending Score** | Mean **50.2** · Low (69), Medium (53), High (78) spenders |
| **Gender** | 56% Female (112), 44% Male (88) |
| **Income vs Spending** | Correlation ≈ **0.011** (independent) — reveals **5 natural clusters** |
| **Age vs Spending** | Correlation ≈ **-0.33** — older customers tend to spend less |

### Visuals

<table>
<tr>
<td><img src="eda/plots/01_age_histogram.png" width="400"/></td>
<td><img src="eda/plots/03_income_histogram.png" width="400"/></td>
</tr>
<tr>
<td align="center">Age Distribution</td>
<td align="center">Annual Income Distribution</td>
</tr>
<tr>
<td><img src="eda/plots/05_spending_histogram.png" width="400"/></td>
<td><img src="eda/plots/07_gender_barplot.png" width="400"/></td>
</tr>
<tr>
<td align="center">Spending Score Distribution</td>
<td align="center">Gender Breakdown</td>
</tr>
<tr>
<td><img src="eda/plots/08_income_vs_spending_scatter.png" width="400"/></td>
<td><img src="eda/plots/12_correlation_matrix.png" width="400"/></td>
</tr>
<tr>
<td align="center"><b>Income vs Spending Score</b> — the 5-cluster pattern</td>
<td align="center">Correlation Matrix</td>
</tr>
</table>

The **Income vs. Spending Score** scatter plot is the single most important chart in this project — it visually reveals five natural customer groupings, motivating the choice of `k = 5` for both clustering models.

---

## 🧬 Feature Selection & PCA

Full detail: [`models/feature_selection/FEATURE_SELECTION_REPORT.md`](models/feature_selection/FEATURE_SELECTION_REPORT.md)

- `Annual_Income` and `Spending_Score` were selected as the primary clustering features (strongest, most interpretable separation).
- PCA was run to validate the feature set and check for dimensionality reduction opportunities.

<table>
<tr>
<td><img src="models/feature_selection/pca_plot.png" width="400"/></td>
<td><img src="models/feature_selection/selected_features_plot.png" width="400"/></td>
</tr>
<tr>
<td align="center">PCA Plot</td>
<td align="center">Selected Features</td>
</tr>
</table>

---

## 🎯 K-Means Clustering

Full detail: [`models/kmeans/KMEANS_REPORT.md`](models/kmeans/KMEANS_REPORT.md)

**Method**: K-Means · **Features**: `Annual_Income`, `Spending_Score` · **Validation**: 80/20 train-test split

### Optimal k

Both the **Elbow Method** and **Silhouette Method** agree on **k = 5** (silhouette score = **0.547**, "reasonable structure").

<table>
<tr>
<td><img src="models/kmeans/plots/01_elbow_plot.png" width="400"/></td>
<td><img src="models/kmeans/plots/02_silhouette_plot.png" width="400"/></td>
</tr>
<tr>
<td align="center">Elbow Method</td>
<td align="center">Silhouette Scores</td>
</tr>
</table>

### Cluster Profiles

| Cluster | Segment | Count | Avg Income ($k) | Avg Spending |
|---|---|---|---|---|
| 1 | High Income, Low Spending | 28 | 88.9 | 19 |
| 2 | High Income, High Spending | 30 | 86.4 | 81 |
| 3 | Middle Income, Middle Spending | 35 | 60.1 | 49 |
| 4 | Low Income, High Spending | 20 | 33.2 | 73 |
| 5 | Low Income, Low Spending | 47 | 33.1 | 30 |

### Visuals

<table>
<tr>
<td><img src="models/kmeans/plots/03_kmeans_clusters.png" width="400"/></td>
<td><img src="models/kmeans/plots/04_kmeans_train_vs_test.png" width="400"/></td>
</tr>
<tr>
<td align="center">Final Clusters (k=5)</td>
<td align="center">Train vs. Test Cluster Assignment</td>
</tr>
<tr>
<td colspan="2" align="center"><img src="models/kmeans/cluster_profiles_bar.png" width="500"/></td>
</tr>
<tr>
<td colspan="2" align="center">Cluster Profile Comparison</td>
</tr>
</table>

### Stability & Performance

- Train silhouette: **0.547** · Test silhouette: **~0.54**
- Centroid drift between train/test < 3 units → **highly stable** clusters
- Converged in 2 iterations

---

## 🌳 Hierarchical Clustering

Full detail: [`models/hierarchical/HIERARCHICAL_REPORT.md`](models/hierarchical/HIERARCHICAL_REPORT.md)

**Method**: Agglomerative, **Ward's linkage (ward.D2)** · Distance: Euclidean · Validation: 80/20 split

The dendrogram shows a large jump in merge height when going from 5 → 4 clusters, confirming **k = 5** independently of K-Means.

<table>
<tr>
<td><img src="models/hierarchical/plots/dendrogram_colored_k5.png" width="400"/></td>
<td><img src="models/hierarchical/plots/dendrogram_truncated.png" width="400"/></td>
</tr>
<tr>
<td align="center">Dendrogram Colored by Cluster (k=5)</td>
<td align="center">Truncated Dendrogram</td>
</tr>
<tr>
<td><img src="models/hierarchical/plots/hc_clusters_original.png" width="400"/></td>
<td><img src="models/hierarchical/plots/hc_cluster_sizes.png" width="400"/></td>
</tr>
<tr>
<td align="center">Final Clusters (Original Scale)</td>
<td align="center">Cluster Sizes</td>
</tr>
</table>

### Cluster Profiles

| Cluster | Segment | Count | Avg Income ($k) | Avg Spending |
|---|---|---|---|---|
| 1 | High Income, Low Spending | 32 | 86.2 | 22 |
| 2 | High Income, High Spending | 28 | 88.1 | 79 |
| 3 | Middle Income, Middle Spending | 36 | 58.4 | 48 |
| 4 | Low Income, High Spending | 22 | 34.8 | 71 |
| 5 | Low Income, Low Spending | 42 | 32.5 | 28 |

---

## ⚖️ K-Means vs Hierarchical

<p align="center"><img src="models/hierarchical/km_vs_hc_comparison.png" width="600"/></p>

| Metric | K-Means | Hierarchical |
|---|---|---|
| Silhouette (Train) | 0.547 | ~0.54 |
| Silhouette (Test) | ~0.54 | ~0.53 |
| Cluster size range | 20–47 | 22–42 |
| **Adjusted Rand Index** | **~0.85 (strong agreement)** | |

**Both algorithms independently converge on the same 5 customer segments**, giving high confidence in the result.

- ✅ **K-Means** → recommended for **production**: faster, scales better, easily assigns new customers.
- ✅ **Hierarchical** → best for **exploration/validation**: no need to pre-specify k, dendrogram reveals cluster hierarchy.

---

## 📣 Marketing Recommendations

| Segment | Strategy |
|---|---|
| 💰 High Income, Low Spending | Premium value messaging, investment/retirement-style offers |
| 🌟 High Income, High Spending | Exclusive perks, loyalty programs, early access to luxury lines |
| ⚖️ Middle Income, Middle Spending | Broad-appeal, mid-range bundles & seasonal promotions |
| 🎯 Low Income, High Spending | Buy-now-pay-later, aspirational entry-level products |
| 🏷️ Low Income, Low Spending | Discount programs, bundle deals, loyalty points |

Full list: [`models/kmeans/marketing_recommendations.csv`](models/kmeans/marketing_recommendations.csv)

---

## 🛠 Tech Stack

- **Language**: R
- **Core packages**: `tidyverse`, `ggplot2`, `GGally`, `cluster`, `factoextra`, `dendextend`, `corrplot`, `mclust`
- **Project management**: RStudio Project (`EDA.Rproj`)

---

## ▶️ How to Run

```r
# 1. Clone the repository
git clone https://github.com/Chandu01431/EDA.git
cd EDA

# 2. Open EDA.Rproj in RStudio

# 3. Install dependencies
install.packages(c("tidyverse", "ggplot2", "GGally", "cluster",
                    "factoextra", "dendextend", "corrplot", "mclust"))

# 4. Run scripts in order
# preprocessing/  →  eda/  →  models/feature_selection/  →  models/kmeans/  →  models/hierarchical/
```

Each numbered `.R` script in a folder is meant to be run sequentially (e.g. `01_...R`, `02_...R`, ...).

---

## 🎤 Presentation

A summary slide deck of the full project is available at [`presentation/Mall_Customer_Segmentation.pptx`](presentation/Mall_Customer_Segmentation.pptx).

---
