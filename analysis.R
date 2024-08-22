# FinalProject - Fardeen Bablu
# Drug Review Data Analysis
# Import necessary libraries
library(tidyverse)
library(sylcount)
library(ggplot2)
library(gridExtra)

# Read the data
unsortedDrugs <- read.csv("drugs.csv")

# Sort the drugs by name
drugs <- unsortedDrugs[order(unsortedDrugs$drugName), ]

# Function to compute readability scores
readabilityScore <- function(textData) {
  sapply(textData, function(text) {
    readability(text)$re
  })
}

# Function to compute word count for each review
wordCount <- function(text_data) {
  sapply(strsplit(text_data, "\\s+"), length)
}

# Add predictor variables to the drugs data frame
drugs$charCount <- nchar(drugs$review)
drugs$readabilityScore <- readabilityScore(drugs$review)

# Filter out rows with invalid readability scores
filtered_drugs <- drugs %>%
  filter(readabilityScore > -Inf)

# Calculate average readability by drug
avgReadability <- filtered_drugs %>%
  group_by(drugName) %>%
  summarize(avgReadability = mean(readabilityScore, na.rm = TRUE))

# Calculate additional averages for other variables
avgRating <- aggregate(rating ~ drugName, data = drugs, FUN = mean)
colnames(avgRating) <- c("drugName", "avgRating")

avgCharCount <- aggregate(charCount ~ drugName, data = drugs, FUN = mean)
colnames(avgCharCount) <- c("drugName", "avgCharCount")

reviewCount <- aggregate(review ~ drugName, data = drugs, FUN = length)
colnames(reviewCount) <- c("drugName", "reviewCount")

avgUsefulness <- aggregate(usefulCount ~ drugName, data = drugs, FUN = mean)
colnames(avgUsefulness) <- c("drugName", "avgUsefulCount")

drugs$wordCount <- wordCount(drugs$review)

avgWordCount <- aggregate(wordCount ~ drugName, data = drugs, FUN = mean)
colnames(avgWordCount) <- c("drugName", "avgWordCount")

# Merge calculated averages back into the drugs data frame
drugs <- drugs %>%
  merge(avgRating, by = "drugName", all.x = TRUE) %>%
  merge(avgCharCount, by = "drugName", all.x = TRUE) %>%
  merge(reviewCount, by = "drugName", all.x = TRUE) %>%
  merge(avgUsefulness, by = "drugName", all.x = TRUE) %>%
  merge(avgWordCount, by = "drugName", all.x = TRUE) %>%
  merge(avgReadability, by = "drugName", all.x = TRUE)

# Remove irrelevant columns
drugs <- subset(
  drugs, select = -c(
    condition, 
    review, 
    rating, 
    date, 
    usefulCount, 
    charCount, 
    readabilityScore, 
    wordCount))

# Remove duplicate drugs and create summary data frame
drugSumm <- drugs %>%
  distinct(drugName, .keep_all = TRUE)

# Output summary and head of data for validation
summary(drugSumm)
head(drugSumm) 
print(drugSumm)

# Visualizations: Histograms of various distributions
hist_avgRating <- ggplot(drugSumm, aes(x = avgRating)) +
  geom_histogram(binwidth = 0.5, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Avg. Patient Ratings",
       x = "10-Star Patient Rating",
       y = "Frequency")

hist_avgCharCount <- ggplot(drugSumm, aes(x = avgCharCount)) +
  geom_histogram(binwidth = 50, fill = "lightgreen", color = "black") +
  labs(title = "Distrib. of Avg. Review Character Counts",
       x = "Review Character Count",
       y = "Frequency")

# Add more histograms as before...

# Arrange all histograms in a grid
grid.arrange(hist_avgRating, 
             hist_avgCharCount, 
             hist_reviewCount, 
             hist_avgUsefulCount, 
             hist_avgWordCount, 
             hist_avgReadability, 
             ncol = 2)

# Visualizations: Scatter plots with linear regression
scatter_avgRating_vs_avgCharCount <- ggplot(drugSumm, aes(x = avgCharCount, y = avgRating)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "purple", alpha = 0.2) +
  labs(title = "Average Ratings vs. Average Review Character Counts",
       x = "Average Review Character Counts",
       y = "Average Ratings")

# Add more scatter plots as before...

# Arrange scatter plots
grid.arrange(scatter_avgRating_vs_avgCharCount, 
             scatter_avgRating_vs_avgWordCount, 
             scatter_avgCharCount_vs_avgWordCount, 
             scatter_avgRating_vs_avgReadability, 
             ncol = 2)

# Linear regression model
mainModel <- lm(avgRating ~ avgCharCount + reviewCount + avgUsefulCount + avgWordCount + avgReadability, data = drugSumm)
summary(mainModel)

# Combined scatter plot for all predictor variables vs. avgRating
mainScatter <- ggplot(drugSumm, aes(x = avgCharCount + reviewCount + avgUsefulCount + avgWordCount + avgReadability, y = avgRating)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "purple", alpha = 0.2) +
  labs(title = "Average Ratings vs. All Predictor Variables",
       x = "Combined Predictor Variables",
       y = "Average Ratings")

print(mainScatter)
