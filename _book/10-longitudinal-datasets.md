
```
#> Warning: package 'EdSurvey' was built under R version 4.3.1
```

# Longitudinal Datasets

Data from large-scale educational assessment programs require special statistical methods for analysis. Because of their scope and complexity, `EdSurvey` gives users functions to perform analyses that account for complex sample survey designs. This chapter provides some analysis guidelines and tips that apply to most NCES longitudinal data, using the Early Childhood Longitudinal Study, Kindergarten Class of 2010--11 (ECLS-K:2011) as the example data. 

## Using `EdSurvey` to Access ECLS-K:2011 Data for Analysis

Refer to [Chapter 4](#dataAccess) for how to download and read in a specific longitudinal dataset of interest. The following example shows how to download the ECLS-K:2011 Kindergarten--Fifth Grade public-use data file:


```r
downloadECLS_K(years = 2011, root = "C:/", cache=FALSE)
```

To load the ECLS-K:2011 data for fifth graders and create an `edsurvey.data.frame`, select the pathway to the ECLS-K:2011 data folder and assign it the name  `eclsk11` with this call: 




```r
eclsk11 <- readECLS_K2011("C:/ECLS_K/2011")
```

The function may take several minutes to run the first time; subsequent calls to `readECLS_K2011` are stored on the user's drive for easy access and near instant retrieval. Once read in, users can analyze and merge data from the ECLS-K:2011 dataset after loading the data into the R working environment.

## Retrieving Survey Weights

The variables associated with survey weights can be seen from the `showWeights` functions, respectively, when setting the `verbose` argument to `TRUE`.


```r
showWeights(data = eclsk11, verbose = TRUE)
```

In this version, the (lengthy) results are not shown, but the user can easily see the results by running the same code. Selecting the survey weights is especially important for ECLS-K and ECLS-K:2011. Once selected, users can specify the survey weight using the `weightVar` argument in `EdSurvey` analytical functions.

To learn more about selecting sample weights for analyses using ECLS:K-2011 data, consult the **Calculation and Use of Sample Weights** section of the *Public-Use Data File User's Manuals* for the respective public-use file of interest. The [*ECLS-K:2011 Kindergarten--Fifth Grade User's Manual, Public Version*](https://nces.ed.gov/pubs2019/2019051.pdf) is relevant for the K--5 data used in this chapter. Alternative releases are on the NCES site: [*ECLS-K:2011 Public-Use Data File User's Manuals*](https://nces.ed.gov/ecls/dataproducts.asp).

## Retrieving Stratum and PSU Variables  

The functions `getStratumVar` and `getPSUVar` return the default stratum variable name or a PSU variable associated with a weight variable. Because ECLS-K:2011 does not have default weights, users need to specify a weight to return the associated psu/stratum variables. For example, the total student weight from the ninth round `weightVar = "w9c29p_9a0"` returns the following:


```r
getStratumVar(data = eclsk11, weightVar = "w9c29p_9a0")
#> [1] "w9c29p_9astr"
getPSUVar(data = eclsk11, weightVar = "w9c29p_9a0")
#> [1] "w9c29p_9apsu"
```

These arguments are quite useful for accessing the variables associated with the weights in longitudinal surveys.

## Recoding Data

Data recoding is especially important when performing analyses with ECLS:K-2011 data. By default, `EdSurvey` omits special values, such as multiple entries, skipped values, or `NA`s. Typically, this setting helps users by dropping the levels of factors not typically included in regressions, tables, correlations, and other analyses. For ECLS:K-2011, this default setting requires careful consideration. There are many instances in which user should keep special values for their analyses; in these cases, recoding the data is advised.

In ECLS:K-2011, special codes are used to indicate item nonresponse, legitimate skips, and unit nonresponse.


```
#> Warning: package 'kableExtra' was built under R version
#> 4.3.1
```

<table>
<caption>(\#tab:table1001)Missing value codes used in the ECLS-K:2011 data file \label{tab:SOURCE: U.S. Department of Education, National Center for Education Statistics, Early Childhood Longitudinal Study, Kindergarten Class of 2010-11 (ECLS:K-2011), kindergarten-fifth grade (K--5) restricted-use data file.}</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Value </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> -1 </td>
   <td style="text-align:left;"> Not applicable, including legitimate skips </td>
  </tr>
  <tr>
   <td style="text-align:left;"> -2 </td>
   <td style="text-align:left;"> Data suppressed (public-use data file only) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> -4 </td>
   <td style="text-align:left;"> Data suppressed due to administration error </td>
  </tr>
  <tr>
   <td style="text-align:left;"> -5 </td>
   <td style="text-align:left;"> Item not asked in School Administrator Questionnaire Form B </td>
  </tr>
  <tr>
   <td style="text-align:left;"> -7 </td>
   <td style="text-align:left;"> Refused (a type of item nonresponse) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> -8 </td>
   <td style="text-align:left;"> Don't know (a type of item nonresponse) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> -9 </td>
   <td style="text-align:left;"> Not ascertained (a type of item nonresponse) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (blank) </td>
   <td style="text-align:left;"> System missing, including unit nonresponse </td>
  </tr>
</tbody>
</table>


```{=html}
<a href="https://nces.ed.gov/ecls/kindergarten2011.asp">SOURCE: U.S. Department of Education, National Center for Education Statistics, Early Childhood Longitudinal Study, Kindergarten Class of 2010-11 (ECLS:K-2011), kindergarten-fifth grade (K--5) restricted-use data file.</a>
```


The method for recoding these values appears later in this chapter in _Recoding Variables in a Dataset_ in the **Retrieving Data for Further Manipulation With getData** section of this chapter. 

## Removing Special Values

`EdSurvey` uses listwise deletion to remove special values in all analyses by default, such as those detailed in Table 10.1. To use a different method, set `dropOmittedLevels = FALSE` when running your analysis. You can then remove levels that you want to remove with a call to `subset`, as discussed in the "Subsetting the Data" section in [Chapter 3](#subsettingData).


## Explore Variable Distributions With `summary2`

The `summary2` function produces weighted and unweighted descriptive statistics for a variable. This functionality is quite useful for gathering response information for survey variables when conducting data exploration. By default, the estimates are not weighted. For example, the variable `x9povty_i` ("Imputed poverty level") returns the following output: 


```r
summary2(data = eclsk11, variable = "x9povty_i")
#> Estimates are not weighted.
#>                                                                  x9povty_i
#> 1                                               1: BELOW POVERTY THRESHOLD
#> 2 2: AT OR ABOVE POVERTY THRESHOLD, BELOW 200 PERCENT OF POVERTY THRESHOLD
#> 3                          3: AT OR ABOVE 200 PERCENT OF POVERTY THRESHOLD
#> 4                                                                     <NA>
#>      N  Percent
#> 1 2185 12.02267
#> 2 2226 12.24827
#> 3 5809 31.96324
#> 4 7954 43.76582
```

By default, the `summary2` function includes omitted levels; to remove those, set `dropOmittedLevels = TRUE`:


```r
summary2(data = eclsk11, variable = "x9povty_i", dropOmittedLevels = TRUE)
#> Estimates are not weighted.
#>                                                                  x9povty_i
#> 1                                               1: BELOW POVERTY THRESHOLD
#> 2 2: AT OR ABOVE POVERTY THRESHOLD, BELOW 200 PERCENT OF POVERTY THRESHOLD
#> 3                          3: AT OR ABOVE 200 PERCENT OF POVERTY THRESHOLD
#>      N  Percent
#> 1 2185 21.37965
#> 2 2226 21.78082
#> 3 5809 56.83953
```

The `summary2` function returns the weighted number of cases, the weighted percentage, and the weighted standard error for a categorical variable when specified in the argument `weightVar`, here using the total student weight from the 9th round `weightVar = "w9c29p_9a0"`:


```r
summary2(data = eclsk11, variable = "x9povty_i", weightVar = "w9c29p_9a0")
#> Warning in calcEdsurveyTable(formula, data, weightVar,
#> jrrIMax, pctAggregationLevel, : Removing 9632 rows with 0
#> weight from analysis.
#> Estimates are weighted using the weight variable 'w9c29p_9a0'
#>                                                                  x9povty_i
#> 1                                               1: BELOW POVERTY THRESHOLD
#> 2 2: AT OR ABOVE POVERTY THRESHOLD, BELOW 200 PERCENT OF POVERTY THRESHOLD
#> 3                          3: AT OR ABOVE 200 PERCENT OF POVERTY THRESHOLD
#>      N Weighted N Weighted Percent Weighted Percent SE
#> 1 1720     887797         22.28798           0.9054683
#> 2 1823     936566         23.51232           0.6704569
#> 3 4999    2158936         54.19970           1.0531340
```

## Retrieving Data for Further Manipulation With `getData`

### Retrieving a Set of Variables in a Dataset

Although `EdSurvey` allows for rudimentary data manipulation and analysis directly on a `edsurvey.data.frame` connection, the function `getData()` can extract a dataset of variables for manipulation and analyses as with other `data.frame` objects. This object---referred to as a  `light.edsurvey.data.frame`---can then be used with packaged `EdSurvey` analytical functions.

Variables are extracted from an `edsurvey.data.frame` and returned as a `light.edsurvey.data.frame` by specifying a set of variable names in `varnames` or by entering a formula in `formula`.[^helpgetData]

To access and manipulate data the `x_chsex_r` ("Sex of students"), the weight variable `w5cf5pf_50`, `p5sumsch` ("Child attended summer school"), and `p5nhrprm` ("Hours per day child attended summer school") variables in `eclsk11`, call `getData`.


```r
gddat <- getData(data = eclsk11, varnames = c("x_chsex_r", "w5cf5pf_50", "x12sesl",
                                              "p5sumsch", "p5nhrprm"), 
                                 dropOmittedLevels = FALSE, addAttributes = TRUE)
```

By default, setting `dropOmittedLevels` to `TRUE` removes special values, such as multiple entries or `NA`s. `getData` tries to help by dropping the levels of factors for regression, tables, and correlations not typically included in analyses. Here we set `dropOmittedLevels` to `FALSE` to recode special values in an example that follows.

The argument `addAttributes = TRUE` ensures that the analysis functions shown so far can continue to be used with the resulting dataset: `gddat`.

### Retrieving All Variables in a Dataset

To extract all the data in an `edsurvey.data.frame`, define the `varnames` argument as `names(eclsk11)`, which will query all variables. Setting the argument `dropOmittedLevels = FALSE` ensures that values that would normally be removed are included:


```r
lsdf0 <- getData(data = eclsk11, varnames = colnames(eclsk11), addAttributes = TRUE,
                 dropOmittedLevels = FALSE)
dim(x = lsdf0) 
dim(x = eclsk11)
```

Additional details on the features of the `getData` function appear in the vignette titled [*Using the `getData` Function in EdSurvey*](https://www.air.org/sites/default/files/EdSurvey-getData.pdf).

### Recoding Variables in a Dataset {#recodingVariables}

As mentioned earlier, data recoding is of particular importance when performing analyses with ECLS:K-2011 data given the complexity of its survey design on the dataset. `EdSurvey` offers methods of recoding data to fit these needs.

Let's suppose you desire to explore student performance in mathematics based on the number of hours/day a parent reported their child attended summer school (`p5nhrprm`). We'd first need to recode that variable so that students who did not attend summer school (where `p5sumsch` coded as a `2: NO`) are included in the analytic subset with 0 minutes.

The `table` function is a simple method of ascertaining the number of values for each level of a variable in a dataset. Using the table function for the `p5nhrprm` variable indicates that parents reported their child attending summer school anywhere from 2 to 7 hours per day:


```r
table(gddat$p5nhrprm,useNA = "ifany")
#> 
#>     2     3     4     5     6     7  <NA> 
#>    55    72   126    43    87    62 17729
```

To include children who attended summer school for 0 hours per day---those who were skipped by the design of the survey---recode `p5nhrprm` values to zero where `p5sumsch == "2: NO"`:


```r
gddat$p5nhrprm <- ifelse(gddat$p5sumsch == "2: NO", 0, gddat$p5nhrprm)
table(gddat$p5nhrprm,useNA = "ifany")
#> 
#>     0     2     3     4     5     6     7  <NA> 
#>  3913    55    72   126    43    87    62 13816
```

Alternatively, for demonstration purposes, a researcher also may choose to recode the `-1` values for the `p5nhrprm` variable directly:


```r
gddat$p5nhrprm <- ifelse(gddat$p5nhrprm == "-1: NOT APPLICABLE*", 0, gddat$p5nhrprm)
table(gddat$p5nhrprm,useNA = "ifany")
#> 
#>     0     2     3     4     5     6     7  <NA> 
#>  3913    55    72   126    43    87    62 13816
```

A second example of recoding a variable in response to a skip pattern pertains to the frequency that (a) a child does homework (the variable `p9hmwork`) and (b) a parent/someone else helps (the variable `p9hlphwk`). The `levelsSDF` function is useful to show a variable's levels and their unweighted *n* sizes.


```r
levelsSDF("p9hmwork",eclsk11)
#> Levels for Variable 'p9hmwork' (Lowest level first):
#>     1. 1: NEVER (n = 294)
#>     2. 2: LESS THAN ONCE A WEEK (n = 381)
#>     3. 3: 1 TO 2 TIMES A WEEK (n = 1406)
#>     4. 4: 3 TO 4 TIMES A WEEK (n = 4236)
#>     5. 5: 5 OR MORE TIMES A WEEK (n = 3838)
#>     -1. -1: NOT APPLICABLE* (n = 51)
#>     -7. -7: REFUSED* (n = 1)
#>     -8. -8: DON'T KNOW* (n = 13)
#>     -9. -9: NOT ASCERTAINED* (n = 0)
#>     NOTE: * indicates an omitted level.
levelsSDF("p9hlphwk",eclsk11)
#> Levels for Variable 'p9hlphwk' (Lowest level first):
#>     1. 1: NEVER (n = 643)
#>     2. 2: LESS THAN ONCE A WEEK (n = 1786)
#>     3. 3: 1 TO 2 TIMES A WEEK (n = 3774)
#>     4. 4: 3 TO 4 TIMES A WEEK (n = 2558)
#>     5. 5: 5 OR MORE TIMES A WEEK (n = 1094)
#>     -1. -1: NOT APPLICABLE* (n = 359)
#>     -7. -7: REFUSED* (n = 2)
#>     -8. -8: DON'T KNOW* (n = 4)
#>     -9. -9: NOT ASCERTAINED* (n = 0)
#>     NOTE: * indicates an omitted level.
```

The skip pattern for this sequence of survey questions is as follows: If `p9hmwork == "1: NEVER"` then `p9hlphwk` is skipped and coded `"-1: NOT APPLICABLE"`. To include this subset of data in the analysis, the variable `p9hlphwk` can be recoded to `0`. First, retrieve the data via `getData` (along with a few other variables for a subsequent example) to recode using `ifelse`:


```r
mvData <- getData(data = eclsk11, varnames = c("p9hmwork", "p9hlphwk", "x_chsex_r",
                                              "x9rscalk5", "x9mscalk5", "w9c29p_9t90"), 
                                 dropOmittedLevels = FALSE, addAttributes = TRUE)
mvData$p9hlphwk <- ifelse(mvData$p9hmwork == "1: NEVER" &
                          mvData$p9hlphwk == "-1: NOT APPLICABLE", 0,
                          mvData$p9hlphwk)
```

Then use `table` to view the counts of each level.

```r
table(mvData$p9hlphwk,useNA = "ifany")
#> 
#>    0    1    2    3    4    5    6    7    8 <NA> 
#>  294  643 1786 3774 2558 1094   65    2    4 7954
```

Now the `294` cases of the variable `mvData$p9hmwork == "1: NEVER"` are included as a level in our recoded `mvData$p9hlphwk`.


With a few recoding steps, the appropriate value levels can be included in the dataset in preparation for analysis with `EdSurvey`. To find more information about special values specific to ECLS-K:2011, consult the _Missing Values_ section of the [*ECLS-K:2011 Public-Use Data File User's Manual*](https://nces.ed.gov/ecls/dataproducts.asp).


#### Applying `rebindAttributes` to Use `EdSurvey` Functions With Manipulated Data Frames

A helper function that pairs well with `getData` is `rebindAttributes`. This function allows users to reassign the attributes from a survey dataset to a data frame that might have had its attributes stripped during the manipulation process. After rebinding attributes, all variables---including those outside the original dataset---are available for use in `EdSurvey` analytical functions.

The `p9hlphwk` variable from the _Recoding Variables in a Dataset_ section of [this chapter](#recodingVariables) has been recoded using the `ifelse` function; therefore, the following example will display how to apply survey attributes to this object for analysis.

Using the `mvData` object created earlier, apply `rebindAttributes` from the attribute data `eclsk11` to the manipulated data frame `mvData`. The new variables are now available for `EdSurvey` analytical functions:


```r
mvData <- rebindAttributes(data = mvData, attributeData = eclsk11)
lm2 <- lm.sdf(formula = x9rscalk5 ~ x_chsex_r + p9hlphwk, data = mvData,
              weightVar = "w9c29p_9t90")
#> Removing 1422 rows with nonpositive weight from analysis.
summary(object = lm2)
#> 
#> Formula: x9rscalk5 ~ x_chsex_r + p9hlphwk
#> 
#> Weight variable: 'w9c29p_9t90'
#> Variance method: jackknife
#> JK replicates: 80
#> full data n: 18174
#> n used: 7906
#> 
#> Coefficients:
#>                         coef        se        t    dof
#> (Intercept)        142.46410   0.74660 190.8168 67.852
#> x_chsex_r2: FEMALE   1.44536   0.38854   3.7200 46.223
#> p9hlphwk            -2.11562   0.21672  -9.7619 54.904
#>                     Pr(>|t|)    
#> (Intercept)        < 2.2e-16 ***
#> x_chsex_r2: FEMALE 0.0005384 ***
#> p9hlphwk           1.338e-13 ***
#> ---
#> Signif. codes:  
#> 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Multiple R-squared: 0.0284
```

More information on the `rebindAttributes` function is available in [Chapter 9](#analysisOutsideEdSurvey).

## Making a Table With `edsurveyTable`

Summary tables can be created in `EdSurvey` using the `edsurveyTable` function. A call to `edsurveyTable`[^helpedsurveyTable] with two variables, `x_chsex_r` ("Sex of students") and `p9curmar` ("Current marital status"), creates a table that shows the number and percentage of students by gender and their parent's current marital status. Percentages add up to 100 within each gender. 

[^helpedsurveyTable]: Use `?edsurveyTable` for details on default `edsurveyTable` arguments.


```r
es1 <- edsurveyTable(formula = ~ x_chsex_r + p9curmar, data = eclsk11,
                     weightVar = "w9c29p_9t90",
                     varMethod = "jackknife")
#> Warning in calcEdsurveyTable(formula, data, weightVar,
#> jrrIMax, pctAggregationLevel, : Removing 2251 rows with 0
#> weight from analysis.
```

This `edsurveyTable` is saved as the object `es1`, and the resulting table can be displayed by printing the object:

<table>
<caption>(\#tab:table1002)Weighted and Unweighted Sample Size, Percentage
             Distribution, and Standard Error of Percentage Distribution
             of Children by Students' Gender and Their Parents' Marital Status \label{tab:summaryTableECLSK}</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> x_chsex_r </th>
   <th style="text-align:left;"> p9curmar </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:right;"> WTD_N </th>
   <th style="text-align:right;"> PCT </th>
   <th style="text-align:right;"> SE(PCT) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 2938 </td>
   <td style="text-align:right;"> 1367616.83 </td>
   <td style="text-align:right;"> 67.608642 </td>
   <td style="text-align:right;"> 1.1756039 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 151 </td>
   <td style="text-align:right;"> 86412.02 </td>
   <td style="text-align:right;"> 4.271810 </td>
   <td style="text-align:right;"> 0.3944507 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 442 </td>
   <td style="text-align:right;"> 250607.34 </td>
   <td style="text-align:right;"> 12.388866 </td>
   <td style="text-align:right;"> 0.7625198 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 425 </td>
   <td style="text-align:right;"> 273190.02 </td>
   <td style="text-align:right;"> 13.505249 </td>
   <td style="text-align:right;"> 0.9075561 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 81 </td>
   <td style="text-align:right;"> 45017.01 </td>
   <td style="text-align:right;"> 2.225432 </td>
   <td style="text-align:right;"> 0.3368478 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 2870 </td>
   <td style="text-align:right;"> 1319848.64 </td>
   <td style="text-align:right;"> 69.131210 </td>
   <td style="text-align:right;"> 1.0257652 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 143 </td>
   <td style="text-align:right;"> 80672.81 </td>
   <td style="text-align:right;"> 4.225491 </td>
   <td style="text-align:right;"> 0.4357400 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 428 </td>
   <td style="text-align:right;"> 224738.15 </td>
   <td style="text-align:right;"> 11.771365 </td>
   <td style="text-align:right;"> 0.6138104 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 385 </td>
   <td style="text-align:right;"> 237346.10 </td>
   <td style="text-align:right;"> 12.431746 </td>
   <td style="text-align:right;"> 0.7270084 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 82 </td>
   <td style="text-align:right;"> 46587.90 </td>
   <td style="text-align:right;"> 2.440187 </td>
   <td style="text-align:right;"> 0.2406026 </td>
  </tr>
</tbody>
</table>



Given that the previous analysis uses parent data from Round 9, the weight variable `"w9c29p_9a0"` also might be appropriate. Both `"w9c29p_9t90"`  and `"w9c29p_9a0"` could be used for this analysis, although both include nonresponse adjustments for additional data components or rounds of data collection than those of interest in the current analysis. Therefore, analysts need to determine which weight they prefer to use because there is no weight that adjusts for nonresponse for only the sources used in this analysis. Successive analyses in this chapter that mix Round 9 child and parent variables might substitute the selected weight chosen. Note the slight differences in `*n* used` and results. Consult the *4.3.1 Types of Sample Weights* section of the [*ECLS-K:2011 Kindergarten--Fifth Grade User's Manual, Public Version*](https://nces.ed.gov/pubs2019/2019051.pdf) for additional guidance on choosing the most appropriate sample weight for an analysis.



```r
es1p <- edsurveyTable(formula = ~ x_chsex_r + p9curmar, data = eclsk11,
                     weightVar = "w9c29p_9a0",
                     varMethod = "jackknife")
#> Warning in calcEdsurveyTable(formula, data, weightVar,
#> jrrIMax, pctAggregationLevel, : Removing 1673 rows with 0
#> weight from analysis.
```

<table>
<caption>(\#tab:table1003)Weighted and Unweighted Sample Size, Percentage
             Distribution, and Standard Error of Percentage Distribution of
             Children by Students' Gender and Their Parents' Marital Status---Using Parent Weights \label{tab:summaryTableECLSK2}</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> x_chsex_r </th>
   <th style="text-align:left;"> p9curmar </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:right;"> WTD_N </th>
   <th style="text-align:right;"> PCT </th>
   <th style="text-align:right;"> SE(PCT) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 3160 </td>
   <td style="text-align:right;"> 1384646.17 </td>
   <td style="text-align:right;"> 67.662995 </td>
   <td style="text-align:right;"> 1.2201761 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 165 </td>
   <td style="text-align:right;"> 87807.35 </td>
   <td style="text-align:right;"> 4.290850 </td>
   <td style="text-align:right;"> 0.4019977 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 473 </td>
   <td style="text-align:right;"> 257917.26 </td>
   <td style="text-align:right;"> 12.603548 </td>
   <td style="text-align:right;"> 0.7437032 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 465 </td>
   <td style="text-align:right;"> 273250.63 </td>
   <td style="text-align:right;"> 13.352838 </td>
   <td style="text-align:right;"> 0.8934741 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 85 </td>
   <td style="text-align:right;"> 42764.76 </td>
   <td style="text-align:right;"> 2.089770 </td>
   <td style="text-align:right;"> 0.3269484 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 3072 </td>
   <td style="text-align:right;"> 1340918.74 </td>
   <td style="text-align:right;"> 69.585339 </td>
   <td style="text-align:right;"> 0.9959942 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 147 </td>
   <td style="text-align:right;"> 78575.20 </td>
   <td style="text-align:right;"> 4.077564 </td>
   <td style="text-align:right;"> 0.4313110 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 449 </td>
   <td style="text-align:right;"> 223633.62 </td>
   <td style="text-align:right;"> 11.605193 </td>
   <td style="text-align:right;"> 0.5995680 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 417 </td>
   <td style="text-align:right;"> 234899.85 </td>
   <td style="text-align:right;"> 12.189841 </td>
   <td style="text-align:right;"> 0.7083241 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 90 </td>
   <td style="text-align:right;"> 48985.90 </td>
   <td style="text-align:right;"> 2.542063 </td>
   <td style="text-align:right;"> 0.2864988 </td>
  </tr>
</tbody>
</table>



The function also features variance estimation by setting the `varMethod` argument.[^helplmsdf] As shown in the previous example, the default `varMethod = "jackknife"` indicates that the call used the jackknife method for variance estimation. By setting `varMethod = "Taylor"`, the same `edsurveyTable` call in the previous example can return results using Taylor series variance estimation:


```r
es1t <- edsurveyTable(formula = ~ x_chsex_r + p9curmar, data = eclsk11,
                      weightVar = "w9c29p_9t90",
                      varMethod = "Taylor")
#> Warning in calcEdsurveyTable(formula, data, weightVar,
#> jrrIMax, pctAggregationLevel, : Removing 2251 rows with 0
#> weight from analysis.
```
<table>
<caption>(\#tab:table1004)Weighted and Unweighted Sample Size, Percentage Distribution, and Standard Error of Percentage Distribution of Children by Students' Gender and Their Parents' Marital Status---Taylor Series \label{tab:summaryTableECLSK3}</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> x_chsex_r </th>
   <th style="text-align:left;"> p9curmar </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:right;"> WTD_N </th>
   <th style="text-align:right;"> PCT </th>
   <th style="text-align:right;"> SE(PCT) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 2938 </td>
   <td style="text-align:right;"> 1367616.83 </td>
   <td style="text-align:right;"> 67.608642 </td>
   <td style="text-align:right;"> 1.3241743 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 151 </td>
   <td style="text-align:right;"> 86412.02 </td>
   <td style="text-align:right;"> 4.271810 </td>
   <td style="text-align:right;"> 0.4490012 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 442 </td>
   <td style="text-align:right;"> 250607.34 </td>
   <td style="text-align:right;"> 12.388866 </td>
   <td style="text-align:right;"> 0.7819802 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 425 </td>
   <td style="text-align:right;"> 273190.02 </td>
   <td style="text-align:right;"> 13.505249 </td>
   <td style="text-align:right;"> 1.1456202 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 81 </td>
   <td style="text-align:right;"> 45017.01 </td>
   <td style="text-align:right;"> 2.225432 </td>
   <td style="text-align:right;"> 0.3459628 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 2870 </td>
   <td style="text-align:right;"> 1319848.64 </td>
   <td style="text-align:right;"> 69.131210 </td>
   <td style="text-align:right;"> 1.1836404 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 143 </td>
   <td style="text-align:right;"> 80672.81 </td>
   <td style="text-align:right;"> 4.225491 </td>
   <td style="text-align:right;"> 0.4377188 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 428 </td>
   <td style="text-align:right;"> 224738.15 </td>
   <td style="text-align:right;"> 11.771365 </td>
   <td style="text-align:right;"> 0.6806314 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 385 </td>
   <td style="text-align:right;"> 237346.10 </td>
   <td style="text-align:right;"> 12.431746 </td>
   <td style="text-align:right;"> 0.8638412 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 82 </td>
   <td style="text-align:right;"> 46587.90 </td>
   <td style="text-align:right;"> 2.440187 </td>
   <td style="text-align:right;"> 0.3446689 </td>
  </tr>
</tbody>
</table>



[^helplmsdf]: See the documentation for `lm.sdf` for details on the variance calculation.

If the percentages do not add up to 100 at the desired level, adjust the `pctAggregationLevel` argument to change the aggregation level. By default, `pctAggregationLevel = 1`, indicating that the formula will be aggregated at each level of the first variable in the call; in our previous example, this is `x_chsex_r`. Setting `pctAggregationLevel = 0` aggregates at each level of each variable in the call.

The calculation of means and standard errors requires computation time that the user may not want to wait for. If you wish to simply see a table of the levels and the *N* sizes, set the `returnMeans` and `returnSepct` arguments to `FALSE` to omit those columns as follows:


```r
es1b <- edsurveyTable(formula = ~ x_chsex_r + p9curmar, data = eclsk11,
                      weightVar = "w9c29p_9t90", jrrIMax = Inf,
                      returnMeans = FALSE, returnSepct = FALSE)
```

In this `edsurveyTable`, the resulting table can be displayed by printing the object:

<table>
<caption>(\#tab:table1005)Weighted and Unweighted Sample Size and Percentage Distribution of Children by Students' Gender and Their Parents' Marital Status \label{tab:summaryTableECLSK4}</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> x_chsex_r </th>
   <th style="text-align:left;"> p9curmar </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:right;"> WTD_N </th>
   <th style="text-align:right;"> PCT </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 3718 </td>
   <td style="text-align:right;"> 1367616.83 </td>
   <td style="text-align:right;"> 67.608642 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 210 </td>
   <td style="text-align:right;"> 86412.02 </td>
   <td style="text-align:right;"> 4.271810 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 570 </td>
   <td style="text-align:right;"> 250607.34 </td>
   <td style="text-align:right;"> 12.388866 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 599 </td>
   <td style="text-align:right;"> 273190.02 </td>
   <td style="text-align:right;"> 13.505249 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1: MALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 103 </td>
   <td style="text-align:right;"> 45017.01 </td>
   <td style="text-align:right;"> 2.225432 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 1: MARRIED (1) </td>
   <td style="text-align:right;"> 3585 </td>
   <td style="text-align:right;"> 1319848.64 </td>
   <td style="text-align:right;"> 69.131210 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 2: SEPARATED (2) </td>
   <td style="text-align:right;"> 194 </td>
   <td style="text-align:right;"> 80672.81 </td>
   <td style="text-align:right;"> 4.225491 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 3: DIVORCED OR WIDOWED (3, 4) </td>
   <td style="text-align:right;"> 545 </td>
   <td style="text-align:right;"> 224738.15 </td>
   <td style="text-align:right;"> 11.771365 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 4: NEVER MARRIED (5) </td>
   <td style="text-align:right;"> 558 </td>
   <td style="text-align:right;"> 237346.10 </td>
   <td style="text-align:right;"> 12.431746 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2: FEMALE </td>
   <td style="text-align:left;"> 5: CIVIL UNION/DOMESTIC PARTNERSHIP (6) </td>
   <td style="text-align:right;"> 114 </td>
   <td style="text-align:right;"> 46587.90 </td>
   <td style="text-align:right;"> 2.440187 </td>
  </tr>
</tbody>
</table>



For more details on the arguments in the `edsurveyTable` function, look at the examples using `?edsurveyTable`.
