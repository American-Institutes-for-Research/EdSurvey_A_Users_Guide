# Analysis Outside `EdSurvey` {#analysisOutsideEdSurvey}

`EdSurvey` gives users functions to efficiently analyze education survey data. Although `EdSurvey` allows for rudimentary data manipulation and analysis, this chapter will discuss how to integrate other R packages into `EdSurvey`. As this chapter will demonstrate, this functionality is especially useful for data processing and manipulation in popular R packages such as `dplyr`.

## Integration With Any Other Package

By calling the function `getData()`, one can extract a `light.edsurvey.data.frame`: a `data.frame`-like object containing requested variables, weights, and each weight's associated replicate weights. This `light.edsurvey.data.frame` can be not only manipulated as with other `data.frame` objects but also used with packaged `EdSurvey` functions. As noted in [Chapter 6](#retrievingAllVariablesInADataset), setting the arguments `dropOmittedLevels` and `defaultConditions` to `FALSE` ensures that the values that would normally be removed are included. The argument `addAttributes = TRUE` ensures the extraction of necessary survey design attributes, including the replicate weights, PSU variables, and strata variables.


```r
library(EdSurvey)
#> Warning: package 'EdSurvey' was built under R version 4.3.1
#> Loading required package: car
#> Loading required package: carData
#> Loading required package: lfactors
#> lfactors v1.0.4
#> Loading required package: Dire
#> Dire v2.1.1
#> EdSurvey v4.0.1
#> 
#> Attaching package: 'EdSurvey'
#> The following objects are masked from 'package:base':
#> 
#>     cbind, rbind
sdf <- readNAEP(path = system.file("extdata/data", "M36NT2PM.dat", package = "NAEPprimer"))
gddat <- getData(data = sdf, varnames = c('composite', 'dsex', 'b017451', 'origwt'),
                addAttributes = TRUE, dropOmittedLevels = FALSE)
```

The base R function `gsub` allows users to substitute one string for another. The following step recodes "Every day" to "Seven days a week". The `head` function reveals the first 6 values of the recoded variable `b017451` accessed by the `$` operator:


```r
# 1. Recode a Column Based on a String

gddat$b017451 <- gsub(pattern = "Every day", replacement = "Seven days a week",
                      x = gddat$b017451)
head(x = gddat$b017451)
#> [1] "Seven days a week"    "About once a week"   
#> [3] "Seven days a week"    "Seven days a week"   
#> [5] "Once every few weeks" "2 or 3 times a week"
```

After manipulating the data, you can use a `light.edsurvey.data.frame` with any `EdSurvey` function. As shown in the previous example, after retrieving a dataset, it can be used with most other R package functions, but occasionally one might encounter errors. A helper function to circumvent these errors is `rebindAttributes`.

## Applying `rebindAttributes` to Use `EdSurvey` Functions With Manipulated Data Frames

The `rebindAttributes` function allows users to reassign the survey data attributes required by `EdSurvey` to a data frame that might have had its attributes stripped during the manipulation process. After rebinding the attributes, all variables---including those outside the original dataset---are available for `EdSurvey` analytical functions.

For example, a user might want to run a linear model using `composite`, the default weight `origwt`, the variable `dsex`, and the categorical variable `b017451` recoded into a binary variable. To do so, we can return a portion of the `sdf` survey data as the `gddat` object. Next, use the base R function `ifelse` to conditionally recode the variable `b017451` by collapsing the levels `"Never or hardly ever"` and `"Once every few weeks"` into one level (`"Rarely"`) and all other levels into `"At least once a week"`.


```r
gddat <- getData(data = sdf, varnames = c("dsex", "b017451", "origwt", "composite"),
                 dropOmittedLevels = TRUE)
gddat$studyTalk <- ifelse(gddat$b017451 %in% c("Never or hardly ever",
                                               "Once every few weeks"),
                          "Rarely", "At least once a week")
```

From there, apply `rebindAttributes` from the attribute data `sdf` to the manipulated data frame `gddat`. The new variables are now available for use in `EdSurvey` analytical functions:


```r
gddat <- rebindAttributes(data = gddat, attributeData = sdf)
lm2 <- lm.sdf(formula = composite ~ dsex + studyTalk, data = gddat)
summary(object = lm2)
#> 
#> Formula: composite ~ dsex + studyTalk
#> 
#> Weight variable: 'origwt'
#> Variance method: jackknife
#> JK replicates: 62
#> Plausible values: 5
#> jrrIMax: 1
#> full data n: 17606
#> n used: 16331
#> 
#> Coefficients:
#>                      coef        se        t    dof
#> (Intercept)     281.69030   0.96690 291.3349 39.915
#> dsexFemale       -2.89797   0.59549  -4.8665 52.433
#> studyTalkRarely  -9.41418   0.79620 -11.8239 53.205
#>                  Pr(>|t|)    
#> (Intercept)     < 2.2e-16 ***
#> dsexFemale      1.081e-05 ***
#> studyTalkRarely < 2.2e-16 ***
#> ---
#> Signif. codes:  
#> 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Multiple R-squared: 0.0168
```

## Integration With `dplyr`

One popular package for data manipulation in the R ecosystem is `dplyr`. Given its ubiquity, it merits noting common errors that one might encounter when performing analyses using `EdSurvey` together with `dplyr`. 

Let's say a user is interested in predicting how often a student talks about studies at home based on their gender and disability status. The following example demonstrates how to predict whether a student talks about studies at home (`b017451`) based on their sex (`dsex`) and whether they have an individualized education plan (`iep`) using the weight `origwt`. The dependent variable `b017451` specified using the outcome level of the regression with `I(b017451 == "Never or hardly ever")`:


```r
library(dplyr)
library(tidyr)
```


```r
gddat <- getData(data = sdf, varnames = c("dsex", "b017451", "iep", "lep", "origwt", "composite"),
                 addAttributes = TRUE, dropOmittedLevels = TRUE)
```

The `dplyr` function `unite()` takes multiple variables and concatenates them, similar to the base R function `paste0()`. The `%>%` (pipe) operator allows an object to be passed forward to another function call.


```r
# Unite columns 
gddat <- gddat %>% unite(col = "combinedVar", dsex, iep, sep = "_")
table(gddat$combinedVar)
#> 
#>  Female_No Female_Yes    Male_No   Male_Yes 
#>       7574        590       7044       1113
```


```r
# Specify level in I()
logit1 <- logit.sdf(formula = I(b017451 == "Never or hardly ever") ~ combinedVar,
                    data = gddat)
#> Error in checkDataClass(data, c("edsurvey.data.frame", "light.edsurvey.data.frame", : The argument 'data' must be an edsurvey.data.frame, a light.edsurvey.data.frame, or an edsurvey.data.frame.list. See "Using the 'EdSurvey' Package's getData Function to Manipulate the NAEP Primer Data vignette" for how to work with data in a light.edsurvey.data.frame.
```

When we attempt to run the logistic regression, `EdSurvey` returns an error that it cannot locate the survey weights for this data frame. After creating a new variable, `EdSurvey` can no longer access the survey attributes needed to complete this analysis. To remedy, apply `rebindAttributes` from the attribute data `sdf` to the manipulated data frame `gddat`:


```r
gddat <- rebindAttributes(data = gddat, attributeData = sdf)
logit1 <- logit.sdf(formula = I(b017451 =="Never or hardly ever") ~ combinedVar,
                    data = gddat)
```

Other functions, such as `rowwise()`, `group_by()`, and `ungroup()` silently override the class of the `light.edsurvey.data.frame`, causing the attributes to be inaccessible. In the following example, we use `mutate()` to create a new variable `mrpcmAverage` that calculates the mean of each row's plausible values:


```r
gddat <- getData(data = sdf,
                 varnames = c("dsex", "b017451", "iep", "lep", "origwt", "composite"),
                 addAttributes = TRUE, dropOmittedLevels = TRUE)
gddat <- gddat %>%        
  rowwise() %>% 
  mutate(mrpcmAverage = mean(c(mrpcm1, mrpcm2, mrpcm3, mrpcm4, mrpcm5), na.rm = TRUE))
class(gddat)
#> [1] "rowwise_df" "tbl_df"     "tbl"        "data.frame"
```

The function `rebindAttributes()`reapplies survey attributes and prepares the data for use with `EdSurvey` analysis functions.


```r
gddat <- rebindAttributes(data = gddat, attributeData = sdf)
class(gddat)
#> [1] "light.edsurvey.data.frame" "data.frame"
```
