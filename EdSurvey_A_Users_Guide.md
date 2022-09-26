--- 
title: " Analyzing NCES Data Using EdSurvey: A User's Guide"
author: EdSurvey Team\footnote{NCES 2021-044}
date: "2022-09-26"
site: bookdown::bookdown_site
description: |
  | The EdSurvey R package brings together the ability to download, extract data from, and analyze with common procedures all the methodologies that a researcher needs to analyze NCES survey data. Analyzing NCES Data Using EdSurvey\\: A User’s Guide is an e-book that provides guidance for how to use the `EdSurvey` R package to analyze NCES data.
  | This book covers analysis of data with complex sampling, plausible values, and longitudinal data methodologies inherent to NCES educational databases complete with examples in `EdSurvey`. Comprehensive examples walk readers through how to use many analysis types\\: from data access, processing, and manipulation to statistical analyses, including cross tabulation, gap analysis, correlation, regressions, and multilevel mixed models. Statistical methodologies for EdSurvey appear in Chapters 11 and 12.
  | The book has two formats: a web-based version, which is accessible through a web browser such as Edge or   Chrome, and an epub version for easy access on smart devices such as smartphones and tablets.

documentclass: book
bibliography: [biblio.bib]
csl: apa-annotated-bibliography.csl
pandoc_args: ["--csl", "apa-annotated-bibliography.csl"]
link-citations: yes
always_allow_html: true
url: https://github.com/American-Institutes-for-Research/EdSurvey_A_Users_Guide
cover-image: "images/cover.png"
apple-touch-icon: "touch-icon.png"
apple-touch-icon-size: 120
favicon: "favicon.ico"
---

# Analyzing NCES Data Using EdSurvey: A User's Guide  {.unnumbered}

Placeholder


## Learning to Use `EdSurvey`
### Available Resources
## Analyzing NCES Data Using EdSurvey: A User's Guide {.unnumbered}
## Rationale for `EdSurvey`
## History of NCES Data Analysis
### Step 1: Importing NCES Data Using the Electronic Code Book
### Step 2: Data Cleaning and Recoding
### Step 3: Performing Hypotheses Testing and Variance Estimation
## Development of the `EdSurvey` R Package
## Considerations for Analyzing NCES Data
## Overview of EdSurvey Fundamentals

<!--chapter:end:index.Rmd-->


# Introduction

Placeholder


## Sampling Design
## Testing Design
## Why EdSurvey

<!--chapter:end:01-introduction.Rmd-->

# Installing R and `EdSurvey` and Loading the Package {#installation}

## Software Requirements

