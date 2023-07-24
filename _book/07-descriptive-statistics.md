
```
#> Warning: package 'EdSurvey' was built under R version 4.3.1
```

# Descriptive Statistics

## Computing the Percentages of Students With `achievementLevels`

The `achievementLevels` function computes the percentages of students' achievement levels or benchmarks defined by an assessment, including NAEP, TIMSS, and PISA. Take NAEP as an example: Each NAEP dataset's unique set of cut points for achievement levels (defined as *Basic, Proficient,* and *Advanced*) is in `EdSurvey`. Analysts can access these cut points using the `showCutPoints` function:


```r
showCutPoints(data = sdf)
#> Achievement Levels:
#>   Mathematics:  262, 299, 333
```

The `achievementLevels` function applies the appropriate weights and variance estimation method for each `edsurvey.data.frame`, with several arguments for customizing the aggregation and output of the analysis results. Namely, by using these optional arguments, users can choose to generate the percentage of students performing at each achievement level (*discrete*) and at or above each achievement level (*cumulative*), calculate the percentage distribution of students by achievement levels (discrete or cumulative) and selected characteristics (specified in `aggregateBy`), and compute the percentage distribution of students by selected characteristics within a specific achievement level.

The `achievementLevels` function can produce statistics at both the discrete and cumulative achievement levels. By default, the `achievementLevels` function produces results only by discrete achievement levels; when setting the `returnCumulative` argument to `TRUE`, the function generates results by both discrete and cumulative achievement levels.

To compute overall results by achievement levels, use an NCES dataset's default plausible values in the `achievementVars` argument; using NAEP, for example, they are the five or 20 plausible values for the subject composite scale.


```r
aLev0 <- achievementLevels(achievementVars = c("composite"),
                           data = sdf, returnCumulative = TRUE)
```

```r
aLev0$discrete
#>   composite_Level      N      wtdN   Percent StandardError
#> 1     Below Basic 5731.2 5779.5052 34.132690     0.9744207
#> 2        At Basic 6695.6 6580.2181 38.861552     0.7115633
#> 3   At Proficient 3666.0 3694.7565 21.820549     0.6342187
#> 4     At Advanced  822.2  877.9837  5.185209     0.4007991
```

In the next example, the plausible values for `composite` and the variable `dsex` are used to calculate the achievement levels, which are aggregated by the variable `dsex` using `aggregateBy`.


```r
aLev1 <- achievementLevels(achievementVars = c("composite", "dsex"), aggregateBy = "dsex",
                  data = sdf, returnCumulative = TRUE)
```

```r
aLev1$discrete
#>   composite_Level   dsex      N      wtdN   Percent
#> 1     Below Basic   Male 2880.8 2865.6455 33.666050
#> 2        At Basic   Male 3266.2 3236.4034 38.021772
#> 3   At Proficient   Male 1877.2 1910.7861 22.448213
#> 4     At Advanced   Male  461.8  499.1392  5.863965
#> 5     Below Basic Female 2850.4 2913.8597 34.604399
#> 6        At Basic Female 3429.4 3343.8146 39.710456
#> 7   At Proficient Female 1788.8 1783.9704 21.186066
#> 8     At Advanced Female  360.4  378.8444  4.499079
#>   StandardError
#> 1     1.0951825
#> 2     0.9537470
#> 3     0.7257305
#> 4     0.5081607
#> 5     1.1154848
#> 6     0.8650729
#> 7     0.8148916
#> 8     0.3888590
```

Each level of the `dsex` variable aggregates to 100 for the results by discrete achievement levels. The object `aLev1` created in this call to `achievementLevels` is a `list` with two `data.frame`s: one for the discrete results and the other for the cumulative results. In the previously described code, `aLev1$discrete` shows only the discrete levels. To show the cumulative results, change the specified `data.frame`. For example,


```r
aLev1$cumulative
#>          composite_Level   dsex      N      wtdN   Percent
#> 1            Below Basic   Male 2880.8 2865.6455 33.666050
#> 2      At or Above Basic   Male 5605.2 5646.3287 66.333950
#> 3 At or Above Proficient   Male 2339.0 2409.9253 28.312178
#> 4            At Advanced   Male  461.8  499.1392  5.863965
#> 5            Below Basic Female 2850.4 2913.8597 34.604399
#> 6      At or Above Basic Female 5578.6 5506.6295 65.395601
#> 7 At or Above Proficient Female 2149.2 2162.8149 25.685145
#> 8            At Advanced Female  360.4  378.8444  4.499079
#>   StandardError
#> 1     1.0951825
#> 2     1.0951825
#> 3     0.8635866
#> 4     0.5081607
#> 5     1.1154848
#> 6     1.1154848
#> 7     1.0073379
#> 8     0.3888590
```

The `aggregateBy` argument sums the percentage of students by discrete achievement level up to 100 at the most disaggregated level specified by the analytical variables and determines the order of aggregation. For example, when using `dsex` and `iep` for analysis, `aggregateBy = c("dsex", "iep")` and `aggregateBy = c("iep", "dsex")` produce the same percentage but arrange the results in different ways depending on the order in the argument. When using `aggregateBy = c("iep", "dsex")`, the percentages add up to 100 within each category of `dsex` for each category of `iep`, respectively:


```r
achievementLevels(achievementVars = c("composite", "dsex", "iep"),
                  aggregateBy = c("iep", "dsex"), data = sdf)
#> 
#> AchievementVars: composite, dsex, iep
#> aggregateBy: iep, dsex
#> 
#> Achievement Level Cutpoints:
#> 262 299 333 
#> 
#> Plausible values: 5
#> jrrIMax: 1
#> Weight variable: 'origwt'
#> Variance method: jackknife
#> JK replicates: 62
#> full data n: 17606
#> n used: 16907
#> 
#> 
#> Discrete
#>  composite_Level   dsex iep      N       wtdN    Percent
#>      Below Basic   Male Yes  810.2  753.47862 66.4635116
#>         At Basic   Male Yes  281.6  282.52828 24.9215056
#>    At Proficient   Male Yes   72.8   85.69544  7.5590995
#>      At Advanced   Male Yes    9.4   11.97026  1.0558833
#>      Below Basic Female Yes  471.2  465.33346 76.4954517
#>         At Basic Female Yes  108.8  106.71734 17.5430994
#>    At Proficient Female Yes   31.2   34.36986  5.6500084
#>      At Advanced Female Yes    2.8    1.89454  0.3114405
#>      Below Basic   Male  No 2067.6 2111.69806 28.6261355
#>         At Basic   Male  No 2982.6 2952.86086 40.0289211
#>    At Proficient   Male  No 1804.4 1825.09062 24.7408909
#>      At Advanced   Male  No  452.4  487.16896  6.6040524
#>      Below Basic Female  No 2379.0 2448.49754 31.3451478
#>         At Basic Female  No 3318.8 3236.55190 41.4336531
#>    At Proficient Female  No 1757.4 1749.56228 22.3975264
#>      At Advanced Female  No  356.8  376.79678  4.8236727
#>  StandardError
#>      2.0061208
#>      2.0783210
#>      1.4614600
#>      0.7673700
#>      2.9245271
#>      2.0864253
#>      1.6430596
#>      0.2601418
#>      1.0630715
#>      1.0125447
#>      0.7840337
#>      0.5558956
#>      1.2051321
#>      0.9207178
#>      0.8954779
#>      0.4233201
```

