# K-Means Clustering Report

This report presents the K-Means clustering model used to segment mall customers based on `Annual_Income` and `Spending_Score`. 

To validate the stability and reproducibility of the clusters, the dataset was split into an **80% training set (160 observations)** and a **20% testing set (40 observations)**.

---

## 📈 Optimal Cluster Number (k) Selection

Both the Elbow Method and the Silhouette Coefficient Method were run on the training split:
- **Elbow Method (WCSS)**: The within-cluster sum of squares curve flattens significantly after **k = 5**, indicating the optimal elbow point.
- **Silhouette Method**: The peak average silhouette width occurs at **k = 5** with a score of **0.547**, indicating a reasonable cluster structure.

---

## 🎯 Model Performance & Validation

| Split | Number of Observations | Average Silhouette Width | Description |
| :--- | :--- | :--- | :--- |
| **Training Set (80%)** | 160 | `0.547` | Confirms distinct, well-separated cluster segments |
| **Testing Set (20%)** | 40 | `0.539` | High silhouette score on unseen data confirms stability |

---

## 👥 Customer Segment Profiles

Centroids and statistics computed on the full dataset reveal 5 distinct segments:

| Cluster ID | Segment Name | Customer Count | Avg Age | Avg Income | Avg Spending Score | % Female | Description |
| :---: | :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **1** | Careful/Frugal | 35 | 41.1 yrs | $88.2k | 17.1 | 45.7% | High income earners who are conservative spenders. |
| **2** | VIP/Loyal Spenders | 39 | 32.7 yrs | $86.5k | 82.1 | 53.8% | High income, highly active spenders. Primary target for premium offers. |
| **3** | Average Spenders | 81 | 42.7 yrs | $55.3k | 49.5 | 59.3% | Moderate income and spending. Representative of general customer base. |
| **4** | Impulsive/Generous | 22 | 25.3 yrs | $25.7k | 79.4 | 59.1% | Younger, lower-income customers who spend aggressively. |
| **5** | Conservative/Sensible | 23 | 45.2 yrs | $26.3k | 20.9 | 60.9% | Lower-income, low spending behavior. |

---

## 🔄 Stability Analysis (Train vs. Test)

Comparing average cluster statistics across the splits verifies segment consistency:
- **Mean Income Deviation**: ~1.2k$ variation between splits.
- **Mean Spending Deviation**: ~1.9 points variation between splits.
- **Result**: The clusters are highly stable and generalize well to unseen test data.

---

## 🖼️ Visual Exhibits
- **Elbow Plot**: Saved as [01_elbow_plot.png](file:///c:/Users/rahul/OneDrive/Desktop/EDA/models/kmeans/plots/01_elbow_plot.png)
- **Silhouette Plot**: Saved as [02_silhouette_plot.png](file:///c:/Users/rahul/OneDrive/Desktop/EDA/models/kmeans/plots/02_silhouette_plot.png)
- **K-Means Clusters (Train)**: Saved as [03_kmeans_clusters.png](file:///c:/Users/rahul/OneDrive/Desktop/EDA/models/kmeans/plots/03_kmeans_clusters.png)
- **Train vs. Test Alignment**: Saved as [04_kmeans_train_vs_test.png](file:///c:/Users/rahul/OneDrive/Desktop/EDA/models/kmeans/plots/04_kmeans_train_vs_test.png)
