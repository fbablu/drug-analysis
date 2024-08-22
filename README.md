# Drug Review Data Analysis
This project analyzes patient reviews for various drugs, performing text-based analysis, readability scoring, and visualizations to identify trends in drug efficacy and patient experiences.

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
## Full Report
Click [here](report.pdf) for the full report as a pdf.