Each unique value pair of the two variables (i.e., Yes + Male or No + Female) sums to 100 because of `aggregateBy`.

*NOTE:* It is not appropriate to aggregate the results by only one variable when more than one variable is used in the analysis. The same variables used in the analysis also need to be used in the argument `aggregateBy()`, but their order can be changed to obtain the desired results.

The `achievementLevels` function also can compute the percentage of students by selected characteristics within a specific achievement level. The object `aLev2` presents the percentage of students by sex within each achievement level (i.e., within each discrete and cumulative level).



```r
aLev2 <- achievementLevels(achievementVars = c("composite", "dsex"),
                           aggregateBy = "composite",
                           data = sdf, returnCumulative = TRUE)
aLev2$discrete
#>   composite_Level   dsex      N      wtdN  Percent
#> 1     Below Basic   Male 2880.8 2865.6455 49.58289
#> 2        At Basic   Male 3266.2 3236.4034 49.18383
#> 3   At Proficient   Male 1877.2 1910.7861 51.71616
#> 4     At Advanced   Male  461.8  499.1392 56.85063
#> 5     Below Basic Female 2850.4 2913.8597 50.41711
#> 6        At Basic Female 3429.4 3343.8146 50.81617
#> 7   At Proficient Female 1788.8 1783.9704 48.28384
#> 8     At Advanced Female  360.4  378.8444 43.14937
#>   StandardError
#> 1     0.9486797
#> 2     0.8020508
#> 3     1.1913055
#> 4     2.0076502
#> 5     0.9486797
#> 6     0.8020508
#> 7     1.1913055
#> 8     2.0076502
aLev2$cumulative
#>          composite_Level   dsex      N      wtdN  Percent
#> 1            Below Basic   Male 2880.8 2865.6455 49.58289
#> 2      At or Above Basic   Male 5605.2 5646.3287 50.62629
#> 3 At or Above Proficient   Male 2339.0 2409.9253 52.70200
#> 4            At Advanced   Male  461.8  499.1392 56.85063
#> 5            Below Basic Female 2850.4 2913.8597 50.41711
#> 6      At or Above Basic Female 5578.6 5506.6295 49.37371
#> 7 At or Above Proficient Female 2149.2 2162.8149 47.29800
#> 8            At Advanced Female  360.4  378.8444 43.14937
#>   StandardError
#> 1     0.9486797
#> 2     0.6131937
#> 3     1.0576369
#> 4     2.0076502
#> 5     0.9486797
#> 6     0.6131937
#> 7     1.0576369
#> 8     2.0076502
```

The percentage of students within a specific achievement level can be aggregated by one or more variables. For example, the percentage of students classified as English learners (`lep`) is aggregated by `dsex` within each achievement level:


```r
aLev3 <- achievementLevels(achievementVars = c("composite", "dsex", "lep"),
                           aggregateBy = c("dsex", "composite"),
                           data = sdf, returnCumulative = TRUE)
aLev3$discrete
#>    composite_Level   dsex lep      N       wtdN    Percent
#> 1      Below Basic   Male Yes  355.8  436.03778 15.2177175
#> 2         At Basic   Male Yes  138.4  156.75146  4.8455620
#> 3    At Proficient   Male Yes   27.6   31.75786  1.6620312
#> 4      At Advanced   Male Yes    1.2    0.75590  0.1514407
#> 5      Below Basic Female Yes  334.2  422.06640 14.4853587
#> 6         At Basic Female Yes   96.4  102.80364  3.0744683
#> 7    At Proficient Female Yes   19.2   22.69640  1.2722408
#> 8      At Advanced Female Yes    1.2    1.80846  0.4773622
#> 9      Below Basic   Male  No 2523.8 2429.29192 84.7822825
#> 10        At Basic   Male  No 3125.0 3078.19756 95.1544380
#> 11   At Proficient   Male  No 1849.6 1879.02820 98.3379688
#> 12     At Advanced   Male  No  460.6  498.38332 99.8485593
#> 13     Below Basic Female  No 2515.4 2491.67850 85.5146413
#> 14        At Basic Female  No 3332.8 3240.98230 96.9255317
#> 15   At Proficient Female  No 1769.6 1761.27402 98.7277592
#> 16     At Advanced Female  No  359.2  377.03598 99.5226378
#>    StandardError
#> 1      1.6567088
#> 2      0.7683424
#> 3      0.5680079
#> 4      0.1976280
#> 5      1.6957678
#> 6      0.7676397
#> 7      0.4289833
#> 8      0.7919682
#> 9      1.6567088
#> 10     0.7683424
#> 11     0.5680079
#> 12     0.1976280
#> 13     1.6957678
#> 14     0.7676397
#> 15     0.4289833
#> 16     0.7919682
aLev3$cumulative
#>           composite_Level   dsex lep      N       wtdN
#> 1             Below Basic   Male Yes  355.8  436.03778
#> 2       At or Above Basic   Male Yes  167.2  189.26522
#> 3  At or Above Proficient   Male Yes   28.8   32.51376
#> 4             At Advanced   Male Yes    1.2    0.75590
#> 5             Below Basic Female Yes  334.2  422.06640
#> 6       At or Above Basic Female Yes  116.8  127.30850
#> 7  At or Above Proficient Female Yes   20.4   24.50486
#> 8             At Advanced Female Yes    1.2    1.80846
#> 9             Below Basic   Male  No 2523.8 2429.29192
#> 10      At or Above Basic   Male  No 5435.2 5455.60908
#> 11 At or Above Proficient   Male  No 2310.2 2377.41152
#> 12            At Advanced   Male  No  460.6  498.38332
#> 13            Below Basic Female  No 2515.4 2491.67850
#> 14      At or Above Basic Female  No 5461.6 5379.29230
#> 15 At or Above Proficient Female  No 2128.8 2138.31000
#> 16            At Advanced Female  No  359.2  377.03598
#>       Percent StandardError
#> 1  15.2177175     1.6567088
#> 2   3.3528686     0.5358274
#> 3   1.3491605     0.4574292
#> 4   0.1514407     0.1976280
#> 5  14.4853587     1.6957678
#> 6   2.3119254     0.5208317
#> 7   1.1330078     0.4270291
#> 8   0.4773622     0.7919682
#> 9  84.7822825     1.6567088
#> 10 96.6471314     0.5358274
#> 11 98.6508395     0.4574292
#> 12 99.8485593     0.1976280
#> 13 85.5146413     1.6957678
#> 14 97.6880746     0.5208317
#> 15 98.8669922     0.4270291
#> 16 99.5226378     0.7919682
```