Unless you already have R version 3.5 or later, install the latest R version---which is available online at [https://cran.r-project.org/](https://cran.r-project.org/). Users also may want to install RStudio desktop, which has an interface that many find easier to follow. RStudio is available online at  [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/).


## Installing and Loading EdSurvey

Inside R, run the following command to install `EdSurvey` as well as its package dependencies:




```r
install.packages("EdSurvey")
```

Once the package is successfully installed, load `EdSurvey` can be loaded with the following command:


```r
library(EdSurvey)
```

<!--chapter:end:02-installation.Rmd-->


# Philosophy of Analysis {#philosophyOfAnalysis}

Placeholder


## Download or License Data
## Reading in Data
### Vignette Sample NCES Dataset
### NCES Dataset
### Subsetting the Data {#subsettingData}
### Explore Variable Distributions With `summary2`
### Retrieving Data for Further Manipulation With `getData`
### Retrieving All Variables in a Dataset
### Applying `rebindAttributes` to Use `EdSurvey` Functions With Manipulated Data Frames

<!--chapter:end:03-philosophy.Rmd-->


# Data Access {#dataAccess}

Placeholder


## NAEP: National Assessment of Educational Progress
### Reading NAEP Data
## ECLS: Early Childhood Longitudinal Study {#ECLS-data}
#### Obtaining ECLS-K Data
#### Reading ECLS-K Data
### ECLS-K:2011
#### Obtaining ECLS-K:2011 Data
#### Reading ECLS-K:2011 Data
### ECLS-B
#### Reading ECLS_B Data
## ELS: Education Longitudinal Study of 2002
### Obtaining ELS Data
### Reading ELS Data
## HSLS: High School Longitudinal Study of 2009
### Obtaining HSLS Data
### Reading HSLS Data
## ICCS and CivED: International Civic and Citizen Education Study and Civic Education Study 1999
### Obtaining CivED Data
### Obtaining ICCS Data
### Reading CivED Data
### Reading ICCS Data
## ICILS: International Computer and Information Literacy Study
### Obtaining ICILS Data
### Reading ICILS Data
## TIMSS: Trends in International Mathematics and Science Study
### Obtaining TIMSS Data
### Reading TIMSS Data
## TIMSS Advanced: Trends in International Mathematics and Science Study
### Obtaining TIMSS Advanced Data
### Reading TIMSS Advanced Data
## PIAAC: Program for the International Assessment of Adult Competencies
### Obtaining PIAAC Data
### Reading PIAAC Data
## PIRLS and ePIRLS: Progress in International Reading Literacy Study
### PIRLS
#### Obtaining PIRLS Data
#### Reading PIRLS Data
### ePIRLS
#### Obtaining ePIRLS Data
#### Reading ePIRLS Data
## PISA: Programme for International Student Assessment
### Obtaining PISA Data
### Reading PISA Data
## PISA YAFS: Programme for International Student Assessment Young Adult Follow-up Study
### Obtaining PISA YAFS Data
### Reading PISA YAFS Data
### Link PISA YAFS Data to PISA 2012
## TALIS: Teaching and Learning International Survey
### Obtaining TALIS Data
### Reading TALIS Data
## NHES: National Household Education Surveys
### Obtaining NHES Data
### Reading NHES Data
## SSOCS: School Survey on Crime and Safety
### Obtaining SSOCS Data
### Reading SSOCS Data

<!--chapter:end:04-data-access.Rmd-->


# Understanding Data {#understandingData}

Placeholder


## Searching Variables
## Displaying Basic Information
## Exploring Data
### `summary2()`
### `edsurveyTable()`
### `ggplot2`

<!--chapter:end:05-understanding-data.Rmd-->


# Data Manipulation in `EdSurvey` and Base R {#dataManipulation}

Placeholder


## Subsetting the Data
## Recoding Variable Names and Levels Using `recode.sdf` and `rename.sdf`
## Retrieving Data for Further Manipulation With `getData`
## Retrieving All Variables in a Dataset {#retrievingAllVariablesInADataset}
## Using `EdSurvey` Functions on a Unique `light.edsurvey.data.frame`
### `edsurveyTable`
### `lm.sdf`
### cor.sdf
## Applying `rebindAttributes` to Use `EdSurvey` Functions With Manipulated Data Frames
## Important Data Manipulation Notes
### Memory Usage
### Forgetting to Include a Column Variable

<!--chapter:end:06-data-manipulation.Rmd-->


# Descriptive Statistics

Placeholder


## Computing the Percentages of Students With `achievementLevels`
## Calculating Percentiles With `percentile`
## Correlating Variables With `cor.sdf`
### Weighted Correlations
### Unweighted Correlations
## Preparing an `edsurvey.data.frame.list` for Cross Datasets Comparisons
### Combining Several `edsurvey.data.frame` Objects Into a Single Object
### Recommended Workflow for Standardizing Variables in Cross Datasets Comparisons
## Estimating the Difference in Two Statistics With `gap`
### Performing Gap Analysis and Understanding the Summary Output
### Gap Analysis Across Years
### Gap Analysis of Jurisdictions
### Gap Analysis of Achievement Levels and Percentiles
### Multiple Comparisons

<!--chapter:end:07-descriptive-statistics.Rmd-->


# Models {#models}

Placeholder


##  Regression Analysis With `lm.sdf`
### Calculating Multiple Comparisons in lm.sdf
### Adjusting *p*-Values From Multiple Sources
##  Multivariate Regression With `mvrlm.sdf`
##  Logistic Regression Analysis With `glm.sdf`, `logit.sdf`, and `probit.sdf`
### Recovering Odds Ratios
### Wald Tests
##  Quantile Regression Analysis with `rq.sdf`
##  Mixed Models With `mixed.sdf`

<!--chapter:end:08-models.Rmd-->


# Analysis Outside `EdSurvey` {#analysisOutsideEdSurvey}

Placeholder


## Integration With Any Other Package
## Applying `rebindAttributes` to Use `EdSurvey` Functions With Manipulated Data Frames
## Integration With `dplyr`

<!--chapter:end:09-analysis-outside-of-EdSurvey.Rmd-->


# Longitudinal Datasets

Placeholder


## Using `EdSurvey` to Access ECLS-K:2011 Data for Analysis
## Retrieving Survey Weights
## Retrieving Stratum and PSU Variables  
## Recoding Data
## Removing Special Values
## Explore Variable Distributions With `summary2`
## Retrieving Data for Further Manipulation With `getData`
### Retrieving a Set of Variables in a Dataset
### Retrieving All Variables in a Dataset
### Recoding Variables in a Dataset {#recodingVariables}
#### Applying `rebindAttributes` to Use `EdSurvey` Functions With Manipulated Data Frames
## Making a Table With `edsurveyTable`

<!--chapter:end:10-longitudinal-datasets.Rmd-->


# Statistical Methods Used in `EdSurvey` {#methods}

Placeholder


## Introduction
## Estimation of Weighted Means
### Estimation of Weighted Means When Plausible Values Are Not Present
### Estimation of Weighted Means When Plausible Values Are Present
#### Estimation of the Coefficient of Determination in a Weighted Linear Regression
### Estimation of Standard Deviations
### Estimation of Standardized Regression Coefficients
#### Default Variance Estimation of Standardized Regression Coefficients 
#### Sampling Variance Estimation of Standardized Regression Coefficients 
### Estimation of Standard Errors of Weighted Means When Plausible Values Are Not Present, Using the Jackknife Method
### Estimation of Standard Errors of Weighted Means When Plausible Values Are Present, Using the Jackknife Method
### Estimation of Standard Errors of Weighted Means When Plausible Values Are Not Present, Using the Taylor Series Method
### Estimation of Standard Errors of Weighted Means When Plausible Values Are Present, Using the Taylor Series Method
### Estimation of Standard Errors of Differences of Means
## Estimation of Weighted Percentages
### Estimation of Weighted Percentages When Plausible Values Are Not Present
### Estimation of Weighted Percentages When Plausible Values Are Present
### Estimation of the Standard Error of Weighted Percentages When Plausible Values Are Not Present, Using the Jackknife Method
### Estimation of the Standard Error of Weighted Percentages When Plausible Values Are Present, Using the Jackknife Method
### Estimation of the Standard Error of Weighted Percentages When Plausible Values Are Not Present, Using the Taylor Series Method
## Estimation of Degrees of Freedom
### Estimation of Degrees of Freedom, Using the Jackknife
### Estimation of Degrees of Freedom, Using the Taylor Series
### Estimation of Degrees of Freedom for Statistics Pooled Across Multiple Surveys
## Estimation of Weighted Mixed Models
### Weighted Mixed Model Variance Estimation
## Multivariate Regression
### Estimation
#### Coefficient Estimation
#### Variance Estimation
#### Residual Variance--Covariance Matrix Estimation
#### Coefficient Variance--Covariance Matrix Estimation
##  Wald Tests

<!--chapter:end:11-statistical-methodology.Rmd-->


# NAEP Linking Error {#linkingerror}

Placeholder


## Introduction
## In EdSurvey
### Formulas
#### Estimation
#### Overview of NAEP Linking Error Methodology
##### Imputation Variance
##### Sampling Variance

<!--chapter:end:12-NAEP-linking-error.Rmd-->


# The EdSurvey `suggestWeights` Function

Placeholder


## Introduction
## Using the `suggestWeights` Function to Determine the Weight
## General Considerations When Selecting Weights
## Inside `suggestWeights`
## Limitations
## APPENDIX
## Weights Developed for Use With the ECLS-K:2011 Base-Year Data: School Year 2010–11
## Weights Developed for Use With the ECLS-K:2011 First-Grade Data: School Year 2011–12
## Weights Developed for Use With the ECLS-K:2011 Second-Grade Data
## Weights Developed for Use With the ECLS-K:2011 Third-Grade Data
## Weights Developed for Use With the ECLS-K:2011 Fourth-Grade Data
## Weights Developed for Use With the ECLS-K:2011 Fifth-Grade Data: Spring 2016

<!--chapter:end:13-suggestWeights.Rmd-->


# References {-}


<!--chapter:end:14-references.Rmd-->

