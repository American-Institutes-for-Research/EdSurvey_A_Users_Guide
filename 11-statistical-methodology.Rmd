\newcommand{\bm}[1]{\boldsymbol{\mathbf{#1}}}

# Statistical Methods Used in `EdSurvey` {#methods}

## Introduction

This chapter describes estimation procedures for `EdSurvey`. It includes the estimation of means (including regression analysis), percentages, and their degrees of freedom; the estimation of weighted mixed models with plausible values; the multivariate regression method; and the Wald test. The estimation of correlation coefficients appears in a vignette in the `wCorr` package.^[See `vignette("wCorrFormulas",package="wCorr")`]


Which estimation procedure is used for any statistic appears in the Help file for the function that creates the statistic. For example, to find the estimation procedure used for the standard error of the regression coefficients, use `?lm.sdf` to see the manual entry.

This chapter uses many symbols; a table of the symbols follows for reference. Terms used only once are defined immediately before or after equations, so they do not appear in this table.

--------------------------------
 Symbol               Meaning
--------              --------------------------------------------------------------------
$A$                   A random variable

$B$                   Another random variable

$i$                   An index used for observations

$j$                   An index used for jackknife replicates

$J$                   The number of jackknife replicates

$m$                   The number of plausible values

$m^*$                 The number of plausible values used in a calculation

$n$                   The number of units in the sample

$p$                   An index used for plausible values

$w_i$                 The $i$th unit's full sample weight

$x_i$                 The $i$th unit's value for some variable

$\bm{X}$              A matrix of predictor variables in a regression

$\bm{y}$              A vector of predicted variables in a regression

$\bm{\beta}$          The regression coefficients in a regression

$\epsilon$            The residual term in a regression

$\gamma$              The sampling variance multiplier

$\mathcal{A}$         The set of sampled units that is in a population of interest (e.g., Black females)

$\tilde{\mathcal{A}}$ The set of population units that is in a population of interest (e.g., Black females)

$\mathcal{U}$         The set of sampled units that is in a population that contains $\mathcal{A}$ (e.g., Black individuals)

$\tilde{\mathcal{U}}$ The set of population units that is in a population that contains $\mathcal{A}$ (e.g., Black individuals)

--------------------------------

The remainder of this chapter describes estimation procedures used in `EdSurvey`. Sections are organized as follows:

* estimation of means
* estimation of percentages
* the methods for weighted mixed models with plausible values
* the methods for multivariate multiple regression
* the Wald test method

Each section starts by describing estimation of the statistic, followed by estimation procedures of the variances of the statistic. Separate sections address situations where plausible values are present and situations where plausible values are not present. For sections on variance estimation, separate sections address the jackknife or Taylor series variance estimators.

In NAEP surveys where linking error is relevant, an alternative methodology for calculating standard errors is used. This methodology applies only for variables that end in `_linking` for example, `composite_linking`. For the NAEP linking error methods, see the [next chapter]{#linkingerror}. All other methods are detailed in this chapter.

## Estimation of Weighted Means

This section concerns the estimation of means, including regression coefficients and the standard errors of means and regression coefficients.

### Estimation of Weighted Means When Plausible Values Are Not Present

Weighted means are estimated according to
\begin{align}
\mu_x = \frac{\sum_{i=1}^n w_i x_i}{\sum_{i=1}^n w_i}
\end{align}
where $x_i$ and $w_i$ are the outcome and weight, respectively, of the $i$th unit, and $n$ is the total number of units in the sample.

For regressions of the form
\begin{align}
\bm{y}=\bm{X\beta} + \bm{\epsilon}
\end{align}
a weighted regression is used so that the estimated coefficients ($\bm{\beta}$) minimize the weighted square residuals:
\begin{align}
\bm{\beta} = \mathrm{ArgMin}_{\bm{b}} \sum_{i=1}^n w_i (y_i-\bm{X}_i \bm{b})^2
\end{align}
where $\bm{X}_i$ is the $i$th row of $\bm{X}$, and $\mathrm{ArgMin}_{\bm{b}}$ means that the value of $\bm{b}$ minimizes the expression that follows it.


### Estimation of Weighted Means When Plausible Values Are Present

When the variable $x$ has plausible values, these then form the mean estimate ($\mu$) according to
\begin{align}
\mu = \frac{1}{m} \sum_{p=1}^{m} \frac{\sum_{i=1}^n w_i x_{ip}}{\sum_{i=1}^n w_i}
\end{align}
where $x_{ip}$ is the $p$th plausible value for the $i$th unit's outcome, with $m$ plausible values for each unit.

For regressions, the coefficient estimates are simply averaged over the plausible values,
\begin{align}
\bm{\beta} = \frac{1}{m} \sum_{p=1}^{m} \bm{\beta}_p
\end{align}
where $\bm{\beta}_p$ is the vector of estimated regression coefficients, calculated using the $p$th set of plausible values.

### Estimation of Regression Coefficients when Plausible Values are Used as a Predictor

`lm.sdf` accepts subscale or subject scales on the left-hand side of a regression equation, as described above. This section further explains how `lm.sdf` and `glm.sdf` handle plausible values that are on the right hand side of the regression equation. In this section we describe this both when the outcome has plausible values and when it does not.

Let the dependent variable $y$, and $y_{ip}$ the $p$th plausible value for the $i$th unit and there are $m$ plausible values for each unit. Similarly, let the independent variable $x$ to be a scale or subscale and where $x_{ip}$ is the $p$th plausible value for the $i$th unit. The linear regression equation is

\begin{align}
\bm{y} = \beta_0 + \beta_1 \bm{x}  + \epsilon  
\end{align}

where $\beta_0$ is the intercept and $\beta_1$ is the coefficient of $x$, again $y$ and $x$ both have $m$ plausible values. Therefore the regression will be performed for $m$ times as follows

\begin{align}
\begin{split}
\bm{y}_{1} = \beta_{0,1} + \beta_{1,1} \bm{x}_{1}  + \epsilon_1 \\
\bm{y}_{2} = \beta_{0,2} + \beta_{1,2} \bm{x}_{2}  + \epsilon_2 \\
 \vdots \\
\bm{y}_{m} = \beta_{0,m} + \beta_{1,m} \bm{x}_{m}  + \epsilon_{m}
\end{split}
\end{align}

If the dependent variable is not represented with plausible value, then the regression equation is

\begin{align}
\begin{split}
\bm{y} = \beta_{0,1} + \beta_{1,1} \bm{x}_{1}  + \epsilon_1 \\
\bm{y} = \beta_{0,2} + \beta_{1,2} \bm{x}_{2}  + \epsilon_2 \\
 \vdots \\
\bm{y} = \beta_{0,m} + \beta_{1,m} \bm{x}_{m}  + \epsilon_{m}
\end{split}
\end{align}

$y$ is fixed across the regression runs, and the regression coefficients are estimated using the $m$ plausible values of $x$.

This approach is similar to [@weirich2014nested]`s Single+Multiple Imputation (SMI) method, where they produce $m$ number of plausible values instead of $m \times m$ plausible values.

The coefficient estimates are averages over $m$

\begin{align}
\bm{\beta_i} = \frac{1}{m} \sum_{m=1}^{p} \bm{\beta_{i,m}}_{p}
\end{align}

where $\beta_{p}$ is the vector of estimated regression coefficients, calculated using the $p$th set of plausible values.

#### Estimation of the Coefficient of Determination in a Weighted Linear Regression

In regression analysis, statistics such as the coefficient of determination (i.e., $R$-squared) are estimated across all observations. These statistics normalize and average the values across the regression runs (one per set of plausible values). For example,

\begin{align}
R^2 = \left( \tanh \left( \frac{1}{m} \sum_{p=1}^m \left( \text{atanh} \left( \sqrt{R^2_p} \right) \right) \right) \right)^2
\end{align}

where $R^2_p$ is the $R$-squared value for the regression run with the $p$th set of plausible values. This is also the same when there are scales or subscales on both sides of the equation, because the analyses adapts [@weirich2014nested]`s Single+Multiple Imputation (SMI) method as mentioned previously. As a result of this, the method produce $m$ number of $R$-squared values.

For a particular regression, [@Weisberg, Eq. 2.31] defined the $R$-squared as
\begin{align}
R^2 = 1 - \frac{RSS}{SYY}
\end{align}
where $RSS=\bm{e}^T \bm{We}$ [@Weisberg, Eq. 4.2], and $SYY=(\bm{y}-\bar{y})^T \bm{W} (\bm{y}-\bar{y})$; $\bar{y}$ is the weighted mean of the outcome, and $\bm{e} = \bm{y} - \bm{X\beta}$.

### Estimation of Standard Deviations

When the user desires a measure of the dispersion of a variable with plausible values, the weighted variance estimate is calculated according to 
\begin{align}
\hat{s}^2 = \frac{\sum_{i=1}^{n} w_i (x_i - \mu_x)^2}{\sum_{i=1}^{n} w_i}
\end{align}
where $\mu_x$ is the weighted mean. When there are several plausible values, average the variance across the plausible values (calculating $\mu_x$ per plausible value).

The estimate of the standard deviation is the square root of the estimated variance.

### Estimation of Standardized Regression Coefficients

Using the definition of the standardized regression coefficients ($b$),

\begin{align}
b_j = \frac{\tilde{\sigma}_y}{\tilde{\sigma}_{X_j}} \beta_j
\end{align}

where $b_j$ is the standardized regression coefficient associated with the $j$th regressor, $\tilde{\sigma}_y$ is the weighted standard deviation of the outcome variable, and $\tilde{\sigma}_{X_j}$ is the weighted standard deviation of the $j$th regressor.

#### Default Variance Estimation of Standardized Regression Coefficients 

The default standard error of the standardized regression coefficients then treats the standard error estimates as constants, as follows:

\begin{align}
\sigma_{b_j} = \frac{\sigma_y}{\sigma_{X_j}} \sigma_{\beta_j}
\end{align}

#### Sampling Variance Estimation of Standardized Regression Coefficients 

An alternative method estimates the standardized regression coefficients using the same process but estimates their standard error, accounting for the design-based sampling variance.

This method estimates the standardized regression coefficients per plausible value and jackknife replicate. When estimating the standardized regression coefficient for a plausible value, the overall variance of the outcome ($\tilde{\sigma}{y}$) and the regressors ($\tilde{\sigma}_{X_j}$) is used. For a jackknife replicate, the values of $\tilde{\sigma}_y$ and $\tilde{\sigma}_{X_j}$ are updated with the jackknife replicate weights.

Estimating the variance for the standardized regression coefficient proceeds identically to estimating the variance of the regressors, and the weighted standard deviations also are updated with the jackknife replicate weights.

### Estimation of Standard Errors of Weighted Means When Plausible Values Are Not Present, Using the Jackknife Method

When the predicted value does not have plausible values and the requested variance method is jackknife, estimate the variance of the coefficients ($\bm{V}_J$) as follows: 
\begin{align}
\bm{V}_J=\bm{V}_{jrr,0} = \gamma \sum_{j=1}^J (\bm{\beta}_j - \bm{\beta}_0)^2
\end{align} 
where $\gamma$ is a constant equal to one for the jackknife variance estimation method, its inclusion allows us to extend the equations to other variance estimation methods, such as balanced repeated replication [@Wolter] or Fay's method [@judkins]; $\bm{\beta}_j$ is the coefficient estimated with the $j$th jackknife replicate weight; $\bm{\beta}_0$ is the coefficient estimated with the sample weight; and $J$ is the total number of jackknife replicate weights.

The covariance between $\beta_l$ and $\beta_m$ ($C_{J;lm}$) is estimated as
\begin{align}
C_{J;lm}=C_{jrr,0;lm} = \gamma \sum_{j=1}^J (\beta_{j;l} - \beta_{0;l})(\beta_{j;m} - \beta_{0;m})
\end{align}
where subscripts after the semicolon indicate the matrix element (two subscripts) of the covariance matrix ($\bm{C}$) or the vector element (one subscript) for the estimate vector $\bm{\beta}$. The other subscripts are as with the variance estimation.

### Estimation of Standard Errors of Weighted Means When Plausible Values Are Present, Using the Jackknife Method

When the predicted value has plausible values and the requested variance method is jackknife, estimate the
variance ($\bm{V}_{JP}$) as the sum of a variance component from
the plausible values (also called imputation values so that the variance term is called
$\bm{V}_{imp}$) and estimate the sampling variance using plausible values ($\bm{V}_{jrr,P}$) according to the following formula:
\begin{align}
\bm{V}_{JP}=\bm{V}_{imp} + \bm{V}_{jrr,P}
\end{align}

The sampling variance is
\begin{align}
\bm{V}_{jrr,P} = \frac{1}{m^*} \sum_{i=1}^{m^*} \bm{V}_{jrr,p} \ 
\end{align}
In this equation, $m^*$ is a number that can be as small as one or as large as the number of plausible values.[^jrrI] In the previous equation, $\bm{V}_{jrr,P}$ is the average of $\bm{V}_{jrr,p}$ over the plausible values, and the values of $\bm{V}_{jrr,p}$ are calculated in a way analogous to $\bm{V}_{jrr,0}$ in the previous section, except that the $p$th plausible values are used within each step:
\begin{align}
\bm{V}_{jrr,p} = \gamma \sum_{j=1}^{J} (\bm{\beta}_{jp} - \bm{\beta}_{0p})^2
\end{align}

[^jrrI]: This option is included because any value for $m^*$ gives an estimate of $\bm{V}_{jrr}$ with the same properties as larger values of $m^*$ (they are unbiased under the same conditions), but larger values of $m^*$ can take substantially longer to compute. The value of $m^*$ is set with the `jrrIMax` argument; note that `jrrIMax` affects the estimation of only $V_{jrr}$.

The imputation variance is estimated according to @rubin:
\begin{align}
\bm{V}_{imp} = \frac{m+1}{m(m-1)} \sum_{p=1}^m (\bm{\beta}_p - \bm{\beta})^2
\end{align}
where $m$ is the number of plausible values, $\bm{\beta}_p$ is the vector of coefficients calculated with the $p$th set of plausible values, and $\bm{\beta}$ is the estimated coefficient vector averaged over all plausible values.

Covariance terms between $\beta_l$ and $\beta_m$ are estimated according to
\begin{align}
C_{JP;lm}=C_{imp;lm} + C_{jrr,P;lm}
\end{align}
where subscripts after a semicolon indicate the indexes of the covariance term being identified:
\begin{align}
C_{jrr,p;lm} = \gamma \sum_{j=1}^{J} (\beta_{jp;l} - \beta_{0p;l}) (\beta_{jp;m} - \beta_{0p;m})
\end{align}
and
\begin{align}
\bm{C}_{imp;lm} = \frac{m+1}{m(m-1)} \sum_{p=1}^m (\beta_{p;l} - \beta_{l}) (\beta_{p;m} - \beta_{m})
\end{align}
where $\beta_l$ and $\beta_m$ are the estimates averaged across all the plausible values.

### Estimation of Standard Errors of Weighted Means When Plausible Values Are Not Present, Using the Taylor Series Method

When the predicted value does not have plausible values and the requested variance method is the Taylor series, the variance of the coefficients ($\bm{V}_{T}$) is estimated as^[This is a slight generalization of [@binder] to the weighted case, which is derived in more detail and with notation more closely aligned to Binder in the AM manual [@cohen02]].

\begin{align}
\bm{V}_{T}=\bm{V}_{Taylor,0}(\bm{\beta}) = \bm{D}^T \bm{Z D}
\end{align}
$\bm{V}_T$ is a matrix, so the variance estimates are along the diagonal, whereas covariances are the off-diagonal elements. Then $\bm{V}_T$ is estimated by
\begin{align}
\bm{D}= (\bm{X}^T \bm{W X})^{-1}
\end{align}
$\bm{X}$ is the matrix of regressors, the $\bm{W}$ matrix is a diagonal matrix with the $i$th weight in the $i$th diagonal element, 
and

\begin{align}
\bm{Z} = \sum_{j=1}^{J} \frac{n_s}{n_s-1} \sum_{u=1}^{n_s} \bm{z}_{uj} \bm{z}_{uj}^T
\end{align}

where the inner sum is over the sampled PSUs ($u$), of which there are $n_s$, and the outer sum is over all units in the jackknife replicate strata ($j$), of which there are still $J$. Only strata with at least two PSUs that have students are included in the sum; others are simply excluded.^[ This leads to a downward bias in the estimated variance. When the number of units excluded by this rule is proportionally small, the bias also should be proportionally small.] For a mean, $\bm{z}_{uj}$ is a scalar; for a regression, $\bm{z}_{uj}$ is a vector with an entry for each regressor. In what follows, when the estimand is a mean, $\bm{X}$ simply would be a column vector of ones.

Define the estimated residual vector ($\bm{e}$) as
\begin{align}
\bm{e} = \bm{y}-\bm{X\beta}
\end{align}
and define the term
\begin{align}
U_{ik} = e_i X_{ik} w_{i}
\end{align}
where $i$ indexes the matrix row (observation) and $k$ indexes the matrix column (regressor). Then the $k$th entry of $\bm{z}_{uj}$ is given by
\begin{align}
z_{ujk} = \sum_{i\in\mathcal{Q}_{uj}}^{n_s} \left[U_{ik} - \left( \frac{1}{n_s}\sum_{i'\in\mathcal{Q}_{j}}^{n_s} U_{i'k} \right) \right]
\end{align}
where $\mathcal{Q}_{uj}$ is the indices for observations in the $u$th PSU of the $j$th stratum, and  $\mathcal{Q}_{j}$ is the indices for observations in the $j$th stratum (across all PSUs). Thus, when two PSUs are selected per stratum, the value of $\bm{z}$ will be related by $\bm{z}_{1j}= \operatorname{-}\bm{z}_{2j}$.

### Estimation of Standard Errors of Weighted Means When Plausible Values Are Present, Using the Taylor Series Method

When the predicted value has plausible values and the requested variance method is the Taylor series, the variance of the coefficients ($\bm{V}_{TP}$) is estimated as 
\begin{align}
\bm{V}_{TP}=\bm{V}_{Taylor,P}(\bm{\beta}) + \bm{V}_{imp}
\end{align}
where the equation for $\bm{V}_{imp}$ and $\bm{C}_{imp}$ is given in the section on the jackknife variance estimator and where 
$\bm{V}_{Taylor,P}$ is averaged over the plausible values according to
\begin{align}
\bm{V}_{Taylor,P} = \frac{1}{m} \sum_{p=1}^m \bm{V}_{Taylor}(\bm{\beta}_p)
\end{align}
where $\bm{V}_{Taylor}(\bm{\beta}_p)$ is calculated as in the previous section, using the $p$th plausible values to form $\bm{e}$, so that
\begin{align}
\bm{e}=\bm{y}_p - \bm{X\beta}_p
\end{align}
The remainder of the calculation of $U_{ik}$ and $z_{ujk}$ is otherwise identical.

### Estimation of Standard Errors of Differences of Means

Occasionally, two means ($\mu_1$ and $\mu_2$) are calculated for potentially overlapping groups. When this calculation is done, the difference ($\Delta = \mu_1 - \mu_2$) may be of interest. When a covariance term is available, estimate the variance of this difference by using the formula
\begin{align}
\sigma_{\Delta}^2 = \sigma_1^2 + \sigma_2^2 - 2 \sigma_{12}
\end{align}
where $\sigma_{12}$ is the covariance of $\mu_1$ and $\mu_2$.

When no covariance term is available, the approximate equation is used, such that
\begin{align}
\sigma_{\Delta}^2 = \sigma_1^2 + \sigma_2^2 - 2  p \sigma_m^2
\end{align}
where a subscript of $m$ is used to indicate the subset that has more observations, and $p$ is the ratio of the number of observations used in calculating both $\mu_1$ and $\mu_2$ divided by the $n$ size of the larger of the two samples.

When one group is a subset of the other, this is a part-whole comparison. Part-whole comparisons in the NAEP context apply to comparisons between jurisdictions (e.g., a state versus the nation). Please use caution when implementing this method with other types of gap comparisons. 


## Estimation of Weighted Percentages

Percentages estimate the proportion of individuals in a group who have some characteristic (e.g., the percentage of Black students who are female). This often is called a "domain." In the population, the universe is the set $\tilde{\mathcal{U}}$; in the example, $\tilde{\mathcal{U}}$ is Black students who are eligible for sampling. The tilde indicates that this set is in the population.[^pop] The sought-after percentage is then the percentage of individuals in the subset $\tilde{\mathcal{A}} \subseteq \tilde{\mathcal{U}}$. In the example, $\tilde{\mathcal{A}}$ is the set of Black females who are eligible for sampling. The percentage for which an estimate is desired is then 100 times the number of individuals in $\tilde{\mathcal{A}}$ divided by the number of individuals in $\tilde{\mathcal{U}}$. Mathematically,
\begin{align}
\Pi=100 \times \frac{|\tilde{\mathcal{A}}|}{|\tilde{\mathcal{U}|}}
\end{align}
where $|\cdot|$ is the cardinality, or the count of the number of members in a set. In this example, $\tilde{\mathcal{U}}$ was itself a subset of the entire eligible population. In other cases, $\tilde{\mathcal{U}}$ simply could be the population of eligible individuals. Then the value $\Pi$ would represent the percentage of eligible individuals who were Black females.

[^pop]: When the tilde is not present, the set comprises only those individuals in the sample.

The remainder of this section describes statistics meant to estimate $\Pi$ and the variance of those estimates.

### Estimation of Weighted Percentages When Plausible Values Are Not Present

In the sample, units are identified as in $\mathcal{A}$ and $\mathcal{U}$ (where the tilde is dropped to indicate sampled sets) and the estimator is[^abuse]
\begin{align}
\pi=100 \times \frac{\sum_{i \in \mathcal{A}} w_i }{\sum_{i \in \mathcal{U}} w_i }
\end{align}
where $\pi$ is the estimated percentage.

[^abuse]: The notation $i \in \mathcal{A}$ is a bit of an abuse of notation. Strictly speaking, it is the unit in $\mathcal{A}$ and $\mathcal{U}$, not the indices.

Another statistic of interest is the weighted sample size of $\mathcal{A}$, or an estimate of the number of individuals in the population who are members of $\tilde{\mathcal{A}}$. This is calculated with $\sum_{i \in \mathcal{A}} w_i$.


### Estimation of Weighted Percentages When Plausible Values Are Present

If membership in $\mathcal{A}$ or both  $\mathcal{A}$ and $\mathcal{U}$ depends on a measured score being in a range, then the value of $\Pi$ is estimated once for each set of plausible values (indexed by $p$) by
\begin{align}
\pi=100 \times \frac{1}{m} \sum_{p=1}^m \frac{\sum_{i \in \mathcal{A}_p} w_i }{\sum_{i \in \mathcal{U}_p} w_i }
\end{align}
When membership in $\mathcal{U}$ is not associated with the plausible value, $\mathcal{U}_p$ will be the same for all sets of plausible values. The same applies to $\mathcal{A}_p$.

### Estimation of the Standard Error of Weighted Percentages When Plausible Values Are Not Present, Using the Jackknife Method

When membership in $\mathcal{A}$ and $\mathcal{U}$ is not dependent on plausible values and the requested variance method is jackknife, estimate the variance of the percentage ($\bm{V}_{\pi,J}$) as follows:
\begin{align}
\bm{V}_{\pi,J}=100^2 \times \bm{V}_{jrr,f,0}
\end{align}
where the jackknife variance of the fraction is given by
\begin{align}
\bm{V}_{jrr,f,0} = \gamma \sum_{j=1}^J \left( \frac{\sum_{i\in\mathcal{A}} w_{ij} }{\sum_{i\in\mathcal{U}} w_{ij} } -  \frac{\sum_{i\in\mathcal{A}} w_i }{\sum_{i\in\mathcal{U}} w_i } \right)^2
\end{align}
The subscript $j$ indicates that the weights for the $j$th jackknife replicates are being used, and weights that do not contain a second subscript are the student full sample weights.

### Estimation of the Standard Error of Weighted Percentages When Plausible Values Are Present, Using the Jackknife Method

When membership in $\mathcal{A}$ and $\mathcal{U}$ depends on plausible values and the requested variance method is jackknife, estimate the variance of the percentage ($\bm{V}_{\pi,JP}$) as follows:
\begin{align}
\bm{V}_{\pi,TP}=100^2 \times \left( \bm{V}_{jrr,f,P} + \bm{V}_{imp,f}\right)
\end{align}
The only modification to $\bm{V}_{jrr,f}$ to make it $\bm{V}_{jrr,f,P}$ is that the sets $\mathcal{A}$ and $\mathcal{U}$ must be modified to regard one set of plausible values.
\begin{align}
\bm{V}_{jrr,f,P}=\gamma \frac{1}{m^*} \sum_{p=1}^{m^*} \sum_{j=1}^J \left( \frac{\sum_{i\in\mathcal{A}_p} w_{ij} }{\sum_{i\in\mathcal{U}_p} w_{ij} } -  \frac{\sum_{i\in\mathcal{A}_p} w_i }{\sum_{i\in\mathcal{U}_p} w_i } \right)^2
\end{align}
where the subscript $j$ indicates that the weights for the $j$th jackknife replicates are used, weights that do not contain a second subscript are the student full sample weights, and the subscript $p$ indicates the plausible values being used. In some situations, the $\mathcal{A}_p$ will be identical to each other across all plausible values, and the $\mathcal{U}_p$ will be identical to each other in a broader set of situations.

The value of $V_{imp,f}$ is given by
\begin{align}
V_{imp,f}=\frac{m+1}{m(m-1)}\sum_{p=1}^m \left( \frac{\sum_{i \in \mathcal{A}_p} w_i }{\sum_{i \in \mathcal{U}_p} w_i } - \frac{1}{m} \sum_{p'=1}^m \frac{\sum_{i \in \mathcal{A}_{p'}} w_i }{\sum_{i \in \mathcal{U}_{p'}} w_i } \right)^2
\end{align}
so that the second sum is simply the average over all plausible values and represents the estimate itself ($\pi$). Thus, the expression could be rewritten slightly more compactly as follows:
\begin{align}
V_{imp,f}=\frac{m+1}{m(m-1)}\sum_{p=1}^m \left( \frac{\sum_{i \in \mathcal{A}_p} w_i }{\sum_{i \in \mathcal{U}_p} w_i } - \frac{\pi}{100} \right)^2
\end{align}

### Estimation of the Standard Error of Weighted Percentages When Plausible Values Are Not Present, Using the Taylor Series Method

When membership in $\tilde{\mathcal{A}}$ and $\tilde{\mathcal{U}}$ does not depend on plausible values and the requested variance method is the Taylor series, estimate the variance--covariance matrix $\bm{V}_{\pi,JP}$ of the coefficients as follows:
\begin{align}
\bm{V}_{\pi,T}=100^2 \times
\begin{bmatrix}
  \bm{DZD} & -\bm{DZD 1} \\
  -\bm{1}^T \bm{DZD} & \bm{1}^T \bm{DZD 1}
\end{bmatrix}
\end{align}
where the block matrix has elements $DZD \in \mathbb{R}^{(c-1) \times (c-1)}$; the $c$th row and column are then products of $DZD$ and the vector $\bm{1} \in \mathbb{R}^{c-1}$ has a one in every element; the definition of $\bm{D}$ is the inverse of a matrix of derivatives of a score vector taken with respect to $\bm{\pi}$; and $Z$ is a variance estimate of the proportions based on the sample survey. This calculation is based on results derived here, following @binder.

The score function in question is 
\begin{align}
S(\pi_h) = \left( \sum_{i=1}^{n} w_i {\rm 1\kern -2.85 pxI}({\rm unit\ }i{\rm \ is\ in\ class\ }h) \right) - \left(  \sum_{i=1}^{n}  \pi_h w_i \right)
\end{align}
Setting the score function to zero and solving yields the parameter estimator shown in the section "Estimation of Weighted Percentages When Plausible Values Are Present," less the factor of 100 that converts a proportion to a percentage.

For the first $c-1$ elements of $\bm{\pi}$, when solving this function for $\pi_h$, the solution is the estimate of $\pi_h$ shown earlier:
\begin{align}
\pi_h = \frac{\sum_{i=1}^{n} w_i {\rm 1\kern -2.85 pxI}({\rm unit\ }i{\rm \ is\ in\ class\ }h)}{\sum_{i=1}^{n}  w_i}
\end{align}
For $\pi_c$, the definition is that
\begin{align}
\pi_c = 1-\sum_{k=1}^{c-1} \pi_k
\end{align}
and with some algebraic rearrangement, this equation becomes
\begin{align}
=  \frac{\sum_{i=1}^{n} w_i {\rm 1\kern -2.85 pxI}({\rm unit\ }i{\rm \ is\ in\ class\ }c)}{\sum_{i=1}^{n}  w_i}
\end{align}

The value of $D$ is then the derivative of $S(\pi)$ with respect to $\pi$. Because this derivative must be calculated in total equilibrium (so that all the percentages add up to 100), this is done for the first $c-1$ items, and the variance of $\pi_c$ is separately calculated. Taking the derivative of $S(\pi)$ and then inverting it shows that $\bm{D} \in \mathbb{R}^{(c-1) \times (c-1)}$ is a diagonal matrix with entries $\frac{1}{\sum_{i=1}^{n} w_i}$.

Then the $\bm{Z}$ matrix accounts is given by
\begin{align}
\bm{Z}=\sum_{s=1}^{N_s} \frac{n_s}{n_s-1} \sum_{j=1}^{n_s} \bm{U}_{sk}^T \bm{U}_{sk}
\end{align}
where $N_s$ is the number of strata, $n_s$ is the
number of PSUs in a stratum, and
$\bm{U}_{sk}$ is the vector of mean score deviates given by
\begin{align}
\bm{U}_{sk} = \sum_{l=1}^{n_{sk}} \bm{S}_{skl}(\bm{\pi}) - \frac{1}{n_s} \sum_{j=1}^{n_s} \sum_{l=1}^{n_{sj}} \bm{S}_{sjl}(\bm{\pi})
\end{align}
where $n_{sk}$ is the number of observations in PSU $k$ and in stratum $s$, $l$ is an index for individuals within the stratum and PSU, and the score vector is given by
\begin{align}
\bm{S}_{skl}(\bm{\pi}) = w_{skl} \bm{e}_{skl} - w_{skl} \bm{\pi}
\end{align}
where $\bm{e}_{skl}$ is a vector that is 0 in all entries except for a single 1 for the class that the unit is in. For example, if a respondent is a male and the possible levels are ("Female", "Male"), then their level of $\bm{e}_{skl}$ would be $(0,1)^T$.

This gives the covariance matrix for the first $c-1$ elements of the $\bm{\pi}$ vector. Using the usual formula for variance and covariance, it is easy to see that the variance for the final row and column is as shown at the beginning of this section.[^aside]

[^aside]: However, the matrix does not need to be calculated in this fashion. Instead, the final row and column (the covariance terms associated with the value $\pi_c$) do not need to be dropped; simply include them in the formulation of $D$ and $S$, along with every other term.

    Two heuristic arguments are offered for this. First, the variance terms are all exchangeable, so the same formula that applies to the first term applies to the final term under reordering. Thus, any term in the covariance matrix can be found by simply permuting the covariance matrix so that the term is not in the $c$th row or column. As such, the method for calculating the upper left portion of the block matrix clearly applies to the $c$th row and column, which can be calculated directly. Some experiments with NAEP data show that the two methods agree.

    The second heuristic argument is that the values of $\pi_h$ already meet the requirement of summing up to one when the score vector is set equal to zero and solved. This means that the constraint does not need to be imposed a second time.

## Estimation of Degrees of Freedom

This section and the next two subsections describe how to estimate degrees of freedom when a statistic is calculated entirely with one survey. Then a description follows of how to poll degrees of freedom when a statistic is calculated across two cohorts or samples.

One method of estimating the degrees of freedom for education survey results is to find the sum of the number of PSUs (schools) and subtract the number of strata from the number of PSUs. For NAEP surveys, this results in an estimate of 62.

However, many estimates do not use variation across all PSUs, so expect the degrees of freedom to be smaller.

### Estimation of Degrees of Freedom, Using the Jackknife


When the jackknife estimator is used, the Welch-Satterthwaite (WS) degrees of freedom estimate ($dof_{WS}$) is [@Satterthwaite; @Welch] 
\begin{align}
dof_{WS} = \frac{1}{m^*} \sum_{p=1}^{m^*} \frac{ \left[ \sum_{j=1}^{J} \left[ (A_{jp} - A_{0p}) - (B_{jp} - B_{0p}) \right]^2 \right]^2 }{ \sum_{j=1}^{J}  \left[(A_{jp} - A_{0p}) - (B_{jp} - B_{0p}) \right]^4  }
\end{align}
where $A_{jp}$ is the estimate of $A$ using the $j$th jackknife replicate value and the $p$th plausible value, and $A_{0p}$ is the estimate of $A$ using the full sample weights and the $p$th plausible value. The same is true for the $B$ subscripts. For a regression coefficient, $(A_{jp} - A_{0p}) - (B_{jp} - B_{0p})$ is replaced by the $j$th deviate from the full sample weight coefficient $\beta_{jp} - \beta_{0p}$.

The @Johnson corrected degrees of freedom ($dof_{JR}$) is

\begin{align}
dof_{JR} = \left(3.16 - \frac{2.77}{\sqrt{J}} \right) dof_{WS}
\end{align}

### Estimation of Degrees of Freedom, Using the Taylor Series

For the Taylor series estimator, the degrees of freedom estimator also uses the WS degrees of freedom estimate ($dof_{WS}$). However, because the jackknife replicate estimates are not available, a different equation is used. The WS weights require an estimate of the degrees of freedom per group; when using the jackknife variance estimator, this was estimated using the jackknife replicate weights. For the Taylor series, this is estimated per stratum.

Following @binder and @cohen02, the contribution $c_s$ to the degrees of freedom from stratum $s$ is defined as $\bm{z}_{uj}$ from the section "Estimation of Standard Errors of Weighted Means When Plausible Values Are Not Present, Using the Taylor Series Method": 
\begin{align}
c_s = w_s \frac{n_s}{n_s-1} \sum_{u=1}^{n_s} \bm{z}_{uj} \bm{z}_{uj}^T
\end{align}
where $u$ indexes the PSUs in the stratum, of which there are $n_s$, and $w_s$ is the stratum weight, or the sum, in that stratum, of all the unit's full sample weights. The stratum weight is not used in the calculation of estimated degrees of freedom for the jackknife but is applied here to approximately account for the size of the stratum in the degrees of freedom calculation. Using the $c_s$ values, the degrees of freedom is
\begin{align}
dof_{WS} = \frac{\left(\sum c_s \right)^2}{\sum c_s^2}
\end{align}
With multiple plausible values, the average of $dof_{WS}$ across the plausible values is used.

### Estimation of Degrees of Freedom for Statistics Pooled Across Multiple Surveys
When estimating a statistic from two surveys, a different formula is used. In this case, a statistic from each survey is combined into the final estimate; for example, a difference in means would use a mean estimate from each survey. The degrees of freedom for this pooled statistic is
\begin{align}
dof = \frac{\left(s_1^2 + s_2^2 \right)^2}{ \frac{s_1^4}{dof_1} + \frac{s_2^4}{dof_2} }
\end{align}
where $s_1^2$ and $dof_1$ are the squared standard error and degrees of freedom, respectively, of the statistic calculated from the first survey, and $s_2^2$ and $dof_2$ are the squared standard error and degrees of freedom, respectively, of the statistic calculated from the second survey. These intermediate degrees of freedom would be calculated as described in one of the previous two sections.

## Estimation of Weighted Mixed Models

Analysts estimate weighted mixed models, by plausible value, using the `WeMix` package. The results are combined as described in this section.

Estimate the fixed effects from the `WeMix` results by using
\begin{align}
\bm{\beta} = \frac{1}{M} \sum_{p=1}^M \bm{\beta}_p 
\end{align}
where $p$ indexes the plausible values, of which there are $M$. The same formula is used to estimate the variance of the random effects.

### Weighted Mixed Model Variance Estimation
The standard error of the mixed effects is cluster robust and already aggregated to the highest cluster level in the model. We recommend that the highest level align with the sampling design, for example, school in a study that selects schools. Then the cluster robust variance estimator includes the sampling design, and the sampling variance can be estimated by simply averaging it across the plausible values. This is true for both the fixed effects and the variances of the random effects.

The imputation variance is then calculated using Rubin's rule. Only the formula for the fixed effects is shown, but the same rule applies to the estimated variance of the random effects.
\begin{align}
V_{\rm imp} = \frac{M+1}{M(M-1)} \sum_{p=1}^M (\bm{\beta}_p - \bm{\beta}) (\bm{\beta}_p - \bm{\beta})^{\prime}
\end{align}
where $V_{imp}$ is the imputation covariance matrix. The total covariance is the sum of the sampling covariance and the imputation covariance.
\begin{align}
V = V_{\rm imp} + V_{\rm smp}
\end{align}
The variance is the diagonal of the covariance matrix.

## Multivariate Regression

For multivariate regression of the form
$$ \bm{Y}=\bm{XB} + \bm{E}$$

$\bm{Y}$ is a matrix of $n$ observations on $s$ dependent variables; $\bm{X}$ is a matrix with columns for $k$+1 independent variables; $\bm{B}$ is a matrix of regression coefficients, one column for each dependent variable; and $\bm{E}$ is a matrix of errors. A weighted regression is used so that the estimated coefficients ($\bm{\hat{B}}$) minimize the trace of the weighted residual sum of squares and cross-products matrix: 

$$\bm{\hat{B}} = \mathrm{ArgMin}_{\bm{B}}\ \ tr((\bm{Y}-\bm{X} \bm{B})^T \bm{W} (\bm{Y}-\bm{X} \bm{B}))$$

where $\bm{X}_i$ is the $i$th row of $\bm{X}$, $\bm{Y}_i$ is the $i$th row of $\bm{Y}$, $\bm{W}$ is a diagonal matrix of the weights, and $\mathrm{ArgMin}_{\bm{B}}$ means the value of $\bm{B}$ minimizes the expression that follows it.

### Estimation

The methods used to estimate coefficients, variance, and covariance for multivariate multiple regression are similar to those used in univariate multiple regression.

#### Coefficient Estimation

The coefficient estimation in `mvrlm.sdf` produces the same coefficient estimates as when the regressions are run separately using `lm.sdf` as detailed in this chapter.

#### Variance Estimation

The variance estimation in `mvrlm.sdf` produces the same standard error estimates as when the regressions are run separately using `lm.sdf`.

When the predicted value does not have plausible values, the variance of the coefficients is estimated according to the section "Estimation of Standard Errors of Weighted Means When Plausible Values Are Not Present, Using the Jackknife Method."

When plausible values are present, the variance of the coefficients is estimated according to the section "Estimation of Standard Errors of Weighted Means When Plausible Values Are Present, Using the Jackknife Method."

#### Residual Variance--Covariance Matrix Estimation

In addition to estimating the regression coefficients for each dependent variable, the `mvrlm.sdf` model also produces residual covariance estimates for the dependent variables. The residual variance--covariance matrix is a $s \times s$ matrix for a model with $s$ dependent variables that summarizes residuals within and between dependent variables.

The residuals for the $i$th dependent variable are calculated as follows:

$$ \bm{R_i} = \bm{Y_i}-\bm{X}\bm{\hat{\beta}_i} $$

where $\bm{Y_i}$ is the $p \times n$ matrix of plausible values for the $i$th dependent variable, $\bm{X}$ is the $k \times n$ matrix of independent variables, and $\bm{\hat{\beta}_i}$ is the $p \times k$ matrix of estimated coefficients for the $p$ plausible values and the $k$ independent variables. When the $i$th dependent variable has no plausible values, $\bm{R_i}$ is simply the vector of residuals for that variable.

To calculate the residual variance--covariance matrix, summarize residuals across plausible values. For dependent variables with plausible values, the mean residual is taken across the plausible values for each observation, and the residual value is simply taken for dependent variables without plausible values. The residual vector for the $i$th dependent variable is calculated as follows:

$$ E_i = \frac{1}{p} \sum_{a=1}^{p} r_a$$

where $r_a$ is the $a$th column of the matrix of residuals $\bm{R_i}$ for the $i$th dependent variable. When the $i$th dependent variable has no plausible values, $\bm{E_i}$ is simply the vector of residuals for that variable.

The $s \times s$ residual variance--covariance matrix is then calculated from the residual vectors for each dependent variable as follows:

 $$
\begin{bmatrix}
    E^T_{1} E_1 & E^T_{1} E_2 & \dots  & E^T_{1} E_s  \\
    E^T_{2} E_1 & E^T_{2} E_2 & \dots  & E^T_{2} E_s \\
    \vdots & \vdots  & \ddots & \vdots \\
    E^T_{s} E_1 & E^T_{s} E_2  & \dots  &E^T_{s} E_s 
\end{bmatrix}
 $$

#### Coefficient Variance--Covariance Matrix Estimation

Use the `vcov` method to find the coefficient variance--covariance matrix for marginal maximum likelihood models. 

In the univariate case, the coefficient matrix is a $k \times k$ symmetric matrix for a model with $k$ regression coefficients, whereas the variance--covariance matrix for the multivariate case is a $sk \times sk$ symmetric block matrix, where the $k \times k$ blocks on the diagonal represent the variance--covariance values within each dependent variable (these values match those in the variance--covariance matrix from a corresponding univariate model), whereas the $k \times k$ off-diagonal blocks represent the variance--covariance values across dependent variables.
 
$$
\begin{bmatrix}
    \bm{V_1} & \bm{C_{1,2}} & \dots & \bm{C_{1,s}}  \\
    \bm{C_{2,1}} & \bm{V_2} & \dots  & \bm{C_{2,s}} \\
    \vdots & \vdots  & \ddots & \vdots \\
    \bm{C_{s,1}} & \bm{C_{s,2}} & \dots  & \bm{V_s}
\end{bmatrix}
$$

The diagonal blocks $\bm{V_i}$ are $k \times k$ matrices of the following form for the $i$th dependent variable:

$$ V_i = V_{jrr} + V_{imp} $$ 

When the variable does not have plausible values, $V_{imp}$ is 0.

The off-diagonal blocks $C_{a,b}$ are $k \times k$ matrices of the following form for dependent variables $a$ and $b$:

$$ C_{a,b} = C_{jrr} + C_{imp} $$ 
 
When one variable does not have plausible values, $C_{imp}$ is 0.
 

##  Wald Tests

The Wald test is a statistical test of estimated parameters in a model, with the null hypothesis being a set of parameters ($\beta$) is equal to some values ($\beta_0$).^[The Wald test also can test hypotheses about contrasts between parameters, but the `waldTest` function in `EdSurvey` does not support contrasts.] In the default case, where the null hypothesis value of the parameters is 0, if the test does not reject the null hypothesis, removing the variables from the model will not substantially harm the fit of that model.

The formula for the test statistic of a single parameter is as follows:

$$W=\frac{(\hat{\beta} - \beta_0)^2}{Var(\hat{\beta)}}$$

where $W$ is the Wald test statistic, and $Var(\hat{\beta})$ is the variance estimate of $\hat{\beta}$.

The Wald test statistic for multiple parameters is equal to

$$ W =(\bm{R}\hat{\bm{\beta}} - \bm{r})'(\bm{R}\hat{\bm{V}}\bm{R}')^{-1}(\bm{R}\hat{\bm{\beta}} - \bm{r}) $$

where $\bm{R}$ and $\bm{r}$ are a matrix and vector, respectively, used to specify a null hypothesis, and $\hat{\bm{V}}$ is the variance estimator for $\hat{\bm{\beta}}$.

The resulting test statistic can be tested against a chi-square distribution or an F-distribution. The chi-square distribution is preferable to the F-distribution when the number of degrees of freedom is large, whereas the F-test is preferable when the number of degrees of freedom is small [@korng].

For the chi-square test, the degrees of freedom value is equal to the number of parameters being tested, and the test statistic is the unadjusted value of $W$:

$$ W \sim \chi^2(p) $$

For the F-test, two scenarios dictate the use of two different adjustments for the test statistics, along with two different values for the denominator degrees of freedom.

For the NAEP and other international assessments in `EdSurvey`, when collecting data using a multistage stratified sampling design, the test statistic is adjusted based on the sampling parameters:

$$ W_{adj} = (d - p + 1) W / (pd)$$

where $d$ is the number of PSUs minus the number of strata, and $p$ is the number of parameters tested. The adjusted test statistic is then compared with the F-distribution with $p$ and $(d - p - 1)$ degrees of freedom (Korn & Graubard, 1990):

$$ W_{adj} \sim F(p, d - p - 1)$$

When data are collected using a single-stage stratified sampling design (e.g., some countries in the PIAAC data), the test statistic is as follows:

$$ W_{adj} = W / p$$

The adjusted test statistic is then compared with the F-distribution with $p$ and $d$ degrees of freedom, where $d$ is the residual degrees of freedom in the model and $p$ is the number of parameters being tested:

$$ W_{adj} \sim F(p, d)$$