Users can set unique cut points that override the standard values in the `achievementLevels` function by using the `cut points` argument. In the example that follows, `aLev4` uses customized cut points of 267, 299, and 333. The object `aLev1` uses the standard cut points of `c(262, 299, 333)`. The values for *Proficient* and *Advanced* are unchanged across both objects, whereas the higher threshold to reach the *Basic* category in `aLev4` resulted in a higher percentage of male and female students being categorized as *Below Basic*.


```r
aLev4 <- achievementLevels(achievementVars = c("composite", "dsex"),
                           aggregateBy = "dsex",
                           data = sdf,
                           cutpoints = c("Customized Basic" = 267, 
                                         "Customized Proficient" = 299, 
                                         "Customized Advanced" = 333),
                           returnCumulative = TRUE)
```


```r
aLev4$discrete
#>            composite_Level   dsex      N      wtdN
#> 1   Below Customized Basic   Male 3285.0 3262.6418
#> 2      At Customized Basic   Male 2862.0 2839.4071
#> 3 At Customized Proficient   Male 1877.2 1910.7861
#> 4   At Customized Advanced   Male  461.8  499.1392
#> 5   Below Customized Basic Female 3284.8 3324.5956
#> 6      At Customized Basic Female 2995.0 2933.0787
#> 7 At Customized Proficient Female 1788.8 1783.9704
#> 8   At Customized Advanced Female  360.4  378.8444
#>     Percent StandardError
#> 1 38.330025     1.2149501
#> 2 33.357798     0.9636501
#> 3 22.448213     0.7257305
#> 4  5.863965     0.5081607
#> 5 39.482215     1.1460243
#> 6 34.832640     0.7304983
#> 7 21.186066     0.8148916
#> 8  4.499079     0.3888590
aLev1$discrete
#>   composite_Level   dsex      N      wtdN   Percent
#> 1     Below Basic   Male 2880.8 2865.6455 33.666050
#> 2        At Basic   Male 3266.2 3236.4034 38.021772
#> 3   At Proficient   Male 1877.2 1910.7861 22.448213
#> 4     At Advanced   Male  461.8  499.1392  5.863965
#> 5     Below Basic Female 2850.4 2913.8597 34.604399
#> 6        At Basic Female 3429.4 3343.8146 39.710456
#> 7   At Proficient Female 1788.8 1783.9704 21.186066
#> 8     At Advanced Female  360.4  378.8444  4.499079
#>   StandardError
#> 1     1.0951825
#> 2     0.9537470
#> 3     0.7257305
#> 4     0.5081607
#> 5     1.1154848
#> 6     0.8650729
#> 7     0.8148916
#> 8     0.3888590
```

## Calculating Percentiles With `percentile`

The percentile function compares a numeric vector of percentiles in the range 0 to 100 for a data year. For example, to compare the NAEP Primer's subject composite scale at the 10th, 25th, 50th, 75th, and 90th percentiles, include these as integers in the `percentiles` argument:


```r
pct1 <- percentile(variable = "composite", percentiles = c(10, 25, 50, 75, 90), data = sdf)
pct1
#> Percentile
#> Call: percentile(variable = "composite", percentiles = c(10, 25, 50, 
#>     75, 90), data = sdf)
#> full data n: 17606
#> n used: 16915
#> 
#>  percentile estimate        se       df confInt.ci_lower
#>          10 227.7226 1.0585355 39.78256         225.2284
#>          25 251.9626 1.0179363 42.53475         249.7120
#>          50 277.4784 1.1375443 51.15378         275.7035
#>          75 301.1827 0.9141083 70.56403         299.4265
#>          90 321.9303 0.9061950 62.07559         319.9351
#>  confInt.ci_upper
#>          230.0172
#>          254.0142
#>          279.1926
#>          302.8973
#>          324.0329
```

## Correlating Variables With `cor.sdf`

`EdSurvey` features multiple correlation methods for data exploration and analysis that fully account for the complex sample design in NCES data by using the `cor.sdf` function. These features include the following correlation procedures:

* Pearson product-moment correlations for continuous variables
* Spearman rank correlation for ranked variables
* polyserial correlations for one categorical and one continuous variable
* polychoric correlations for two categorical variables
* correlations among plausible values of the subject scales and subscales (marginal correlation coefficients, which uses the Pearson type)


### Weighted Correlations

In the following example, `b013801`, `t088001`, and the full sample weight `origwt` are read in to calculate the correlation using the Pearson method. Similar to other `EdSurvey` functions, the data are removed automatically from memory after the correlation is run.


```r
cor_pearson <- cor.sdf(x = "b013801", y = "t088001", data = sdf, 
                    method = "Pearson", weightVar = "origwt")
#> Converting "b013801" to a continuous variable.
#> Converting "t088001" to a continuous variable.
```

It is important to note the order of levels to ensure that the correlations are functioning as intended. Printing a correlation object will provide a condensed summary of the correlation details and the order of levels for each variable:


```r
cor_pearson
#> Method: Pearson
#> full data n: 17606
#> n used: 14492
#> 
#> Correlation: -0.07269657
#> Standard Error: 0.02022161
#> Confidence Interval: [-0.1134367, -0.03171236]
#> 
#> Correlation Levels:
#>   Levels for Variable 'b013801' (Lowest level first):
#>     1. 0-10
#>     2. 11-25
#>     3. 26-100
#>     4. >100
#>   Levels for Variable 't088001' (Lowest level first):
#>     1. Less than 3 hours
#>     2. 3-4.9 hours
#>     3. 5-6.9 hours
#>     4. 7 hours or more
```

Variables in `cor.sdf` can be recoded and reordered. Variable levels and values can be redefined given the desired specifications. For example, `b017451` and `t088001` are correlated using the Pearson method, with the levels `"2 or 3 times a week"` and `"Every day"` of the variable `b017451` being recoded to `"Frequently"` within a list of lists in the `recode` argument:


```r
cor_recode <- cor.sdf(x = "b017451", y = "t088001", data = sdf, 
                      method = "Pearson", weightVar = "origwt",
                      recode = list(b017451 = list(from = c("2 or 3 times a week", "Every day"),
                                               to = c("Frequently"))))
#> Converting "b017451" to a continuous variable.
#> Converting "t088001" to a continuous variable.
cor_recode
#> Method: Pearson
#> full data n: 17606
#> n used: 14468
#> 
#> Correlation: -0.01949923
#> Standard Error: 0.01198974
#> Confidence Interval: [-0.04386941, 0.004894141]
#> 
#> Correlation Levels:
#>   Levels for Variable 'b017451' (Lowest level first):
#>     1. Never or hardly ever
#>     2. Once every few weeks
#>     3. About once a week
#>     4. Frequently
#>   Levels for Variable 't088001' (Lowest level first):
#>     1. Less than 3 hours
#>     2. 3-4.9 hours
#>     3. 5-6.9 hours
#>     4. 7 hours or more
```

Recoding is useful when a level is very thinly populated (so it might merit combination with another level) or when changing the value label to something more appropriate for a particular analysis.

