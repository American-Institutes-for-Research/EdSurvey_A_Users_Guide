# NAEP Linking Error {#linkingerror}

## Introduction

Students who take paper-based assessments (PBAs) and digitally based assessments (DBAs) may experience items in different ways---for example, an item may be more or less difficult in the DBA format than in the PBA format. To account for this, NCES drew two nationally representative samples and administered one as a PBA and the other as a DBA. Because the samples were both nationally representative, the overall mean can be assumed to be equivalent, and the two samples were linked under stochastic equivalence. However, this linking introduced additional variance, and linking error accounts for the additional variance, from the change in modes. The methodology assumes that the mode effect is the same for the entire sample and accounts for the variance introduced resulting from to the change in mode.

`EdSurvey` implements the method, developed by NCES and described in this chapter, to account for linking error in assessments that have combined PBA and DBA formats. As of June 2021, these assessments include 2018 Grade 8 Civics, Geography, and U.S. History; 2019 Science Grade 4 and Grade 8; and 2019 Grade 12 Mathematics and Reading. This method is not relevant to 2017 Grade 4 and Grade 8 Mathematics and Reading. `EdSurvey` implements linking error for these studies, but this process is not described here.

Three groups of plausible values are used to estimate statistics and capture linking error in variance estimation:

* A first group of plausible values is used to estimate the quantity of interest.
* A second group of plausible values is used to estimate sampling variance.
* A third group of plausible values is used to estimate imputation variance.

NCES distributes NAEP data with only the first group of plausible values present, so the second and third groups must be calculated before estimating the linking error variance. All three groups exist for each subject scale (e.g., composite, univariate) and each subscale (when present). Although the user does not work with the theta values directly, the values are used in intermediate steps and appear on the files. The theta scores are available in `EdSurvey`.

This chapter begins by describing how to use `EdSurvey` to calculate the linking error and then describes the formulas used to calculate linking error.

## In EdSurvey

Beginning with `EdSurvey` 2.7, the NAEP linking error formulas have been implemented in most `EdSurvey` analytical functions, including `edsurveyTable`, `achievementLevels`, `percentile`, `gap`, `cor.sdf`, `rq.sdf`, `lm.sdf`, `logit.sdf`, `probit.sdf`, and `waldTest` (when applied to the results of these methods) but not in `summary2`, `mixed.sdf`, `mml.sdf`, or `mvrlm.sdf`. Users of `EdSurvey` can account for the linking error simply by using `_linking` outcomes in place of the subject scale or subscale. They also are listed separately when calling `showPlausibleValues`. For example, a table can be generated with or without linking error as follows.

```r
require(EdSurvey) # must be 2.7.0 or higher
math12 <- readNAEP(path = "path/to/Data/M50NT3AT.dat")
showPlausibleValues(data = math12)
# Results, not accounting for DBA-PBA linking
edsurveyTable(formula = composite ~ dsex, data = math12)
# Results, accounting for DBA-PBA linking
edsurveyTable(formula = composite_linking ~ dsex, data = math12)
```
A few limitations exist for the linking error procedure. First, it does not allow Taylor series variance estimation. Second, the value `jrrIMax` must always be one. Attempting to use `EdSurvey` with Taylor series variance estimation or `jrrIMax` greater than one will result in an error.

Also, because NCES does not provide all the necessary variables (shown in the next section) in the NAEP data, reading in data is slowed by computing the additional intermediate and linking error variables (often taking several minutes), and calculations are slower when the linking error is calculated.

### Formulas
This section shows the formulas used by `EdSurvey` to compute statistics while accounting for linking error.

#### Estimation

A statistic is estimated using the usual scale score plausible values by calculating the statistic with the full sample weights and averaging the statistic across the plausible values.
\begin{equation} 
Q = \frac{\sum_{j=1}^J Q_j}{J}
\end{equation} 
where $Q$ is the estimated statistic; $Q_j$ is the statistic estimated with the $j$th set of plausible values, of which there are $J$; and all estimates are weighted results from the full sample weights (`origwt` on NAEP).

#### Overview of NAEP Linking Error Methodology

For this exercise, we will use the DBA student's theta scores and scale them to the PBA reporting scale with an equation of the form
\begin{equation} 
  X = b + a \theta
