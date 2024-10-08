# FinalProject - Fardeen Bablu
# Drug Review Data Analysis
library(tidyverse)
library(sylcount)
library(ggplot2)
library(gridExtra)

# Read the data and sort by name 
unsortedDrugs = read.csv("drugs.csv")
drugs = unsortedDrugs[order(unsortedDrugs$drugName), ]

# Function to compute readability scores
readabilityScore = function(textData) {
  sapply(textData, function(text) {
    readability(text)$re
  })
}

# Function to compute word count for each review
wordCount = function(text_data) {
  sapply(strsplit(text_data, "\\s+"), length)
}

# Add predictor variables to the drugs data frame
drugs$charCount = nchar(drugs$review)
drugs$readabilityScore = readabilityScore(drugs$review)

# Filter out rows with invalid readability scores
filtered_drugs = drugs %>%
  filter(readabilityScore > -Inf)

# Calculate average readability by drug
avgReadability = filtered_drugs %>%
  group_by(drugName) %>%
  summarize(avgReadability = mean(readabilityScore, na.rm = TRUE))

# Calculate additional averages for other variables
avgRating = aggregate(rating ~ drugName, data = drugs, FUN = mean)
colnames(avgRating) = c("drugName", "avgRating")

avgCharCount = aggregate(charCount ~ drugName, data = drugs, FUN = mean)
colnames(avgCharCount) = c("drugName", "avgCharCount")

reviewCount = aggregate(review ~ drugName, data = drugs, FUN = length)
colnames(reviewCount) = c("drugName", "reviewCount")

avgUsefulness = aggregate(usefulCount ~ drugName, data = drugs, FUN = mean)
colnames(avgUsefulness) = c("drugName", "avgUsefulCount")

drugs$wordCount = wordCount(drugs$review)

avgWordCount = aggregate(wordCount ~ drugName, data = drugs, FUN = mean)
colnames(avgWordCount) = c("drugName", "avgWordCount")

# Merge calculated averages back into the drugs data frame
drugs = drugs %>%
  merge(avgRating, by = "drugName", all.x = TRUE) %>%
  merge(avgCharCount, by = "drugName", all.x = TRUE) %>%
  merge(reviewCount, by = "drugName", all.x = TRUE) %>%
  merge(avgUsefulness, by = "drugName", all.x = TRUE) %>%
  merge(avgWordCount, by = "drugName", all.x = TRUE) %>%
  merge(avgReadability, by = "drugName", all.x = TRUE)

# Remove irrelevant columns
drugs = subset(
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
drugSumm = drugs %>%
  distinct(drugName, .keep_all = TRUE)

# Output summary and head of data for validation
summary(drugSumm)
head(drugSumm) 
print(drugSumm)

## Histograms
hist_avgRating = ggplot(drugSumm, aes(x = avgRating)) +
  geom_histogram(binwidth = 0.5, fill = "skyblue", color = "black") +
  labs(title = "Distrib. of Avg. Patient Ratings",
       x = "10-Star Patient Rating",
       y = "Frequency")

hist_avgCharCount = ggplot(drugSumm, aes(x = avgCharCount)) +
  geom_histogram(binwidth = 50, fill = "lightgreen", color = "black") +
  labs(title = "Distrib. of Avg. Review Character Counts",
       x = "Review Character Count",
       y = "Frequency")

hist_reviewCount = ggplot(drugSumm, aes(x = reviewCount)) +
  geom_histogram(binwidth = 50, fill = "red", color = "black") +
  labs(title = "Distrib. of Total Reviews Per Drug",
       x = "Total Reviews",
       y = "Frequency")

hist_avgUsefulCount = ggplot(drugSumm, aes(x = avgUsefulCount)) +
  geom_histogram(binwidth = 50, fill = "blue", color = "black") +
  labs(title = "Distrib. of Avg. Users Who Found Review Useful", 
       x = "Users Who Found Review Useful",
       y = "Frequency")


hist_avgWordCount = ggplot(drugSumm, aes(x = avgWordCount)) +
  geom_histogram(binwidth = 50, fill = "purple", color = "black") +
  labs(title = "Distrib. of Avg. Word Count",
       x = "Review Word Count",
       y = "Frequency")

hist_avgReadability = ggplot(drugSumm, aes(x = avgReadability)) +
  geom_histogram(binwidth = 50, fill = "pink", color = "black") +
  labs(title = "Distrib. of Avg. Readability Score of Review",
       x = "Flesch Reading Ease Score",
       y = "Frequency")

# Arrange all histograms in a grid
grid.arrange(hist_avgRating, 
             hist_avgCharCount, 
             hist_reviewCount, 
             hist_avgUsefulCount, 
             hist_avgWordCount, 
             hist_avgReadability, 
             ncol = 2)

## Scatter plots
scatter_avgRating_vs_avgCharCount = ggplot(drugSumm, aes(x = avgCharCount, y = avgRating)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "purple", alpha = 0.2) +
  labs(title = "Average Ratings vs. Average Review Character Counts",
       x = "Average Review Character Counts",
       y = "Average Ratings")

scatter_avgRating_vs_avgWordCount = ggplot(drugSumm, aes(x = avgWordCount, y = avgRating)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "purple", alpha = 0.2) +
  labs(title = "Average Ratings vs. Average Word Counts",
       x = "Average Word Counts",
       y = "Average Ratings")

scatter_avgCharCount_vs_avgWordCount = ggplot(drugSumm, aes(x = avgWordCount, y = avgCharCount)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "purple", alpha = 0.2) +
  labs(title = "Average Review Character Counts vs. Average Word Counts",
       x = "Average Word Counts",
       y = "Average Review Character Counts")

scatter_avgRating_vs_avgReadability = ggplot(drugSumm, aes(x = avgReadability, y = avgRating)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "purple", alpha = 0.2) +
  labs(title = "Average Ratings vs. Average Readability Score",
       x = "Average Readability Score",
       y = "Average Ratings")


# Arrange scatter plots
grid.arrange(scatter_avgRating_vs_avgCharCount, 
             scatter_avgRating_vs_avgWordCount, 
             scatter_avgCharCount_vs_avgWordCount, 
             scatter_avgRating_vs_avgReadability, 
             ncol = 2)

# Linear regression model
mainModel = lm(avgRating ~ avgCharCount + reviewCount + avgUsefulCount + avgWordCount + avgReadability, data = drugSumm)
summary(mainModel)

# Combined scatter plot for all predictor variables vs. avgRating
mainScatter = ggplot(drugSumm, aes(x = avgCharCount + reviewCount + avgUsefulCount + avgWordCount + avgReadability, y = avgRating)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "purple", alpha = 0.2) +
  labs(title = "Average Ratings vs. All Predictor Variables",
       x = "Combined Predictor Variables",
       y = "Average Ratings")

print(mainScatter)