The variables `b017451` and `t088001` are correlated using the Pearson method in the following example, with `t088001`'s values of `"Less than 3 hours", "3-4.9 hours", "5-6.9 hours", and "7 hours or more"` being reordered to `"7 hours or more", "5-6.9 hours", "3-4.9 hours", and "Less than 3 hours"` with the `"7 hours or more"` as the lowest level of the list:


```r
cor_reorder <- cor.sdf(x = "b017451", y = "t088001", data = sdf, 
                       method = "Pearson", weightVar = "origwt",
                       reorder = list(t088001 = c("7 hours or more", "5-6.9 hours",
                                                  "3-4.9 hours", "Less than 3 hours")))
#> Converting "b017451" to a continuous variable.
#> Converting "t088001" to a continuous variable.
cor_reorder
#> Method: Pearson
#> full data n: 17606
#> n used: 14468
#> 
#> Correlation: 0.02048827
#> Standard Error: 0.01241005
#> Confidence Interval: [-0.004827359, 0.04577766]
#> 
#> Correlation Levels:
#>   Levels for Variable 'b017451' (Lowest level first):
#>     1. Never or hardly ever
#>     2. Once every few weeks
#>     3. About once a week
#>     4. 2 or 3 times a week
#>     5. Every day
#>   Levels for Variable 't088001' (Lowest level first):
#>     1. 7 hours or more
#>     2. 5-6.9 hours
#>     3. 3-4.9 hours
#>     4. Less than 3 hours
```

Changing the order of the levels might be useful to modify a variable that is out of order or when reversing the orientation of a series. The `reorder` argument also is suitable when implemented in conjunction with recoded levels.