\end{equation} 
where $X$ is the scale score, $b$ is the location parameter, $a$ is the scale parameter, and $\theta$ is the theta score. Although it is possible to map scale scores directly from one reporting scale to another, that more complicated procedure is neither described nor needed for this exercise.^[Although `EdSurvey` transforms DBA theta scale plausible values to the PBA reporting scale for linking error estimation, the NAEP data companion describes an equivalent method that maps the DBA reporting scale to the PBA reporting scale instead. As such, the transformation coefficient tables provided in the NAEP data product also reflect the transformation from the DBA reporting scale to the PBA reporting scale. The two methods are equivalent because both would yield identical transformed DBA plausible values (on the PBA reporting scale) as intermediates for subsequent linking error estimation.]

The values $a$ and $b$ are chosen so that students who took the DBA will have their $\theta$ scores mapped to the same mean and standard deviation as students who took the PBA. This scaling is performed by imputation indexing for the imputation variance and by replicate weighting for the sampling variance, as described in the next two subsections.

As is typical with the NAEP, scores are scaled by subscale and then the composite score is a weighted combination of
\begin{equation} 
  X_c = \sum_{k=1}^{K} \beta_k \cdot X_k
\end{equation} 

where $X_c$ is the composite scale score, $\beta_k$ is the weight applied to the $k$th subscale, and $X_k$ is the $k$th subscale scale score. The sum of the $\beta$ values is always one. If there are no subscales, the overall (sometimes also called univariate) score can be used in the following subsections, and the number of subscales is simply one.

Students who took the DBA will have the variable `dbapba` set to `"DBA"`, and students who took the PBA will have the variable set to `"PBA"`.

 
##### Imputation Variance

Ideally, the imputation variance would be summed over all possible combinations of the 20 PBA and 20 DBA imputations, which is far more than can be reasonably calculated. To minimize computation time, only five permutations of the plausible values are chosen; these permutations are shown in Table 12.1, where the row number is the index of the DBA plausible values to use, and the cell value is the index of the PBA plausible values to use.



