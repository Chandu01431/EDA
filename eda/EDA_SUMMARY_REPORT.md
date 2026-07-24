# Exploratory Data Analysis (EDA) Summary Report

This report summarizes key insights and visual patterns discovered in the Mall Customers dataset. These findings help justify the customer segmentation strategies and models.

---

## 📊 Key Visual Insights

### 1. Age Distribution
- **Range & Spreads**: Customers range from 18 to 70 years old.
- **Concentration**: The peak concentration is between 25 and 50 years of age, with a mean age of **38.85 years** and median of **36 years**.
- **Takeaway**: Middle-aged adults are the largest cohort in the mall's customer base.

### 2. Annual Income Distribution
- **Range & Spreads**: Incomes range widely from **$15k** to **$137k** annually.
- **Average Income**: The mean annual income is **$60.56k** (median: **$61.5k**).
- **Outliers**: There are very few extreme income outliers (only a couple above $130k).

### 3. Spending Score (1-100) Distribution
- **Average Score**: The mean spending score is **50.2** (median: **50**).
- **Customer Segmentation Groups**:
  - **Low Spenders (1-39)**: 69 customers
  - **Medium Spenders (40-59)**: 53 customers
  - **High Spenders (60-100)**: 78 customers

### 4. Gender Demographics
- **Female**: 112 customers (**56%**)
- **Male**: 88 customers (**44%**)
- **Income by Gender**: Males have a slightly higher average annual income ($62.2k vs. $59.2k).
- **Spending by Gender**: Females have a slightly higher average spending score (51.5 vs. 48.5).

### 5. Annual Income vs. Spending Score (The Key Pattern)
- **Correlation**: Correlation coefficient is **0.011** (nearly zero). Income and spending score are independent.
- **Visual Structure**: The scatter plot clearly shows **5 distinct clusters** of customers:
  1. **High Income, High Spending (VIPs/Loyal Spenders)**
  2. **High Income, Low Spending (Careful/Frugal)**
  3. **Medium Income, Medium Spending (Average Spenders)**
  4. **Low Income, High Spending (Impulsive/Generous)**
  5. **Low Income, Low Spending (Conservative/Sensible)**

---

## 📈 Correlation Summary Table

| Feature Variable 1 | Feature Variable 2 | Correlation Coefficient | Interpretation |
| :--- | :--- | :--- | :--- |
| Annual Income | Spending Score | `+0.011` | Almost zero correlation (Independent) |
| Age | Spending Score | `-0.327` | Moderate negative correlation (Older customers spend less) |
| Age | Annual Income | `+0.008` | Almost zero correlation |
| Gender (Encoded) | Spending Score | `-0.058` | Negligible correlation |

---

## 🎯 Next Steps for Modelling
- The 5 distinct clusters visually identified in the `Annual_Income` vs. `Spending_Score` relationship confirm that **K-Means clustering** is a highly appropriate technique.
- A value of **K = 5** will be the starting point for K-Means evaluation (using Elbow and Silhouette methods).
