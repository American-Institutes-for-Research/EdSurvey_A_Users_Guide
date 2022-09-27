# Models {#models}


##  Regression Analysis With `lm.sdf`
After the data are read in with the `EdSurvey` package, a linear model can be fit to fully account for the complex sample design used for NCES data by using `lm.sdf`.

The `lm.sdf` function allows jackknife methods (i.e., JK1, JK2, or BRR) or the Taylor series method for variance estimation. By default, the standard error of coefficient is estimated with the jackknife replication method, but users can switch to the Taylor series when appropriate by setting the `varMethod` argument to `varMethod="Taylor"`. When an explicit weight variable is not set, the `lm.sdf` function uses a default weight for the full sample in the analysis. For instance, `origwt` is the default weight in NAEP.

The data are read in and analyzed by the `lm.sdf` function---in this case, `dsex`, `b017451`, the five plausible values for `composite`, and the full sample weight `origwt`. By default, variance is estimated using the jackknife method, so the following call reads in the jackknife replicate weights:


```r
lm1 <- lm.sdf(formula = composite ~ dsex + b017451, data = sdf)
summary(lm1)
#> 
#> Formula: composite ~ dsex + b017451
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
#>                                  coef        se        t
#> (Intercept)                 270.41112   1.02443 263.9615
#> dsexFemale                   -2.95858   0.60423  -4.8965
#> b017451Once every few weeks   4.23341   1.18327   3.5777
#> b017451About once a week     11.22612   1.25854   8.9200
#> b0174512 or 3 times a week   14.94591   1.18665  12.5951
#> b017451Every day              7.52998   1.30846   5.7549
#>                                dof  Pr(>|t|)    
#> (Intercept)                 54.670 < 2.2e-16 ***
#> dsexFemale                  54.991 8.947e-06 ***
#> b017451Once every few weeks 57.316 0.0007131 ***
#> b017451About once a week    54.683 2.983e-12 ***
#> b0174512 or 3 times a week  72.582 < 2.2e-16 ***
#> b017451Every day            48.470 5.755e-07 ***
#> ---
#> Signif. codes:  
#> 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Multiple R-squared: 0.0224
```

After the regression is run, the data are automatically removed from memory. 

`EdSurvey` drops level 1 by default from the discrete predictor and treats it as the reference group. The reference level can be changed through the argument `relevels`. For example, in the previous model, the default reference group is males. In the following example, the reference group is changed to "Female" for the variable `dsex`:


```r
lm1f <- lm.sdf(formula = composite ~ dsex + b017451, data = sdf,
               relevels = list(dsex = "Female"))
summary(lm1f)
#> 
#> Formula: composite ~ dsex + b017451
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
#>                                  coef        se        t
#> (Intercept)                 267.45254   1.13187 236.2919
#> dsexMale                      2.95858   0.60423   4.8965
#> b017451Once every few weeks   4.23341   1.18327   3.5777
#> b017451About once a week     11.22612   1.25854   8.9200
#> b0174512 or 3 times a week   14.94591   1.18665  12.5951
#> b017451Every day              7.52998   1.30846   5.7549
#>                                dof  Pr(>|t|)    
#> (Intercept)                 76.454 < 2.2e-16 ***
#> dsexMale                    54.991 8.947e-06 ***
#> b017451Once every few weeks 57.316 0.0007131 ***
#> b017451About once a week    54.683 2.983e-12 ***
#> b0174512 or 3 times a week  72.582 < 2.2e-16 ***
#> b017451Every day            48.470 5.755e-07 ***
#> ---
#> Signif. codes:  
#> 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Multiple R-squared: 0.0224
```

The coefficient on `dsex` changed from negative in the previous run to positive of the exact same magnitude, whereas none of the other coefficients (aside from the intercept) changed; this is the expected result. 

The standardized regression coefficient also can be returned by adding `src=TRUE` into the summary call for your regression model object: 

```r
summary(lm1f, src=TRUE)
#> 
#> Formula: composite ~ dsex + b017451
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
#>                                   coef         se        t
#> (Intercept)                 2.6745e+02 1.1319e+00 236.2919
#> dsexMale                    2.9586e+00 6.0423e-01   4.8965
#> b017451Once every few weeks 4.2334e+00 1.1833e+00   3.5777
#> b017451About once a week    1.1226e+01 1.2585e+00   8.9200
#> b0174512 or 3 times a week  1.4946e+01 1.1866e+00  12.5951
#> b017451Every day            7.5300e+00 1.3085e+00   5.7549
#>                                dof   Pr(>|t|) stdCoef
#> (Intercept)                 76.454 0.0000e+00      NA
#> dsexMale                    54.991 8.9474e-06  0.0407
#> b017451Once every few weeks 57.316 7.1311e-04  0.0458
#> b017451About once a week    54.683 2.9834e-12  0.1175
#> b0174512 or 3 times a week  72.582 0.0000e+00  0.1659
#> b017451Every day            48.470 5.7550e-07  0.0817
#>                                stdSE   
#> (Intercept)                       NA   
#> dsexMale                    0.008313 **
#> b017451Once every few weeks 0.012791 * 
#> b017451About once a week    0.013175 * 
#> b0174512 or 3 times a week  0.013175 * 
#> b017451Every day            0.014200 * 
#> ---
#> Signif. codes:  
#> 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Multiple R-squared: 0.0224
```