*NOTE:* As an alternative, recoding can be completed within [`getData`](https://www.air.org/sites/default/files/EdSurvey-getData.pdf). To see additional examples of recoding and reordering, use `?cor.sdf` in the R console.

The marginal correlation coefficient among plausible values of the subject scales and subscales can be calculated using the `cor.sdf` function and the Pearson method. The subject subscales `num_oper` and `algebra` are correlated in this example:



```r
cor3_mcc <- cor.sdf(x = "num_oper", y = "algebra", data = sdf, method = "Pearson")
cor3_mcc
#> Method: Pearson
#> full data n: 17606
#> n used: 16915
#> 
#> Correlation: 0.8924728
#> Standard Error: 0.004867251
#> Confidence Interval: [0.8822278, 0.901873]
```

Use the `showPlausibleValues` function to return the plausible values of an `edsurvey.data.frame` to calculate the correlation coefficients between subject scales or subscales.

The `cor.sdf` function features multiple methods for data exploration and analysis using correlations. The following example shows the differences in correlation coefficients among the Pearson, Spearman, and polychoric methods using a `subset` of the `edsurvey.data.frame` data, in which `dsex == 1` (saved as the `sdf_dnf` object), `b017451`, `pared`, and the full sample weight `origwt`:



```r
sdf_dnf <- subset(x = sdf, subset = dsex == 1)
cor_pearson <- cor.sdf(x = "b017451", y = "pared", data = sdf_dnf, 
                    method = "Pearson", weightVar = "origwt")
#> Converting "b017451" to a continuous variable.
#> Converting "pared" to a continuous variable.
cor_spearman <- cor.sdf(x = "b017451", y = "pared", data = sdf_dnf, 
                    method = "Spearman", weightVar = "origwt")
cor_polychoric <- cor.sdf(x = "b017451", y = "pared", data = sdf_dnf, 
                    method = "Polychoric", weightVar = "origwt")
```


```r
cbind(Correlation = c(Pearson = cor_pearson$correlation,
                    Spearman = cor_spearman$correlation,
                    Polychoric = cor_polychoric$correlation))
#>            Correlation
#> Pearson     0.08027069
#> Spearman    0.06655368
#> Polychoric  0.06972564
```

Plausible values for subject scales and subscales also can be correlated with variables using the `cor.sdf` function. In this case, the five plausible values for `composite`, `b017451`, and the full sample weight `origwt` are read in to calculate the correlation coefficients using the Pearson, Spearman, and polyserial methods:


```r
cor_pearson2 <- cor.sdf(x = "composite", y = "b017451", data = sdf_dnf, 
                    method = "Pearson", weightVar = "origwt")
#> Converting "b017451" to a continuous variable.
cor_spearman2 <- cor.sdf(x = "composite", y = "b017451", data = sdf_dnf, 
                    method = "Spearman", weightVar = "origwt")
cor_polyserial2 <- cor.sdf(x = "composite", y = "b017451", data = sdf_dnf, 
                    method = "Polyserial", weightVar = "origwt")
```


```r
cbind(Correlation = c(Pearson = cor_pearson2$correlation,
                      Spearman = cor_spearman2$correlation,
                      Polyserial = cor_polyserial2$correlation))
#>            Correlation
#> Pearson      0.1031247
#> Spearman     0.1148957
#> Polyserial   0.1044407
```

### Unweighted Correlations

The `cor.sdf` function also features the ability to perform correlations without accounting for weights. The `cor.sdf` function automatically accounts for the default sample weights of the NCES dataset read for analysis in `weightVar = "default"` but can be modified by setting `weightVar = NULL`. The following example shows the correlation coefficients of the Pearson and Spearman methods of the variables `pared` and `b017451` while excluding weights:


```r
cor_pearson_unweighted <- cor.sdf(x = "b017451", y = "pared", data = sdf,
                                  method = "Pearson", weightVar = NULL)
#> Converting "b017451" to a continuous variable.
#> Converting "pared" to a continuous variable.
cor_pearson_unweighted
#> Method: Pearson
#> full data n: 17606
#> n used: 16278
#> 
#> Correlation: 0.05316366
#> Standard Error: NA
#> Confidence Interval: [NA]
#> 
#> Correlation Levels:
#>   Levels for Variable 'b017451' (Lowest level first):
#>     1. Never or hardly ever
#>     2. Once every few weeks
#>     3. About once a week
#>     4. 2 or 3 times a week
#>     5. Every day
#>   Levels for Variable 'pared' (Lowest level first):
#>     1. Did not finish H.S.
#>     2. Graduated H.S.
#>     3. Some ed after H.S.
#>     4. Graduated college
#>     5. I Don't Know
cor_spearman_unweighted <- cor.sdf(x = "b017451", y = "pared", data = sdf,
                                   method = "Spearman", weightVar = NULL)
cor_spearman_unweighted
#> Method: Spearman
#> full data n: 17606
#> n used: 16278
#> 
#> Correlation: 0.04283483
#> Standard Error: NA
#> Confidence Interval: [NA]
#> 
#> Correlation Levels:
#>   Levels for Variable 'b017451' (Lowest level first):
#>     1. Never or hardly ever
#>     2. Once every few weeks
#>     3. About once a week
#>     4. 2 or 3 times a week
#>     5. Every day
#>   Levels for Variable 'pared' (Lowest level first):
#>     1. Did not finish H.S.
#>     2. Graduated H.S.
#>     3. Some ed after H.S.
#>     4. Graduated college
#>     5. I Don't Know
```

## Preparing an `edsurvey.data.frame.list` for Cross Datasets Comparisons

Previous examples demonstrated analyses using one dataset, but most `EdSurvey` functions---including `summary2`, `achievementLevels`, and `percentile`---support the analysis of multiple datasets at one time through an `edsurvey.data.frame.list`.  The `edsurvey.data.frame.list` appends `edsurvey.data.frame` objects into one list, which is useful for looking at data, for example, across time or geographically, and reduces repetition in function calls. For instance, four NAEP mathematics assessments from different years can be combined into an `edsurvey.data.frame.list` to make a single call to analysis functions for ease of use in comparing, formatting, and/or plotting output data. Data from various countries in an international study can be integrated into an `edsurvey.data.frame.list` for further analysis.

To prepare an `edsurvey.data.frame.list` for cross datasets analysis, it is necessary to ensure that variable information is consistent across each `edsurvey.data.frame`. When comparing groups across data years, it is not uncommon for variable names and labels to change. For example, some data years feature a split-sample design based on accommodations status, thereby containing differences in frequently used demographic variables between samples as well as across data years. Two useful functions in determining these inconsistencies are `searchSDF()` and `levelsSDF()`, which return variable names, labels, and levels based on a character string.


### Combining Several `edsurvey.data.frame` Objects Into a Single Object

After standardizing variables between each `edsurvey.data.frame`, they are combined into an `edsurvey.data.frame.list` and are ready for analysis. In the following example, `sdf` is subset into four datasets, appended into an `edsurvey.data.frame.list`, and assigned unique labels: 



```r

# make four subsets of sdf by a location variable-scrpsu, "Scrambled PSU and school code"
sdfA <- subset(x = sdf, subset = scrpsu %in% c(5, 45, 56))
sdfB <- subset(x = sdf, subset = scrpsu %in% c(75, 76, 78))
sdfC <- subset(x = sdf, subset = scrpsu %in% 100:200)
sdfD <- subset(x = sdf, subset = scrpsu %in% 201:300)

#combine four datasets to an `edsurvey.data.frame.list`
sdfl <- edsurvey.data.frame.list(datalist = list(sdfA, sdfB, sdfC, sdfD),
                                 labels = c("A locations","B locations",
                                          "C locations","D locations"))
```

This `edsurvey.data.frame.list` can now be analyzed in other `EdSurvey` functions.

### Recommended Workflow for Standardizing Variables in Cross Datasets Comparisons

Although `EdSurvey` features several methods to resolve inconsistencies across `edsurvey.data.frame`s, the following approach is recommended:

1. Connect to each dataset using a read function, such as `readNAEP()`.
2. Recode each discrepant variable name and level using `recode.sdf()` and `rename.sdf()`.
3. Combine datasets into one `edsurvey.data.frame.list` object.
4. Analyze datasets using the `edsurvey.data.frame.list` object.

*NOTE:* It also is possible to retrieve and recode variables with the [`getData`](https://www.air.org/sites/default/files/EdSurvey-getData.pdf) function; further details and examples of this method appear in the vignette titled *Using the `getData` Function in EdSurvey*.

## Estimating the Difference in Two Statistics With `gap`

Gap analysis is a term often used in NAEP that refers to a methodology that estimates the difference between two statistics (e.g., mean scores, achievement level percentages, percentiles, and student group percentages) for two groups in a population. A gap occurs when one group outperforms the other group, such that the difference between the two statistics is statistically significant (i.e., the difference is larger than the margin of error).

The gap analysis can be comparisons 

- between groups (e.g., male students versus female students) by or across years, 
- of the same group between years (e.g., male students in 2017 versus in 2019), or
- between jurisdictions (e.g., two states, district versus home state, state versus national public) by or across years. 

Independent tests with an alpha level of .05 are performed for most of these types of comparisons. For comparisons between jurisdictions, a dependent test is used for the case in which one jurisdiction is contained in another (e.g., state versus national public).

It is typical to test two statistics (e.g., two groups or 2 years) at a time; if you want to test more than that, multiple comparison procedures should be applied for more conservative results. For more information on gap analysis and multiple comparison, see [*Drawing Inferences From NAEP Results*](https://nces.ed.gov/nationsreportcard/tdw/analysis/infer.asp).

### Performing Gap Analysis and Understanding the Summary Output

The following example demonstrates the `gap` function, comparing the gender difference in achievement:



```r
mathGap <- gap(variable = "composite", data = sdf,
               groupA = dsex == "Male", groupB = dsex == "Female")

mathGap
#> Call: gap(variable = "composite", data = sdf, groupA = dsex == "Male", 
#>     groupB = dsex == "Female")
#> 
#> Labels:
#>  group       definition nFullData nUsed
#>      A   dsex == "Male"     17606  8486
#>      B dsex == "Female"     17606  8429
#> 
#> Percentage:
#>      pctA    pctAse     pctB    pctBse    diffAB      covAB
#>  50.27015 0.5016796 49.72985 0.5016796 0.5402935 -0.2516824
#>  diffABse diffABpValue    dofAB
#>  1.003359    0.5924778 53.45667
#> 
#> Results:
#>  estimateA estimateAse estimateB estimateBse   diffAB
#>   276.7235   0.8207151  275.0458   0.9402535 1.677756
#>      covAB  diffABse diffABpValue    dofAB
#>  0.5676583 0.6498719   0.01259479 53.70969
```


The gap output contains three blocks: labels, percentage, and results. 

 * The first block, labels, shows the definition of groups A and B, along with a reminder of the full data *n* count (`nFullData`) and the *n* count of the number of individuals who are in the two subgroups with valid scores (`nUsed`). 
 * The second block, percentage, shows the percentage of individuals who fall into each category, with omitted levels removed. 
 * The third block, results, shows the estimated outcomes from the two groups listed in the columns `estimateA` and `estimateB`. The `diffAB` column shows the estimated difference between the two groups, and the `diffABse` column shows the standard error of the difference. *t*-test significance results show in `difABpValue`, with the degrees of freedom following. When sampling survey respondents through cluster sampling designs (e.g., a design involving sampling students from the same classrooms or schools), these respondents have more in common than randomly selected individuals. Therefore, `EdSurvey` calculates a covariance between groups from the same assessment sample (same assessment and year), which appears in the `covAB` column. Even when selecting respondents through simple random sampling, little harm occurs in estimating the covariance because it will be close to zero.

Users can choose to return only the `data.frame` detailing the results using


```r
mathGap$results
#>   estimateA estimateAse estimateB estimateBse   diffAB
#> 1  276.7235   0.8207151  275.0458   0.9402535 1.677756
#>       covAB  diffABse diffABpValue    dofAB
#> 1 0.5676583 0.6498719   0.01259479 53.70969
```

### Gap Analysis Across Years

For illustration purposes, we first generate two fake datasets for Year 1 and Year 2 to use in examples. You can skip this step if you already have cross-year datasets handy.


```r
set.seed(42)
year1 <- EdSurvey:::copyDataToTemp(f0 = "M32NT2PM")
year2 <- EdSurvey:::copyDataToTemp(f0 = "M40NT2PM")
```

The following example demonstrates the `gap` function, comparing the gender gap between `year1` and `year2` datasets, which are appended into an `edsurvey.data.frame.list`:


```r
# combine two datasets
mathList <- edsurvey.data.frame.list(datalist = list(year1, year2),
                                     labels = c("math year1", "math year2"))
# perform cross year analysis between gender
mathGap2 <- gap(variable = "composite", data = mathList,
               groupA = dsex == "Male", groupB = dsex == "Female")
```

Each gap output contains a `data.frame` detailing the results of the analyses, which are returned using the following:


```r
mathGap2$results
#>       labels estimateA estimateAse estimateB estimateBse
#> 1 math year1  277.2735    1.014495  274.9149    1.040229
#> 2 math year2  276.8393    1.056766  274.3754    1.114861
#>     diffAB     covAB  diffABse diffABpValue    dofAB
#> 1 2.358576 0.3694072 1.1715210   0.05398869 27.44776
#> 2 2.463876 0.7071580 0.9722933   0.01338217 74.24251
#>      diffAA covAA diffAAse diffAApValue    dofAA    diffBB
#> 1        NA    NA       NA           NA       NA        NA
#> 2 0.4342073     0 1.464908    0.7678634 65.12246 0.5395077
#>   covBB diffBBse diffBBpValue    dofBB   diffABAB covABAB
#> 1    NA       NA           NA       NA         NA      NA
#> 2     0 1.524792    0.7241024 117.9997 -0.1053004       0
#>   diffABABse diffABABpValue  dofABAB sameSurvey
#> 1         NA             NA       NA         NA
#> 2   1.522437       0.945065 66.60037      FALSE
```

When the data argument is an `edsurvey.data.frame.list`, the summary results include the following information:

* the group means (`estimateA`/`estimateB`) and standard errors (`estimateAse`/`estimateBse`) across a variable (typically data years)
* the difference between the values of `estimateA` and `estimateB`, as well as its respective standard errors and *p*-value (each starting with `diffAB`)
* the difference between the values of `estimateA` across a variable compared with the reference dataset, as well as its respective standard errors and *p*-value (each starting with `diffAA`)
* the difference within the values of `estimateB` across a variable compared with the reference dataset, as well as its respective standard errors and *p*-value (each starting with `diffBB`)
* the difference between the difference of `estimateA`  and `estimateB` across a variable compared with the reference dataset, as well as its respective standard errors and *p*-value (each starting with `diffABAB`)
* the value `sameSurvey`, which indicates if a line in the data output uses the same survey as the reference line (a logical:  `TRUE`/`FALSE`)

For example, in `mathGap2$results`,

* The gap in mean mathematics scores between the `dsex` variables in Year 1 (`diffAB`) is `2.358576`.
* The gap in mean mathematics scores within the `dsex` variables across data years where `groupA = "Male"` (`diffAA`) is `0.4342073`.
* The gap in mean mathematics scores within the `dsex` variables across data years where `groupB = "Female"` (`diffBB`) is `0.5395077`.
* The gap in mean mathematics scores between the `dsex` variables across data years (`diffABAB`) is `-0.1053004`.

In addition to the summary results, the gap output also contains a `data.frame` of percentage gaps, in a format matching the `data.frame` of the previous results. This is returned by using the following:


```r
mathGap2$percentage
#>       labels     pctA    pctAse     pctB    pctBse
#> 1 math year1 50.31267 0.7732424 49.68733 0.7732424
#> 2 math year2 51.04887 0.7316137 48.95113 0.7316137
#>      diffAB      covAB diffABse diffABpValue    dofAB
#> 1 0.6253492 -0.5979038 1.546485    0.6884604 34.19288
#> 2 2.0977415 -0.5352586 1.463227    0.1569309 59.25477
#>       diffAA covAA diffAAse diffAApValue    dofAA    diffBB
#> 1         NA    NA       NA           NA       NA        NA
#> 2 -0.7361961     0 1.064501    0.4911036 83.97934 0.7361961
#>   covBB diffBBse diffBBpValue    dofBB  diffABAB covABAB
#> 1    NA       NA           NA       NA        NA      NA
#> 2     0 1.064501    0.4911036 83.97934 -1.472392       0
#>   diffABABse diffABABpValue  dofABAB
#> 1         NA             NA       NA
#> 2   2.129002      0.4911036 83.97934
```

### Gap Analysis of Jurisdictions

Comparisons of district, state, and national jurisdictions also can be performed using the `gap` function. The next example demonstrates how to compare multiple datasets, each from a jurisdiction, using the `edsurvey.data.frame.list` object `sdfl`, created previously and representing data from four locations.



```r
mathlocGap <- gap(variable = "composite", data = sdfl,
               groupA = dsex == "Male", groupB = dsex == "Female")

mathlocGap$results
#>        labels estimateA estimateAse estimateB estimateBse
#> 1 A locations  294.9192    6.158446  278.4914    4.998736
#> 2 B locations  290.7389   19.347898  296.2575   18.361466
#> 3 C locations  286.5300    3.707036  294.3619    3.838862
#> 4 D locations  285.8196   37.473667  279.3090   17.786705
#>      diffAB      covAB  diffABse diffABpValue    dofAB
#> 1 16.427856  26.692493  3.086880  0.001331239 6.590889
#> 2 -5.518624 340.429882  5.533971  0.353403676 6.678675
#> 3 -7.831865   3.802534  4.568798  0.134082911 6.418453
#> 4  6.510538 653.985648 20.314313  0.767500316 3.362254
#>     diffAA      covAA  diffAAse diffAApValue    dofAA
#> 1       NA         NA        NA           NA       NA
#> 2 4.180366 84.7127213 15.583394    0.8012387 4.174503
#> 3 8.389230  0.5497927  7.111187    0.2760963 7.105454
#> 4 9.099644 -0.6240987 37.992768    0.8244191 3.404922
#>        diffBB      covBB  diffBBse diffBBpValue     dofBB
#> 1          NA         NA        NA           NA        NA
#> 2 -17.7661140 59.0011184 15.624614   0.30822190  4.882245
#> 3 -15.8704905 -0.2746742  6.346146   0.02943236 11.018163
#> 4  -0.8176736 -0.2150138 18.487408   0.96692113  3.848665
#>    diffABAB    covABAB diffABABse diffABABpValue  dofABAB
#> 1        NA         NA         NA             NA       NA
#> 2 21.946480 -5.1831666   7.107742    0.018774175 6.658063
#> 3 24.259720 -0.2137924   5.552506    0.001956103 8.690019
#> 4  9.917317 -2.5253958  20.670049    0.660489851 3.410698
#>   sameSurvey
#> 1         NA
#> 2       TRUE
#> 3       TRUE
#> 4       TRUE
```

In NAEP, the jurisdiction information is included in a single restricted-use data file. The following examples illustrate, using NAEP, how to conduct comparisons between (a) states, (b) a state versus the nation, and (c) a district versus the home state. 


```r
# comparisons of two states
mathStateGap <- gap(variable = "composite", data = mathList,
                    fips == "California", fips == "Virginia")

# comparisons of state to all public schools in nation
mathList <- subset(mathList, schtyp2 == "Public")
mathStateNationGap <- gap(variable = "composite", data = mathList,
                          fips == "California", schtyp2 == "Public")

# comparisons of district to state
mathStateDistrictGap <- gap("composite", data = mathList,
                            distcod == "Los Angeles", fips == "California")
```

### Gap Analysis of Achievement Levels and Percentiles

Gap analysis also may be performed across achievement levels and percentiles by specifying the values in the `achievementLevel` or `percentiles` arguments, respectively. Using our previous `edsurvey.data.frame.list` object (`mathList`), setting `achievementLevel=c("Basic", "Proficient", "Advanced")` will perform comparisons between groups by and across years for each achievement level value.



```r
mathALGap <- gap(variable = "composite", data = mathList,
                 groupA = dsex == "Male", groupB = dsex == "Female",
                 achievementLevel = c("Basic", "Proficient", "Advanced"))
mathALGap$results
#>         achievementLevel     labels estimateA estimateAse
#> 1      At or Above Basic math year1 66.870662   1.2335219
#> 2      At or Above Basic math year2 66.008354   1.4761274
#> 3 At or Above Proficient math year1 28.719053   1.2778962
#> 4 At or Above Proficient math year2 28.469990   1.0605786
#> 5            At Advanced math year1  6.111211   0.6868165
#> 6            At Advanced math year2  5.833023   0.7136854
#>   estimateB estimateBse   diffAB      covAB  diffABse
#> 1 65.100350   1.3290706 1.770311 0.47346693 1.5300559
#> 2 64.212592   1.2702205 1.795762 0.80498819 1.4773070
#> 3 25.546317   1.1150117 3.172735 0.16683642 1.5945522
#> 4 25.852175   1.2256185 2.617815 0.63726122 1.1629469
#> 5  4.509459   0.5578078 1.601751 0.09886164 0.7649465
#> 6  4.353453   0.4823550 1.479570 0.11276154 0.7186725
#>   diffABpValue    dofAB    diffAA covAA  diffAAse
#> 1   0.25305547 47.43947        NA    NA        NA
#> 2   0.22899798 58.93240 0.8623073     0 1.9236757
#> 3   0.05430082 35.80025        NA    NA        NA
#> 4   0.02759747 68.48216 0.2490623     0 1.6606763
#> 5   0.04228707 42.36482        NA    NA        NA
#> 6   0.04512671 46.64694 0.2781884     0 0.9904867
#>   diffAApValue     dofAA     diffBB covBB  diffBBse
#> 1           NA        NA         NA    NA        NA
#> 2    0.6559148  49.66853  0.8877581     0 1.8384474
#> 3           NA        NA         NA    NA        NA
#> 4    0.8810447 115.55769 -0.3058583     0 1.6569224
#> 5           NA        NA         NA    NA        NA
#> 6    0.7795513  79.05949  0.1560067     0 0.7374387
#>   diffBBpValue     dofBB    diffABAB covABAB diffABABse
#> 1           NA        NA          NA      NA         NA
#> 2    0.6302057 102.66886 -0.02545076       0   2.126854
#> 3           NA        NA          NA      NA         NA
#> 4    0.8538879 109.77788  0.55492055       0   1.973586
#> 5           NA        NA          NA      NA         NA
#> 6    0.8331024  66.60928  0.12218164       0   1.049587
#>   diffABABpValue   dofABAB sameSurvey
#> 1             NA        NA         NA
#> 2      0.9904753 104.21223      FALSE
#> 3             NA        NA         NA
#> 4      0.7793705  73.18939      FALSE
#> 5             NA        NA         NA
#> 6      0.9075937  87.93697      FALSE
```

Similarly, setting `percentiles = c(10, 25, 50, 75, 90)` will perform comparisons between groups by and across years for each percentile value.


```r
mathPercentilesGap <- gap(variable = "composite", data = mathList,
                          groupA = dsex == "Male", groupB = dsex == "Female",
                          percentiles = c(10, 25, 50, 75, 90))
mathPercentilesGap$results
#>    percentiles     labels estimateA estimateAse estimateB
#> 1           10 math year1  228.5492   0.9667854  227.0247
#> 2           10 math year2  227.9186   2.4995864  226.2819
#> 3           25 math year1  253.0893   0.9471983  250.9874
#> 4           25 math year2  252.2491   1.3755823  250.0428
#> 5           50 math year1  278.2843   1.3730106  276.9812
#> 6           50 math year2  278.0656   1.6903894  276.3454
#> 7           75 math year1  302.8779   1.3682276  299.6181
#> 8           75 math year2  302.7776   0.8726368  299.9592
#> 9           90 math year1  324.2191   1.7859545  320.1731
#> 10          90 math year2  324.3229   1.8148749  319.6371
#>    estimateBse   diffAB      covAB diffABse diffABpValue
#> 1    2.2177507 1.524483 0.12874954 2.365501  0.524380292
#> 2    2.2006815 1.636691 1.59047562 2.812469  0.567514040
#> 3    1.5062090 2.101920 0.06906226 1.740036  0.231540228
#> 4    1.3677150 2.206282 0.05717917 1.910108  0.253858464
#> 5    0.9264616 1.303117 0.14110321 1.568848  0.411462617
#> 6    1.3722702 1.720201 1.27774827 1.478190  0.250443398
#> 7    1.1878050 3.259775 0.07671289 1.769040  0.073719644
#> 8    1.0668784 2.818378 0.39727222 1.051275  0.009435823
#> 9    1.2427261 4.046013 0.13587502 2.112404  0.075499842
#> 10   1.3593064 4.685793 0.47512103 2.047252  0.026239504
#>       dofAB     diffAA covAA diffAAse diffAApValue    dofAA
#> 1  28.76492         NA    NA       NA           NA       NA
#> 2  18.81623  0.6305664     0 2.680038    0.8155427 30.88172
#> 3  63.44991         NA    NA       NA           NA       NA
#> 4  47.38973  0.8401989     0 1.670153    0.6168345 57.62887
#> 5  37.37699         NA    NA       NA           NA       NA
#> 6  46.73963  0.2186734     0 2.177745    0.9203339 63.31403
#> 7  35.58427         NA    NA       NA           NA       NA
#> 8  60.84149  0.1002895     0 1.622819    0.9508935 72.08366
#> 9  14.41527         NA    NA       NA           NA       NA
#> 10 51.30331 -0.1038355     0 2.546253    0.9676270 52.23293
#>        diffBB covBB diffBBse diffBBpValue     dofBB
#> 1          NA    NA       NA           NA        NA
#> 2   0.7427746     0 3.124327    0.8129968  53.19276
#> 3          NA    NA       NA           NA        NA
#> 4   0.9445612     0 2.034529    0.6434062 106.40957
#> 5          NA    NA       NA           NA        NA
#> 6   0.6357575     0 1.655735    0.7024377  56.57640
#> 7          NA    NA       NA           NA        NA
#> 8  -0.3411076     0 1.596593    0.8316963  49.70196
#> 9          NA    NA       NA           NA        NA
#> 10  0.5359443     0 1.841761    0.7717175  90.91000
#>      diffABAB covABAB diffABABse diffABABpValue   dofABAB
#> 1          NA      NA         NA             NA        NA
#> 2  -0.1122082       0   3.674993      0.9757890  41.32595
#> 3          NA      NA         NA             NA        NA
#> 4  -0.1043623       0   2.583842      0.9678588 104.78313
#> 5          NA      NA         NA             NA        NA
#> 6  -0.4170841       0   2.155534      0.8470519  81.70437
#> 7          NA      NA         NA             NA        NA
#> 8   0.4413971       0   2.057834      0.8308790  60.72581
#> 9          NA      NA         NA             NA        NA
#> 10 -0.6397798       0   2.941682      0.8288465  43.44324
#>    sameSurvey
#> 1          NA
#> 2       FALSE
#> 3          NA
#> 4       FALSE
#> 5          NA
#> 6       FALSE
#> 7          NA
#> 8       FALSE
#> 9          NA
#> 10      FALSE
```

### Multiple Comparisons

When making groups or families of comparisons in a single analysis, such as comparing White students with minority student groups in terms of test scores, the probability of finding significance by chance for at least one comparison increases with the family size or the number of comparisons. Multiple methods exist to adjust *p*-values to hold the significance level for a set of comparisons at a particular level (e.g., 0.05), and such adjustments are called multiple comparison procedures. NAEP employs two procedures: the Benjamini-Hochberg false discovery rate (FDR) procedure [@BenjaminiHochberg] and the Bonferroni procedure. The Bonferroni procedure was used prior to the 1996 assessment. Thereafter, NAEP has used the FDR procedure. A detailed explanation of the NAEP multiple comparison procedures can be found at [Comparison of Multiple Groups](https://nces.ed.gov/nationsreportcard/tdw/analysis/2000_2001/infer_multiplecompare.aspx).

Typically, the number of comparisons is determined as the number of possible statistical tests in a single analysis. However, in NAEP reports, when comparing multiple years and multiple jurisdictions (e.g., multiple states versus the United States as a whole), usually neither the number of years nor the number of jurisdictions counts toward the number of comparisons.

The next example illustrates how to adjust the *p*-values using the Bonferroni and FDR procedures through R's `p.adjust` function. First, generate the gaps comparing the achievement differences (`"composite"`) between one race/ethnicity group (in this case `'White'`) and the other five levels of `sdracem`.



```r
levelResults1 <- gap(variable = "composite", data = sdf, groupA = sdracem == "White",
                     groupB = sdracem == "Black")
levelResults2 <- gap(variable = "composite", data = sdf, groupA = sdracem == "White",
                     groupB = sdracem == "Hispanic")
levelResults3 <- gap(variable = "composite", data = sdf, groupA = sdracem == "White",
                     groupB = sdracem == "Asian/Pacific Island")
levelResults4 <- gap(variable = "composite", data = sdf, groupA = sdracem == "White",
                     groupB = sdracem == "Amer Ind/Alaska Natv")
levelResults5 <- gap(variable = "composite", data = sdf, groupA = sdracem == "White",
                     groupB = sdracem == "Other")
```

We'll append these results to a list and use a for-loop to retrieve the `results` `data.frame` from each gap object (`levelResults1` through `levelResults5`). For clarity, we'll also create two new variables showing the comparison levels.


```r
resultsList <- list(levelResults1, levelResults2, levelResults3, levelResults4, levelResults5)

fullResults <- data.frame()
for(i in 1:length(resultsList)) {
  fullResults <- rbind(fullResults, resultsList[[i]]$results)
}
fullResults$levelA <- c("White")
fullResults$levelB <- c("Black", "Hispanic", "Asian/Pacific Island", "Amer Ind/Alaska Natv", "Other")
fullResults
#>   estimateA estimateAse estimateB estimateBse    diffAB
#> 1   287.301   0.7991882  253.4925    1.349386 33.808504
#> 2   287.301   0.7991882  259.8218    1.258471 27.479214
#> 3   287.301   0.7991882  289.8092    3.290948 -2.508196
#> 4   287.301   0.7991882  265.4023    3.630704 21.898677
#> 5   287.301   0.7991882  281.3191    5.154681  5.981855
#>         covAB diffABse diffABpValue    dofAB levelA
#> 1  0.23565724 1.410046 0.000000e+00 40.83522  White
#> 2  0.10045282 1.421811 0.000000e+00 27.01301  White
#> 3  0.57184616 3.213308 4.473733e-01 14.78845  White
#> 4 -0.02820715 3.725201 6.830990e-06 21.70421  White
#> 5 -0.05243699 5.226310 2.615158e-01 29.74570  White
#>                 levelB
#> 1                Black
#> 2             Hispanic
#> 3 Asian/Pacific Island
#> 4 Amer Ind/Alaska Natv
#> 5                Other
```

Once reshaped, the *p*-values in each gap result can be adjusted via `p.adjust()`. The following examples show both the Bonferroni and FDR adjustment methods:


```r
fullResults$diffABpValueBon <- p.adjust(fullResults$diffABpValue, method = "bonferroni")
fullResults$diffABpValueFDR <- p.adjust(fullResults$diffABpValue, method = "BH")
fullResults
#>   estimateA estimateAse estimateB estimateBse    diffAB
#> 1   287.301   0.7991882  253.4925    1.349386 33.808504
#> 2   287.301   0.7991882  259.8218    1.258471 27.479214
#> 3   287.301   0.7991882  289.8092    3.290948 -2.508196
#> 4   287.301   0.7991882  265.4023    3.630704 21.898677
#> 5   287.301   0.7991882  281.3191    5.154681  5.981855
#>         covAB diffABse diffABpValue    dofAB levelA
#> 1  0.23565724 1.410046 0.000000e+00 40.83522  White
#> 2  0.10045282 1.421811 0.000000e+00 27.01301  White
#> 3  0.57184616 3.213308 4.473733e-01 14.78845  White
#> 4 -0.02820715 3.725201 6.830990e-06 21.70421  White
#> 5 -0.05243699 5.226310 2.615158e-01 29.74570  White
#>                 levelB diffABpValueBon diffABpValueFDR
#> 1                Black    0.000000e+00    0.000000e+00
#> 2             Hispanic    0.000000e+00    0.000000e+00
#> 3 Asian/Pacific Island    1.000000e+00    4.473733e-01
#> 4 Amer Ind/Alaska Natv    3.415495e-05    1.138498e-05
#> 5                Other    1.000000e+00    3.268948e-01
```
