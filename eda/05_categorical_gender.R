# ============================================
# TASK 2.5: CATEGORICAL ANALYSIS - GENDER
# ============================================

library(ggplot2)
library(tidyverse)

# Load data
df <- read.csv("data/cleaned/mall_customers_original.csv")

# ========== COUNT GENDER ==========
gender_counts <- df %>% 
  count(Gender) %>%
  arrange(desc(n))

print("Gender Distribution:")
print(gender_counts)

# Calculate percentages
gender_pct <- gender_counts %>%
  mutate(Percentage = round(n / sum(n) * 100, 1))

print("\nGender with Percentages:")
print(gender_pct)

# ========== PLOT: GENDER BARPLOT ==========
p <- ggplot(gender_pct, aes(x = Gender, y = n, fill = Gender)) +
  geom_bar(stat = "identity", alpha = 0.7, color = "black", size = 1) +
  geom_text(aes(label = paste(n, "\n(", Percentage, "%)")), 
            vjust = -0.5, size = 5, fontface = "bold") +
  labs(
    title = "Customer Distribution by Gender",
    x = "Gender",
    y = "Number of Customers",
    subtitle = paste("Female:", gender_pct$n[1], "| Male:", gender_pct$n[2])
  ) +
  scale_y_continuous(limits = c(0, max(gender_pct$n) * 1.15)) +
  scale_fill_manual(values = c("Female" = "#FF69B4", "Male" = "#4169E1")) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11),
    legend.position = "none"
  )

print(p)

# Save
ggsave("eda/plots/07_gender_barplot.png", p, width = 8, height = 6, dpi = 300)
print("✓ Saved: 07_gender_barplot.png")

# ========== STATISTICS ==========
print("\n========== GENDER BREAKDOWN ==========")
print(paste("Total Customers:", sum(gender_counts$n)))
print(paste("Female:", gender_pct$n[gender_pct$Gender == "Female"], "customers"))
print(paste("Male:", gender_pct$n[gender_pct$Gender == "Male"], "customers"))
print(paste("Female %:", gender_pct$Percentage[gender_pct$Gender == "Female"], "%"))
print(paste("Male %:", gender_pct$Percentage[gender_pct$Gender == "Male"], "%"))

print("\n✓ Task 2.5 Complete!")
