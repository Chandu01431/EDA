# ============================================
# TASK 4.2: ELBOW METHOD ON TRAINING DATA (80%)
# ============================================

library(cluster)
library(factoextra)

# Load training data
train_data_scaled <- readRDS("models/kmeans/train_data_scaled.rds")

cat("====================================\n")
cat(" ELBOW METHOD - TRAINING DATA (80%)\n")
cat("====================================\n")

# Create output folder if it doesn't exist
if(!dir.exists("models/kmeans")){
  dir.create("models/kmeans", recursive = TRUE)
}

# ---------- Save Plot ----------

png(
  filename = "models/kmeans/elbow_plot_training.png",
  width = 10,
  height = 7,
  units = "in",
  res = 100
)

fviz_nbclust(
  train_data_scaled,
  FUNcluster = kmeans,
  method = "wss",
  k.max = 10,
  nstart = 25
) +
  labs(
    title = "Elbow Method for Optimal k (Training Data - 80%)",
    x = "Number of Clusters (k)",
    y = "Total Within Cluster Sum of Squares",
    subtitle = "Choose the elbow point"
  ) +
  theme_minimal()

dev.off()

cat("✓ Elbow plot saved successfully.\n\n")

# ---------- Calculate WCSS ----------

wcss_values <- numeric(10)

for(k in 1:10){
  
  km <- kmeans(
    train_data_scaled,
    centers = k,
    nstart = 25,
    iter.max = 100
  )
  
  wcss_values[k] <- km$tot.withinss
}

wcss_df <- data.frame(
  k = 1:10,
  WCSS = wcss_values
)

wcss_df$Decrease <- c(NA, diff(wcss_df$WCSS))

wcss_df$Pct_Decrease <- c(
  NA,
  (-diff(wcss_df$WCSS) / head(wcss_df$WCSS, -1))*100
)

cat("========== WCSS VALUES ==========\n")
print(wcss_df)

cat("\n========== Percentage Decrease ==========\n")

for(i in 2:nrow(wcss_df)){
  cat(
    paste0(
      "k=", i,
      " : ",
      round(wcss_df$Pct_Decrease[i],2),
      "% decrease\n"
    )
  )
}

cat("\n====================================\n")
cat("Check the elbow plot and choose k.\n")
cat("If the curve bends near k = 5,\n")
cat("then Optimal k = 5.\n")
cat("====================================\n")