By default, the standardized coefficients are calculated using standard deviations of the variables themselves, including averaging the standard deviation across any plausible values. When `standardizeWithSamplingVar` is set to `TRUE`, the variance of the standardized coefficient is calculated similar to a regression coefficient and therefore includes the sampling variance in the variance estimate of the outcome variable.

### Calculating Multiple Comparisons in lm.sdf

A linear model is analyzed by the `lm.sdf` function---in this case, `dsex`, `b017451`, the five plausible values for `composite`, and the full sample weight `origwt`.


```r
lm1 <- lm.sdf(formula = composite ~ dsex + b003501 + b003601, data = sdf)
summary(lm1)$coefmat
```

Table: (\#tab:table801)Coefficients \label{tab:Coefficients}

|                          |      coef|      se|         t|      dof| Pr(>&#124;t&#124;)|
|:-------------------------|---------:|-------:|---------:|--------:|------------------:|
|(Intercept)               | 262.52409| 1.32295| 198.43843| 43.30064|            0.00000|
|dsexFemale                |  -1.51812| 0.91367|  -1.66156| 68.46417|            0.10117|
|b003501Graduated H.S.     |   4.08166| 1.57890|   2.58513| 41.10442|            0.01338|
|b003501Some ed after H.S. |  15.03018| 1.40534|  10.69502| 45.41276|            0.00000|
|b003501I Don't Know       |  -1.59176| 1.79932|  -0.88465| 34.72285|            0.38243|
|b003601Graduated H.S.     |   2.89789| 1.65445|   1.75157| 44.98221|            0.08666|
|b003601Some ed after H.S. |   9.15489| 1.85547|   4.93399| 25.78984|            0.00004|
|b003601I Don't Know       |  -4.12084| 1.52672|  -2.69914| 37.56060|            0.01036|

The *p*-values for variables run in `lm1` can be corrected for multiple testing. Notice that the only *p*-values adjusted in this example are in rows 6, 7, and 8 of the coefficients in `lm1`, and that column's name is `Pr(>|t|)` so we can extract them with this command


```r
# p-values without adjustment
summary(lm1)$coefmat[6:8, "Pr(>|t|)"]
#> [1] 8.666330e-02 4.083289e-05 1.035995e-02
```

Here the Benjamini and Hochberg (1995) FDR adjustment is used in the argument `method = "BH"`. The output below displays the adjusted *p*-values with the FDR adjustment:


```r
# Benjamini and Hochberg adjusted p-values
p.adjust(p = lm1$coefmat[6:8, "Pr(>|t|)"], method = "BH")
#> [1] 0.0866633006 0.0001224987 0.0155399244
```
The next example adjusts the same *p*-values using the Bonferroni adjustment with `method="bonferroni"`. Below shows the adjusted *p*-values:


```r
# Bonferroni adjusted p-values
p.adjust(p = lm1$coefmat[6:8, "Pr(>|t|)"], method = "bonferroni")
#> [1] 0.2599899019 0.0001224987 0.0310798488
```
We can compare all the values in a single table in \ref{tab:allp}

Table: (\#tab:allAdjustments)Various p-values adjustments for b003501 \label{tab:allp}

|                          |      raw|       BH| Bonferroni|
|:-------------------------|--------:|--------:|----------:|
|b003601Graduated H.S.     | 0.086663| 0.086663|   0.259990|
|b003601Some ed after H.S. | 0.000041| 0.000122|   0.000122|
|b003601I Don't Know       | 0.010360| 0.015540|   0.031080|
The coefficients matrix also can be overwritten by selecting the same vector in the `lm1` linear regression object, updated here the Bonferroni p-values:


```r
lm1$coefmat[6:8, "Pr(>|t|)"] <- p.adjust(lm1$coefmat[6:8, "Pr(>|t|)"], method = "bonferroni")
summary(lm1)$coefmat[6:8, ]
```


Table: (\#tab:updateCoefmatout)Coefficients table after using Bonferroni adjustment to the b003501 variable  \label{tab:Coefficients with Bonferroni}

|                          |     coef|      se|        t|      dof| Pr(>&#124;t&#124;)|
|:-------------------------|--------:|-------:|--------:|--------:|------------------:|
|b003601Graduated H.S.     |  2.89789| 1.65445|  1.75157| 44.98221|            0.25999|
|b003601Some ed after H.S. |  9.15489| 1.85547|  4.93399| 25.78984|            0.00012|
|b003601I Don't Know       | -4.12084| 1.52672| -2.69914| 37.56060|            0.03108|

### Adjusting *p*-Values From Multiple Sources
Sometimes several values must be adjusted at once. In these cases, the `p.adjust` function must be called with all the *p*-values the researcher wishes to adjust together.

For example, if one wishes to adjust values from two regressions and an additional value from another test, all these *p*-values must be put into a single vector and adjusted as a set. Therefore, *p*-value adjustments called on smaller portions of regressions/tests independently may return incorrect adjusted *p*-values and could result in an incorrect inference.

In this example, the coefficients from `b003501` and `b003601`---each from independent regressions---as well as another *p*-value of 0.02 are adjusted.


```r
lm2a <- lm.sdf(formula = composite ~ dsex + b003501, data = sdf)
lm2b <- lm.sdf(formula = composite ~ dsex + b003601, data = sdf)
# pvalues data.frame with missing values
# values of coef that are not in this initial call but will be added
pvalues <- data.frame(source=c(rep("lm2a",3), rep("lm2b",3), "otherp"),
                      coef=rep("",7),
                      p=rep(NA,7),
                      stringsAsFactors=FALSE)
```

This code  is careful to note where the values came from to help avoid transcription errors. The `pvalues` object is then populated using *p*-values and coefficients from the `lm2a` and `lm2b` linear regression objects, rows 1--3 and 4--6 for each, respectively.


```r
# load in values from lm2a
lm2aCoef <- summary(lm2a)$coefmat
pvalues$p[1:3] <- lm2aCoef[3:5,5]
pvalues$coef[1:3] <- row.names(lm2aCoef)[3:5]
# load in values from lm2b
lm2bCoef <- summary(lm2b)$coefmat
pvalues$p[4:6] <- lm2bCoef[3:5,5]
pvalues$coef[4:6] <- row.names(lm2aCoef)[3:5]
```

The additional *p*-value due for adjustment is included in row 7:


```r
# load in other p-value
pvalues$p[7] <- 0.02
colnames(pvalues)[3] <- "Pr(>|t|)"
# check matrix
pvalues
```

Table: (\#tab:table804)Unadjusted *p*-values \label{tab:unadjustedPValues}

|source |coef                      | Pr(>&#124;t&#124;)|
|:------|:-------------------------|------------------:|
|lm2a   |b003501Graduated H.S.     |          0.0000088|
|lm2a   |b003501Some ed after H.S. |          0.0000000|
|lm2a   |b003501I Don't Know       |          0.0295389|
|lm2b   |b003501Graduated H.S.     |          0.0000144|
|lm2b   |b003501Some ed after H.S. |          0.0000000|
|lm2b   |b003501I Don't Know       |          0.0013006|
|otherp |                          |          0.0200000|

Now that the aforementioned *p*-values are included in the same vector, they are adjusted via `p.adjust` using the Benjamini and Hochberg method:


```r
pvalues[,"Adjusted Pr(>|t|)"] <- p.adjust(p = pvalues[,"Pr(>|t|)"], method = "BH")
pvalues
```

Table: (\#tab:table805)Adjusted *p*-values \label{tab:adjustedPValues}

|source |coef                      | Pr(>&#124;t&#124;)| Adjusted Pr(>&#124;t&#124;)|
|:------|:-------------------------|------------------:|---------------------------:|
|lm2a   |b003501Graduated H.S.     |          0.0000088|                   0.0000205|
|lm2a   |b003501Some ed after H.S. |          0.0000000|                   0.0000000|
|lm2a   |b003501I Don't Know       |          0.0295389|                   0.0295389|
|lm2b   |b003501Graduated H.S.     |          0.0000144|                   0.0000253|
|lm2b   |b003501Some ed after H.S. |          0.0000000|                   0.0000000|
|lm2b   |b003501I Don't Know       |          0.0013006|                   0.0018208|
|otherp |                          |          0.0200000|                   0.0233333|

*NOTE:* The `EdSurvey` package produces *p*-values based on the assumption that tests are independent and unassociated with each other; yet this assumption is not always valid. Several possible methods have been developed for dealing with the multiple hypothesis testing problem.  


##  Multivariate Regression With `mvrlm.sdf`
A multivariate regression model can be fit to fully account for the complex sample design used for NCES data by using `mvrlm.sdf`. This function implements an estimator that correctly handles multiple dependent variables that are continuous (such as plausible values), which allows for variance estimation using the jackknife replication method.

The vertical line symbol `|` separates dependent variables on the left-hand side of formula. In the following example, a multivariate regression is fit with two subject scales as the outcome variables (`algebra` and `geometry`) by two predictor variables signifying gender and a survey item concerning the ability to identify the best unit of area (`dsex` and `m072801`):
 
















