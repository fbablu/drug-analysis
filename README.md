## Goal
This project analyzes patient reviews for various drugs, performing text-based analysis, readability scoring, and visualizations to identify trends in drug efficacy and patient experiences. Here is the [original dataset](https://doi.org/10.24432/C5SK5S)

## Files
- `drug_analysis.R`: The main R script for data processing, analysis, and visualization.
- `drugs.csv`: The dataset containing drug reviews, ratings, and other attributes.
  
## Analysis Overview
The script performs the following:
- **Text Processing**: Calculates readability scores, word counts, and character counts for each review.
- **Averages Calculation**: Computes average ratings, usefulness, and readability scores for each drug.
- **Visualizations**: Includes histograms and scatter plots to display the distribution of various variables.
- **Linear Regression**: Fits a model to predict drug ratings based on review characteristics.

## Installation
Make sure you have the necessary R libraries:
```r
install.packages(c("tidyverse", "sylcount", "ggplot2", "gridExtra"))
```
## Quick Summary

I explored and analyzed drug efficacy based on real-world patient feedback from drug reviews, focusing on correlations between user engagement metrics (e.g., review frequency, usefulness, readability) and perceived drug performance. Using a dataset sourced from Drugs.com with 215,063 reviews, the goal is to explore how patient satisfaction is linked to review characteristics and subjective efficacy.

### Dataset Overview

The dataset contains information on 6,345 unique drugs and various variables, including:
- **drugName**: Drug name
- **condition**: Medical condition
- **review**: Patient review text
- **rating**: Patient rating (1-10)
- **usefulCount**: Count of users who found the review helpful
- **avgRating, avgWordCount, avgUsefulCount**: Aggregated metrics calculated to analyze correlations

### Data Exploration & Findings

After preparing the dataset by combining and cleaning review data, several new variables were added to facilitate analysis, such as average rating, word count, and readability score. Key findings include:
- Mean rating of 7.44, showing an overall positive bias in reviews.
- Mean word count of 62, indicating average review length.
- Mean usefulness count of 20, suggesting engagement with reviews.

Regression analysis highlighted significant predictors impacting average drug ratings, including usefulness count and readability score. Drugs with higher perceived usefulness and clearer reviews tended to receive better ratings.

### Conclusion

This project demonstrates the relationship between user engagement metrics and drug ratings. While the model explained only a small proportion of the variance in ratings (adjusted R² = 0.0236), it identified statistically significant predictors that could be useful for healthcare decision-makers to better understand patient experiences.


## Full Report
Click [here](report.pdf) for the full report as a pdf.