Table: (\#tab:PERM)Permutation Table \label{tab:PERM}

| Row| Col. 1| Col. 2| Col. 3| Col. 4| Col. 5|
|---:|------:|------:|------:|------:|------:|
|   1|      1|     14|      6|      2|     19|
|   2|      2|     11|      4|     14|     10|
|   3|      3|     18|      3|      7|     13|
|   4|      4|     15|      9|      9|      8|
|   5|      5|     20|     11|     20|     17|
|   6|      6|     17|     10|     13|     12|
|   7|      7|      3|      2|     16|      1|
|   8|      8|     16|     17|      8|     11|
|   9|      9|     12|     19|      4|      5|
|  10|     10|      6|     13|     11|      6|
|  11|     11|     19|      7|     19|     18|
|  12|     12|      2|      8|      1|      9|
|  13|     13|      1|     15|     18|     15|
|  14|     14|     13|     18|     10|      2|
|  15|     15|      5|     20|      6|      3|
|  16|     16|      7|     12|     12|      7|
|  17|     17|      4|      5|     15|     14|
|  18|     18|      9|     16|      3|     20|
|  19|     19|      8|     14|      5|     16|
|  20|     20|     10|      1|     17|      4|



The data already have the plausible values used for estimation on it but need the imputation variance and sampling variance plausible values added.

The algorithm for generating the imputation variance plausible values is as follows:

* Define $w_{DBA}$ as the vector of weights for students who took the DBA. The vector has length $n_{DBA}$. 
* Define $w_{PBA}$ as the vector of weights for students who took the PBA. The vector has length $n_{PBA}$. 
* For each column ($n$) of the permutation table and for each row ($j$) of the permutation table 
    * For each subscale ($k$)
        * Define $X_k$ as the vector of the $k$th subscale, scale score plausible values for all students who took the PBA. Select the plausible value based on the element in Table 1 for this row and column (the $j$, $n$th element from the permutation table).
        * Define $\theta_k$ as the vector of the $k$th subscale, theta score $j$ (the $j$th theta score plausible value) for all students who took the DBA.
        * Define $\mu_t = \frac{\sum w_{DBA} \theta_k}{\sum w_{DBA}}$
        * Define $s_t = \sqrt{ \frac{\sum w_{DBA} (\theta_k - \mu_t)^2}{\sum w_{DBA}}}$
        * Define $\mu_x = \frac{\sum w_{PBA} X_k}{\sum w_{PBA}}$
        * Define $s_x = \sqrt{ \frac{\sum w_{PBA} (X_k - \mu_x)^2}{\sum w_{PBA}}}$
        * Generate a new scale score for the DBA students, centered at the mean for the PBA students using $X_k^\prime = b + a\theta_k$, where $a=\frac{s_x}{s_t}$ and $b=\mu_x - a \mu_t$.
        * The $j$, $n$th imputation variance plausible value for subscale $k$ is $X_k^\prime$ for students who took the DBA and $X_k$ for students who took the PBA.
    * Generate the composite for DBA students using the composite formula $X_c^\prime = \sum_k \beta_k X_k^\prime$.
    * The $j$, $n$th imputation variance plausible value for the composite is $X_c^\prime$ for students who took the DBA and $X_c$ for students who took the PBA.


The previous steps need to be performed only once. Then, for each statistic, the imputation variance is calculated as follows. Using the imputation variance plausible values, the linking imputation variance is then calculated per permutation (column) and then averaged across the permutations.

* For each column ($n$) of the permutation table for each row ($j$) of the permutation table,
    * Calculate the statistic in question using the $j$, $n$th imputation variance plausible values and the full sample weights, call this $Q_{jn}$.
    * Calculate $Q_{\cdot n} = \frac{1}{J} \sum_{j=1}^J Q_{jn}$, where $J$ is the number of permutation table rows.
    * Calculate $V_{imp,n} = \frac{J+1}{J(J-1)} \sum_{j=1}^J \left(Q_{jn}-Q_{\cdot n}\right)^2$.
* Calculate $V_{imp} = \frac{1}{N} \sum_n^N V_{imp,n}$, where $N$ is the number of columns in the permutable table 

The value $V_{imp}$ is the estimated imputation variance for the statistic in question. 

##### Sampling Variance

Then generate the sampling variance plausible values, using only the first plausible value but reweighting using the replicate weights.

* For each subscale ($k$),
    * Define $X_k$ as the vector of the $k$th subscale, scale score plausible value for all students who took the PBA. Select the first plausible value.
    * Define $\theta_k$ as the vector of theta scores for the $k$th subscale for students who took the DBA. Select the first plausible value.
    * For each replicate weight ($i$),
        * Define $w_{DBA}^{(i)}$ as the vector of the $i$th replicate weights for students who took the DBA. The vector has length $n_{DBA}$.
        * Define $w_{PBA}^{(i)}$ as the vector of the $i$th replicate weights for students who took the PBA. The vector has length $n_{PBA}$.
        * Define $\mu_t^{(i)} = \frac{\sum w_{DBA}^{(i)} \theta_k}{\sum w_{DBA}^{(i)}}$
        * Define $s_t^{(i)} = \sqrt{ \frac{\sum w_{DBA}^{(i)} (\theta_k - \mu_t^{(i)})^2}{\sum w_{DBA}^{(i)}}}$
        * Define $\mu_x^{(i)} = \frac{\sum w_{PBA}^{(i)} X_k}{\sum w_{PBA}^{(i)}}$
        * Define $s_x^{(i)} = \sqrt{ \frac{\sum w_{PBA}^{(i)} (X_k - \mu_x^{(i)})^2}{\sum w_{PBA}^{(i)}}}$
        * Generate a new scale score for the DBA students, centered at the mean for the PBA students using $X_k^{\prime(i)} = b^{(i)} + a^{(i)}\theta_k$, where $a^{(i)}=\frac{s_x^{(i)}}{s_t^{(i)}}$ and $b^{(i)}=\mu_x^{(i)} - a^{(i)} \mu_t^{(i)}$.
        * The $i$th sampling variance plausible value is then $X_k^{\prime(i)}$ for students who took the DBA and $X_k$ for students who took the PBA.

As previously, these steps need to be performed only once. Then for each statistic, the sampling variance is calculated as follows. Using the sampling variance plausible values, the linking sampling variance is then calculated per replicate weight and summed.

* For each replicate weight ($i$), calculate $Q_{i}$ as the statistic in question using the $i$th sampling variance plausible value and the $i$th replicate weight.
* Calculate the mean $Q_{\cdot}= \frac{1}{I} \sum_{i=1}^I Q_i$, where $I$ is the number of replicate weights.
* Calculate $V_{samp} = \sum_{i=1}^I \left(Q_i - Q_{\cdot}\right)^2$.

The value $V_{samp}$ is the estimated sampling variance for the statistic in question.

