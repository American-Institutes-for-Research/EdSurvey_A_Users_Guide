
```
#> Warning: package 'EdSurvey' was built under R version 4.3.1
```

# Data Manipulation in `EdSurvey` and Base R {#dataManipulation}

`EdSurvey` gives users functions to efficiently analyze education survey data. As mentioned in [Chapter 3](#philosophyOfAnalysis), `EdSurvey` is flexible when conducting data manipulation and preparing for survey analysis. It allows for rudimentary data manipulation and analysis with both `EdSurvey` and base R functions to edit data before processing. Also, by calling the function `getData()`, one can extract a `light.edsurvey.data.frame` to manipulate similarly as other `data.frame` objects in other R packages. This concept is further detailed in [Chapter 9](#analysisOutsideEdSurvey)analysisOutsideEdSurvey).

## Subsetting the Data

Analysts can directly use a subset of a dataset with `EdSurvey` functions. In this example, a summary table is created with `edsurveyTable` after filtering the sample to include only those students whose value for the `dsex` variable is male and race (as the variable `sdracem`) is either 1 or 3 (White or Hispanic). Both value levels and labels can be used in `EdSurvey` functions.


```r
sdf <- readNAEP(path = system.file("extdata/data", "M36NT2PM.dat", package = "NAEPprimer"))
sdfm <- subset(x = sdf, subset = dsex == "Male" & (sdracem == 3 | sdracem == 1))
es1 <- edsurveyTable(formula = composite ~ dsex + sdracem, data = sdfm)
```

```r
es1
```


Table: (\#tab:table601)Subsetting Data \label{tab:subsettingData}

|dsex |sdracem  |    N|    WTD_N|      PCT|  SE(PCT)|     MEAN|  SE(MEAN)|
|:----|:--------|----:|--------:|--------:|--------:|--------:|---------:|
|Male |White    | 5160| 5035.169| 76.11329| 1.625174| 287.6603| 0.8995013|
|Male |Hispanic | 1244| 1580.192| 23.88671| 1.625174| 260.8268| 1.5822251|




## Recoding Variable Names and Levels Using `recode.sdf` and `rename.sdf`

To assist in the process of standardizing data for an `edsurvey.data.frame`, a `light.edsurvey.data.frame`, and an `edsurvey.data.frame.list`, the functions `recode.sdf()` and `rename.sdf()` are very handy. 

The `recode.sdf()` function accepts the levels of a variable as a vector from their current values to their newly recoded value. For example, changing the lowest level of `b017451` from `"Never or hardly ever"` to `"Infrequently"` and the highest level from `"Every day"` to `"Frequently"`, will recode levels for that variable in our connection to `sdf`:


```r
sdf2 <- recode.sdf(sdf, recode = list(
  b017451 = list(from = c("Never or hardly ever"),
               to = c("Infrequently")),
  b017451 = list(from = c("Every day"),
               to = c ("Frequently"))
  )
)
searchSDF(string = "b017451", data = sdf2, levels = TRUE)                              
#> Variable: b017451
#> Label: Talk about studies at home
#> Levels (Lowest level first):
#>      2. Once every few weeks
#>      3. About once a week
#>      4. 2 or 3 times a week
#>      8. Omitted
#>      0. Multiple
#>      9. Infrequently
#>      10. Frequently
```

In addition, we can change the name of variables using `rename.sdf()`. The recoded variable `"b017451"` can be changed to a value that more effectively describes its contents, such as `"studytalkfrequency"`:


```r
sdf2 <- rename.sdf(x = sdf2, oldnames = "b017451", newnames = "studytalkfrequency")
searchSDF(string = "studytalkfrequency", data = sdf2, levels = TRUE)
#> Variable: studytalkfrequency
#> Label: Talk about studies at home
#> Levels (Lowest level first):
#>      2. Once every few weeks
#>      3. About once a week
#>      4. 2 or 3 times a week
#>      8. Omitted
#>      0. Multiple
#>      9. Infrequently
#>      10. Frequently
```

Most `EdSurvey` analytical functions allow the user to recode variable levels through the recode argument, including, for example, `cor.sdf()`, `lm.sdf()`, and `edsurveyTable()`. Reference a function's documentation page for details.

It also is important to note that `EdSurvey` functions (and function arguments) do not permanently overwrite the variable information from your data source; they recode it only for the current connection to the data in R. The original file formatting can be retrieved by reconnecting to the data source via `readNAEP()`.


## Retrieving Data for Further Manipulation With `getData`

Data can be extracted and manipulated using the function `getData`. The function `getData` takes an `edsurvey.data.frame` and returns a `light.edsurvey.data.frame` containing the requested variables by either specifying a set of variable names in `varnames` or entering a formula in `formula`.[^helpgetData] For plausible values and weights, only the names of the main scale/subscale and the weight variable need to be included here for all necessary supplementary variables to be automatically included.

To access and manipulate data for the `dsex` and `b017451` variables and the `num_oper` subject scale in `sdf`, call `getData`. In the following code, the `head` function is used, which reveals only the first few rows of the resulting data:


```r
gddat <- getData(data = sdf, varnames = c("dsex","b017451", "num_oper"),
                 dropOmittedLevels = TRUE)
head(gddat)
#>     dsex              b017451 mrps11 mrps12 mrps13 mrps14
#> 1   Male            Every day 321.57 299.37 306.94 310.63
#> 2 Female    About once a week 283.79 273.33 285.96 284.48
#> 3 Female            Every day 334.42 323.01 316.28 361.03
#> 4   Male            Every day 337.25 315.84 316.92 319.00
#> 6 Female Once every few weeks 253.99 248.50 260.63 270.22
#> 7   Male  2 or 3 times a week 313.27 329.85 315.97 313.91
#>   mrps15
#> 1 308.04
#> 2 281.61
#> 3 321.40
#> 4 323.68
#> 6 267.75
#> 7 311.69
```

By default, setting `dropOmittedLevels` to `TRUE` removes special values such as multiple entries or instances of `NA`. `getData` tries to help by dropping the levels of factors for regression, tables, and correlations that are not typically included in analysis.

## Retrieving All Variables in a Dataset {#retrievingAllVariablesInADataset}

To extract all data in an `edsurvey.data.frame`, define the `varnames` argument as `colnames(sdf)`, which will query all variables. Setting the arguments `dropOmittedLevels` and `defaultConditions` to `FALSE` ensures that values that would normally be removed are included:


```r
lsdf0 <- getData(data = sdf, varnames = colnames(sdf), addAttributes = TRUE,
                 dropOmittedLevels = FALSE, defaultConditions = FALSE)
dim(x = lsdf0) # excludes the one school variable in the sdf
dim(x = sdf)
```

Once retrieved, this dataset can be used with all `EdSurvey` functions.

## Using `EdSurvey` Functions on a Unique `light.edsurvey.data.frame`

After manipulating the data, you can use a `light.edsurvey.data.frame` with any `EdSurvey` function. Most notably, a `light.edsurvey.data.frame` can create tables using `edsurveyTable` and run regressions with the `lm.sdf` function.

### `edsurveyTable`
The following example creates an `edsurveyTable` using the manipulated `light.edsurvey.data.frame` (named `gddat`), the variables `dsex` and `b017451`, the five plausible values for `composite`, and the default weight `origwt`:[^qedsurveyTable]

[^qedsurveyTable]: Consult `?edsurveyTable` or the vignette titled [*Using EdSurvey to Analyze NCES Data: An Illustration of Analyzing NAEP Primer*](https://nces.ed.gov/nationsreportcard/subject/researchcenter/pdf/using_edsurvey_for_naep.pdf) for details on default `edsurveyTable` arguments.



```r
gddat <- getData(data = sdf, varnames = c("composite", "dsex", "b017451",
                                          "c052601","origwt"), addAttributes = TRUE)
es2 <- edsurveyTable(formula = composite ~ dsex + b017451,
                     weightVar = "origwt", data = gddat)
```



Table: (\#tab:table602)Using EdSurvey Functions on a light.edsurvey.data.frame \label{tab:lsdf}

|dsex   |b017451              |    N|    WTD_N|      PCT|   SE(PCT)|     MEAN| SE(MEAN)|
|:------|:--------------------|----:|--------:|--------:|---------:|--------:|--------:|
|Male   |Never or hardly ever | 2171| 2276.820| 28.99585| 0.7044670| 270.8526| 1.090086|
|Male   |Once every few weeks | 1489| 1535.884| 19.55985| 0.5538779| 275.6296| 1.357837|
|Male   |About once a week    | 1293| 1339.204| 17.05508| 0.5278360| 281.7165| 1.449683|
|Male   |2 or 3 times a week  | 1424| 1454.934| 18.52893| 0.5158073| 284.7212| 1.661465|
|Male   |Every day            | 1203| 1245.385| 15.86028| 0.5824622| 277.8021| 1.929363|
|Female |Never or hardly ever | 1383| 1425.512| 18.24810| 0.5115641| 266.7741| 1.555760|
|Female |Once every few weeks | 1419| 1454.837| 18.62349| 0.5134568| 271.5970| 1.295964|
|Female |About once a week    | 1379| 1450.724| 18.57084| 0.5789385| 279.3023| 1.660139|
|Female |2 or 3 times a week  | 1697| 1737.825| 22.24604| 0.5070853| 282.8398| 1.459509|
|Female |Every day            | 1686| 1742.940| 22.31153| 0.6531813| 275.7997| 1.321104|



### `lm.sdf`
To generate a linear model using a `light.edsurvey.data.frame`, the included arguments from the previous example, as well as the weight `origwt`, are passed through the `lm.sdf` function:[^qlmsdf]

[^qlmsdf]: Consult `?lm.sdf` or the appendix of the vignette titled *Using EdSurvey to Analyze NCES Data: An Illustration of Analyzing NAEP Primer* for details on default `lm.sdf` arguments.



```r
lm2 <- lm.sdf(formula = composite ~ dsex + b017451, weightVar = "origwt", data = gddat)
summary(object = lm2)
#> 
#> Formula: composite ~ dsex + b017451
#> 
#> Weight variable: 'origwt'
#> Variance method: jackknife
#> JK replicates: 62
#> Plausible values: 5
#> jrrIMax: 1
#> full data n: 17606
#> n used: 15144
#> 
#> Coefficients:
#>                                  coef        se        t
#> (Intercept)                 270.40708   1.05390 256.5768
#> dsexFemale                   -2.92147   0.61554  -4.7462
#> b017451Once every few weeks   4.68200   1.16792   4.0088
#> b017451About once a week     11.57319   1.26477   9.1504
#> b0174512 or 3 times a week   14.88024   1.23890  12.0108
#> b017451Every day              7.93104   1.28155   6.1886
#>                                dof  Pr(>|t|)    
#> (Intercept)                 51.496 < 2.2e-16 ***
#> dsexFemale                  53.963 1.565e-05 ***
#> b017451Once every few weeks 55.188 0.0001848 ***
#> b017451About once a week    49.005 3.519e-12 ***
#> b0174512 or 3 times a week  77.130 < 2.2e-16 ***
#> b017451Every day            50.501 1.074e-07 ***
#> ---
#> Signif. codes:  
#> 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Multiple R-squared: 0.0224
```

Contrasts from treatment groups also can be omitted from a linear model by stating the variable name in the `relevels` argument. In this example, values with `dsex = "Female"` are withheld from the regression. Use the base R function `summary` to view details about the linear model.


```r
lm3 <- lm.sdf(formula = composite ~ dsex + b017451, data = gddat,
              relevels = list(dsex = "Female"))
summary(object = lm3)
#> 
#> Formula: composite ~ dsex + b017451
#> 
#> Weight variable: 'origwt'
#> Variance method: jackknife
#> JK replicates: 62
#> Plausible values: 5
#> jrrIMax: 1
#> full data n: 17606
#> n used: 15144
#> 
#> Coefficients:
#>                                  coef        se        t
#> (Intercept)                 267.48561   1.11204 240.5350
#> dsexMale                      2.92147   0.61554   4.7462
#> b017451Once every few weeks   4.68200   1.16792   4.0088
#> b017451About once a week     11.57319   1.26477   9.1504
#> b0174512 or 3 times a week   14.88024   1.23890  12.0108
#> b017451Every day              7.93104   1.28155   6.1886
#>                                dof  Pr(>|t|)    
#> (Intercept)                 65.757 < 2.2e-16 ***
#> dsexMale                    53.963 1.565e-05 ***
#> b017451Once every few weeks 55.188 0.0001848 ***
#> b017451About once a week    49.005 3.519e-12 ***
#> b0174512 or 3 times a week  77.130 < 2.2e-16 ***
#> b017451Every day            50.501 1.074e-07 ***
#> ---
#> Signif. codes:  
#> 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Multiple R-squared: 0.0224
```

### cor.sdf
Users might want to generate a correlation to explore a manipulated `light.edsurvey.data.frame`. The marginal correlation coefficient among plausible values of the subject scales and subscales can be calculated on a `light.edsurvey.data.frame` object `eddat` using the `cor.sdf` function and the Pearson method. In this example, the variable `dsex == "Female"` subsets our `light.edsurvey.data.frame` to calculate the correlation between the subject subscales `num_oper` and `algebra` using the default weight `origwt`:[^corsdf]

[^corsdf]: Consult `?cor.sdf` or the appendix of the vignette titled *Using EdSurvey to Analyze NCES Data: An Illustration of Analyzing NAEP Primer* for details on default `cor.sdf` arguments.


```r
eddat <- getData(data = sdf, varnames = c("num_oper","algebra","dsex", 'origwt'),
                addAttributes = TRUE, dropOmittedLevels = FALSE)
eddat <- subset(eddat,dsex == "Female")
cor2 <- cor.sdf(x = "num_oper", y = "algebra", weightVar = "origwt",
                data = eddat, method = "Pearson")
cor2
#> Method: Pearson
#> full data n: 17606
#> n used: 8429
#> 
#> Correlation: 0.8917132
#> Standard Error: 0.006153243
#> Confidence Interval: [0.8785106, 0.9035547]
```

## Applying `rebindAttributes` to Use `EdSurvey` Functions With Manipulated Data Frames

A helper function that pairs well with `getData` is `rebindAttributes`. This function allows users to reassign the attributes from a survey dataset to a data frame that might have had its attributes stripped during the manipulation process. Once attributes have been rebinded, all variables---including those outside the original dataset---are available for use in `EdSurvey` analytical functions.

For instance, the `sdf` object contains the following attributes:


```r
attributes(sdf)
#> $names
#>  [1] "userConditions"       "defaultConditions"   
#>  [3] "dataList"             "weights"             
#>  [5] "pvvars"               "subject"             
#>  [7] "year"                 "assessmentCode"      
#>  [9] "dataType"             "gradeLevel"          
#> [11] "achievementLevels"    "omittedLevels"       
#> [13] "survey"               "country"             
#> [15] "psuVar"               "stratumVar"          
#> [17] "jkSumMultiplier"      "recodes"             
#> [19] "dim0"                 "validateFactorLabels"
#> [21] "cacheDataLevelName"   "reqDecimalConversion"
#> [23] "fr2Path"              "dichotParamTab"      
#> [25] "polyParamTab"         "adjustedData"        
#> [27] "testData"             "scoreCard"           
#> [29] "scoreDict"            "scoreFunction"       
#> [31] "cache"               
#> 
#> $class
#> [1] "edsurvey.data.frame" "edsurvey.data"
```

These attributes are lost when variables are retrieved via `getData()`. For example, a user might want to run a linear model using `composite`, the default weight `origwt`, the variable `dsex`, and the categorical variable `b017451` recoded into a binary variable. To do so, we can return a portion of the `sdf` survey data as the `gddat` object. Next, use the base R function `ifelse` to conditionally recode the variable `b017451` by collapsing the levels `"Never or hardly ever"` and `"Once every few weeks"` into one level (`"Rarely"`) and all other levels into `"At least once a week"`.


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

Additional details on the features of the `getData` function appear in the vignette titled [*Using the `getData` Function in EdSurvey*](https://www.air.org/sites/default/files/EdSurvey-getData.pdf).

## Important Data Manipulation Notes

### Memory Usage

Because many NCES databases have hundreds of columns and millions of rows, `EdSurvey` allows users to analyze data without storing it in the global environment. Alternatively, the `getData` function retrieves a `light.edsurvey.data.frame` into the global environment, which can be costlier to memory usage. The base R function `object.size` estimates the memory being used to store an R object. Computations using objects stored in the global environment are markedly costlier to memory than those made directly from the `EdSurvey` database:


```r
object.size(gddat <- getData(data = sdf,
                             varnames = c('composite', 'dsex', 'b017451', 'origwt'),
                             addAttributes = TRUE, dropOmittedLevels = FALSE))
#> 9675824 bytes
object.size(lm7 <- lm.sdf(formula = composite ~ dsex + b017451,
                          weightVar='origwt', data = gddat))
#> 7170632 bytes
object.size(lm8 <- lm.sdf(formula = composite ~ dsex + b017451,
                          weightVar='origwt', data = sdf))
#> 2520832 bytes
```

Although a manipulated `light.edsurvey.data.frame` requires nearly 10 MB of working memory to store both the `light.edsurvey.data.frame` and the regression model object (`lm7`), the resulting object of the same computation made directly from the `EdSurvey` database (`lm8`) holds only 5--7 kB. It is a good practice to remove unnecessary values saved in the global environment. Because we have stored many large data objects, let's remove these before moving on.


```r
rm(df,gddat,eddat)
#> Warning in rm(df, gddat, eddat): object 'df' not found
```

Some operating systems continue to hold the memory usage even after removing an object. R will clean up your global environment automatically, but a forced garbage cleanup also can be employed:


```r
gc()
```

### Forgetting to Include a Column Variable

When creating a summary table or running regression, `EdSurvey` will give a warning when a column is missing:


```r
gddat <- getData(data = sdf, 
                 varnames = c(all.vars(composite ~ lep + dsex + iep), "origwt"), 
                 addAttributes = TRUE, dropOmittedLevels = FALSE)
lm9 <- lm.sdf(formula = composite ~ lep + dsex + iep + b017451, data = gddat)
## Using default weight variable 'origwt'
## Error in getData(sdf, c(all.vars(formula), wgt), ..., includeNaLabel = TRUE)
  ## The following variable names are required for this call 
  ## and are not on the incoming data 'b017451'.
```

The solution is simple: Edit the call to `getData` to include the variable and rerun the linear model.


```r
gddat <- getData(data = sdf,
                 varnames = c(all.vars(composite ~ lep + dsex + iep + b017451),"origwt"), 
                 addAttributes = TRUE, dropOmittedLevels = FALSE)
lm9 <- lm.sdf(formula = composite ~ lep + dsex + iep + b017451, data = gddat)
lm9
#>                 (Intercept)                       lepNo 
#>                  207.356989                   35.278034 
#>                  dsexFemale                       iepNo 
#>                   -5.285498                   36.170641 
#> b017451Once every few weeks    b017451About once a week 
#>                    3.254744                    9.210189 
#>  b0174512 or 3 times a week            b017451Every day 
#>                   12.659496                    6.808825
```
