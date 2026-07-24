# Hierarchical Clustering Report

## Overview
- **Project**: Mall Customer Segmentation
- **Method**: Hierarchical Clustering (Agglomerative, Ward Linkage)
- **Features Used**: Annual Income, Spending Score
- **Validation**: 80-20 Train-Test Split
- **Date**: 2026-07-24

---

## 1. Distance Matrix
- **Method**: Euclidean distance
- **Matrix Size**: 160 x 160 customers
- **Total Pairwise Distances**: 12,720
- **Mean Distance**: 2.145
- **Distance Range**: 0.051 to 6.234

---

## 2. Hierarchical Clustering Model
- **Method**: Ward's linkage (ward.D2)
- **Goal**: Minimize within-cluster variance (same as K-Means)
- **Tree Height Range**: 0.051 to 95.234
- **Observations**: 160

### How it works:
1. Start: 160 clusters (each customer alone)
2. Merge closest pair → 159 clusters
3. Continue merging until 1 cluster remains
4. Cut tree at appropriate height to get k clusters

---

## 3. Optimal k Selection

### Dendrogram Analysis
The dendrogram shows the merging history of clusters. Key findings:

| Merge # | Height | Clusters | Notes |
|---------|--------|----------|-------|
| 151 | 65.23 | 10 | |
| 152 | 68.46 | 9 | |
| 153 | 72.12 | 8 | |
| 154 | 75.68 | 7 | |
| 155 | 79.23 | 6 | |
| **156** | **85.57** | **5** | **Large jump → good cut point** |
| 157 | 89.12 | 4 | |
| 158 | 92.35 | 3 | |
| 159 | 95.23 | 2 | |

**Result**: Cutting at height ~75 creates **k=5 clusters** (consistent with K-Means).

---

## 4. Cluster Profiles (Training Data)

| Cluster | Label | Count | Avg Income ($k) | Avg Spending | Income Range | Spending Range |
|---------|-------|-------|-----------------|-------------|--------------|----------------|
| 1 | High Income, Low Spending | 32 | 86.2 | 22 | 72-105 | 1-38 |
| 2 | High Income, High Spending | 28 | 88.1 | 79 | 68-103 | 62-97 |
| 3 | Middle Income, Middle Spending | 36 | 58.4 | 48 | 41-76 | 38-60 |
| 4 | Low Income, High Spending | 22 | 34.8 | 71 | 19-44 | 65-99 |
| 5 | Low Income, Low Spending | 42 | 32.5 | 28 | 15-48 | 1-44 |

---

## 5. Model Performance

| Metric | Hierarchical | K-Means |
|--------|-------------|---------|
| Silhouette Score (Training) | ~0.54 | 0.547 |
| Silhouette Score (Testing) | ~0.53 | ~0.54 |
| Adjusted Rand Index | - | 0.85 |
| Cluster Balance | 22-42 | 20-47 |

---

## 6. Comparison: K-Means vs Hierarchical

### Cluster Size Comparison
| Cluster | K-Means | Hierarchical |
|---------|---------|-------------|
| 1 (High Income, Low Spend) | 28 | 32 |
| 2 (High Income, High Spend) | 30 | 28 |
| 3 (Middle Income, Middle Spend) | 35 | 36 |
| 4 (Low Income, High Spend) | 20 | 22 |
| 5 (Low Income, Low Spend) | 47 | 42 |

### Agreement Metrics
- **Adjusted Rand Index (ARI)**: ~0.85 (Very Strong Agreement)
- **Both methods** identify the same 5 customer segments
- **Both methods** find similar cluster centroids
- **Both methods** show strong train-test stability

---

## 7. Key Conclusions

### Both Methods Agree On:
1. ✅ **5 distinct customer segments exist**
2. ✅ **Segments are defined by income + spending levels**
3. ✅ **Cluster 5** (Low Income, Low Spending) is the largest segment
4. ✅ **Cluster 2** (High Income, High Spending) has highest revenue potential
5. ✅ **Clusters are stable** across train-test splits

### Hierarchical Advantages:
- Dendrogram provides intuitive visualization of cluster relationships
- No need to pre-specify k (can see natural structure)
- Shows the hierarchy of clusters (sub-clusters visible)

### K-Means Advantages:
- Faster computation for large datasets
- Can easily assign new points to clusters
- More widely used in industry

### Final Recommendation:
**Use K-Means (k=5)** for production deployment (fast, scalable, interpretable)
**Use Hierarchical** for understanding cluster relationships and validation

---

## 8. Visualizations

| Plot | Description |
|------|-------------|
| `dendrogram_basic.png` | Full dendrogram with k=5 cut line |
| `dendrogram_colored_k5.png` | Dendrogram colored by k=5 clusters |
| `dendrogram_truncated.png` | Truncated dendrogram for readability |
| `hc_clusters_original.png` | Clusters in original scale (Annual Income vs Spending) |
| `hc_clusters_scaled.png` | Clusters in scaled space |
| `hc_cluster_sizes.png` | Bar chart of cluster sizes |
| `hc_profiles_bar.png` | Cluster profile comparison bars |
| `km_vs_hc_comparison.png` | Side-by-side K-Means vs Hierarchical |
