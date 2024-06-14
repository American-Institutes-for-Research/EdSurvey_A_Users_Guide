# Analysis Outside `EdSurvey` {#analysisOutsideEdSurvey}

`EdSurvey` gives users functions to efficiently analyze education survey data. Although `EdSurvey` allows for rudimentary data manipulation and analysis, this chapter will discuss how to integrate other R packages into `EdSurvey`. As this chapter will demonstrate, this functionality is especially useful for data processing and manipulation in popular R packages such as `dplyr`.

## Integration With Any Other Package

By calling the function `getData()`, one can extract a `light.edsurvey.data.frame`: a `data.frame`-like object containing requested variables, weights, and each weight's associated replicate weights. This `light.edsurvey.data.frame` can be not only manipulated as with other `data.frame` objects but also used with packaged `EdSurvey` functions. As noted in [Chapter 6](#retrievingAllVariablesInADataset), setting the arguments `dropOmittedLevels` and `defaultConditions` to `FALSE` ensures that the values that would normally be removed are included. The argument `addAttributes = TRUE` ensures the extraction of necessary survey design attributes, including the replicate weights, PSU variables, and strata variables.


```r
library(EdSurvey)
#> Loading required package: car
#> Loading required package: carData
#> Loading required package: lfactors
#> lfactors v1.0.4
#> Loading required package: Dire
#> Dire v2.2.0
#> EdSurvey v4.0.4
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
#> Called from: calc.glm.sdf(formula = formula, family = binomial(link = "logit"), 
#>     data = data, weightVar = weightVar, relevels = relevels, 
#>     varMethod = varMethod, jrrIMax = jrrIMax, omittedLevels = omittedLevels, 
#>     defaultConditions = defaultConditions, missingDefaultConditions = missing(defaultConditions), 
#>     recode = recode, returnVarEstInputs = returnVarEstInputs, 
#>     returnNumberOfPSU = returnNumberOfPSU, returnLm0 = FALSE, 
#>     call = call)
#> debug: yvar0 <- yvars[1]
#> debug: if (family$family %in% c("binomial", "quasibinomial")) {
#>     if (any(pvy)) {
#>         for (i in 1:length(yvars)) {
#>             for (yvi in 1:length(pvy)) {
#>                 if (pvy[yvi]) {
#>                   edf[, yvar[yvi]] <- edf[, getPlausibleValue(yvar[yvi], 
#>                     data)[i]]
#>                 }
#>             }
#>             edf[, yvars[i]] <- as.numeric(eval(formula[[2]], 
#>                 edf))
#>         }
#>         oneDef <- max(edf[, yvars], na.rm = TRUE)
#>         for (i in yvars) {
#>             edf[, i] <- ifelse(edf[, i] %in% oneDef, 1, 0)
#>         }
#>         edf$yvar0 <- edf[, yvar0]
#>     }
#>     else {
#>         oneDef <- max(edf[, yvars], na.rm = TRUE)
#>         edf$yvar0 <- ifelse(edf$yvar %in% oneDef, 1, 0)
#>     }
#> }
#> debug: if (any(pvy)) {
#>     for (i in 1:length(yvars)) {
#>         for (yvi in 1:length(pvy)) {
#>             if (pvy[yvi]) {
#>                 edf[, yvar[yvi]] <- edf[, getPlausibleValue(yvar[yvi], 
#>                   data)[i]]
#>             }
#>         }
#>         edf[, yvars[i]] <- as.numeric(eval(formula[[2]], edf))
#>     }
#>     oneDef <- max(edf[, yvars], na.rm = TRUE)
#>     for (i in yvars) {
#>         edf[, i] <- ifelse(edf[, i] %in% oneDef, 1, 0)
#>     }
#>     edf$yvar0 <- edf[, yvar0]
#> } else {
#>     oneDef <- max(edf[, yvars], na.rm = TRUE)
#>     edf$yvar0 <- ifelse(edf$yvar %in% oneDef, 1, 0)
#> }
#> debug: oneDef <- max(edf[, yvars], na.rm = TRUE)
#> debug: edf$yvar0 <- ifelse(edf$yvar %in% oneDef, 1, 0)
#> debug: frm <- update(formula, yvar0 ~ .)
#> debug: edf$w <- edf[, wgt]
#> debug: suppressWarnings(lm00 <- glm2(frm, data = edf, family = family))
#> debug: edf$c2 <- predict(lm00, type = "response")
#> debug: suppressWarnings(lm0 <- glm2(frm, data = edf, weights = w, family = family, 
#>     mustart = c2, epsilon = 1e-14))
#> debug: edf$c2 <- predict(lm0, type = "response")
#> debug: if (returnLm0) {
#>     return(lm0)
#> }
#> debug: wgtl <- getAttributes(data, "weights")[[wgt]]
#> debug: varEstInputs <- list()
#> debug: madeB <- FALSE
#> debug: stat_reg_glm <- function(fam = FALSE) {
#>     ref <- function(pv, wg) {
#>         if (family$family %in% c("binomial", "quasibinomial") & 
#>             (fam)) {
#>             edf$yvar0 <- ifelse(pv %in% oneDef, 1, 0)
#>         }
#>         edf$w <- wg
#>         suppressWarnings(lmi <- glm2(frm, data = edf, weights = w, 
#>             family = family, mustart = c2, epsilon = 1e-14))
#>         return(coef(lmi))
#>     }
#> }
#> debug: if (any(pvy)) {
#>     if (varMethod == "t") {
#>         jrrIMax <- length(yvars)
#>     }
#>     else {
#>         jrrIMax <- min(jrrIMax, length(yvars))
#>     }
#>     varM <- list()
#>     varm <- matrix(NA, nrow = jrrIMax, ncol = length(coef(lm0)))
#>     if (varMethod == "j") {
#>         if (linkingError) {
#>             repWeights <- paste0(wgtl$jkbase, wgtl$jksuffixes)
#>             est <- getLinkingEst(data = edf, pvEst = yvars[grep("_est", 
#>                 yvars)], stat = stat_reg_glm(fam = TRUE), wgt = wgt)
#>             coefm <- est$coef
#>             coef <- apply(coefm, 2, mean)
#>             coefm0 <- t(t(coefm) - coef)
#>             impVar <- getLinkingImpVar(data = edf, pvImp = yvars[grep("_imp", 
#>                 yvars)], ramCols = ncol(getRAM()), stat = stat_reg_glm(fam = TRUE), 
#>                 wgt = wgt, T0 = est$est, T0Centered = FALSE)
#>             sampVar <- getLinkingSampVar(edf, pvSamp = yvars[grep("_samp", 
#>                 yvars)], stat = stat_reg_glm(fam = TRUE), rwgt = repWeights, 
#>                 T0 = est$est, T0Centered = FALSE)
#>             varM[[1]] <- sampVar$Bi
#>             varEstInputs[["JK"]] <- sampVar$veiJK
#>             varEstInputs[["PV"]] <- impVar$veiImp
#>             varm[1, ] <- sampVar$V
#>             M <- length(yvars[grep("_est", yvars)])
#>             Vimp <- impVar$V
#>         }
#>         else {
#>             res <- getEst(data = edf, pvEst = yvars, stat = stat_reg_glm(fam = TRUE), 
#>                 wgt = wgt)
#>             coefm <- res$coef
#>             varEstInputs[["JK"]] <- data.frame()
#>             jkSumMult <- getAttributes(data, "jkSumMultiplier")
#>             for (pvi in 1:jrrIMax) {
#>                 res <- getVarEstJK(stat = stat_reg_glm(fam = FALSE), 
#>                   yvar = edf[, yvars[pvi]], wgtM = edf[, paste0(wgtl$jkbase, 
#>                     wgtl$jksuffixes)], co0 = coefm[pvi, ], jkSumMult = jkSumMult, 
#>                   pvName = pvi)
#>                 varM[[pvi]] <- res$Bi
#>                 varEstInputs[["JK"]] <- rbind(varEstInputs[["JK"]], 
#>                   res$veiJK)
#>                 varm[pvi, ] <- res$VsampInp
#>             }
#>             M <- length(yvars)
#>             coef <- apply(coefm, 2, mean)
#>             coefm0 <- t(t(coefm) - coef)
#>             coefmPVByRow <- lapply(1:ncol(coefm0), function(coli) {
#>                 data.frame(stringsAsFactors = FALSE, PV = 1:nrow(coefm0), 
#>                   variable = rep(names(coef(lm0))[coli], nrow(coefm0)), 
#>                   value = coefm0[, coli])
#>             })
#>             coefmPV <- do.call(rbind, coefmPVByRow)
#>             varEstInputs[["PV"]] <- coefmPV
#>             Vimp <- (M + 1)/M * apply(coefm, 2, var)
#>         }
#>     }
#>     else {
#>         dofNum <- matrix(0, nrow = length(coef(lm0)), ncol = length(yvars))
#>         dofDenom <- matrix(0, nrow = length(coef(lm0)), ncol = length(yvars))
#>         est <- getEst(data = edf, pvEst = yvars, stat = stat_reg_glm(fam = TRUE), 
#>             wgt = wgt)
#>         coefm <- est$coef
#>         for (mm in 1:length(yvars)) {
#>             edf$yvar0 <- as.numeric(edf[, yvars[mm]])
#>             y <- edf[, yvars[mm]]
#>             suppressWarnings(lmi <- glm2(frm, data = edf, weights = w, 
#>                 family = family, mustart = c2, epsilon = 1e-14))
#>             coef <- b <- co0 <- coef(lmi)
#>             D <- vcov(lmi)
#>             eta <- predict(lmi, type = "link")
#>             pred <- predict(lmi, type = "response")
#>             mu.eta <- family$mu.eta(eta)
#>             X <- sparse.model.matrix(frm, edf)
#>             uhij <- (y - pred)/(pred * (1 - pred)) * as.matrix(X) * 
#>                 mu.eta
#>             res <- getVarTaylor(uhij, edf, D, wgt, psuVar, stratumVar)
#>             vc <- D %*% res$vv %*% D
#>             dofNum[, mm] <- res$nums
#>             dofDenom[, mm] <- res$nums2
#>             varM[[mm]] <- as.matrix(vc)
#>             varm[mm, ] <- as.numeric(diag(vc))
#>         }
#>         M <- length(yvars)
#>         coef <- apply(coefm, 2, mean)
#>         coefm0 <- t(t(coefm) - coef)
#>         coefmPVByRow <- lapply(1:ncol(coefm0), function(coli) {
#>             data.frame(stringsAsFactors = FALSE, PV = 1:nrow(coefm0), 
#>                 variable = rep(names(coef(lm0))[coli], nrow(coefm0)), 
#>                 value = coefm0[, coli])
#>         })
#>         coefmPV <- do.call(rbind, coefmPVByRow)
#>         varEstInputs[["PV"]] <- coefmPV
#>         Vimp <- (M + 1)/M * apply(coefm, 2, var)
#>     }
#>     B <- (1/(M - 1)) * Reduce("+", sapply(1:nrow(coefm), function(q) {
#>         outer(coefm0[q, ], coefm0[q, ])
#>     }, simplify = FALSE))
#>     madeB <- TRUE
#>     Ubar <- (1/length(varM)) * Reduce("+", varM)
#>     Vjrr <- apply(varm[1:jrrIMax, , drop = FALSE], 2, mean)
#> } else {
#>     if (varMethod == "j") {
#>         jkSumMult <- getAttributes(data, "jkSumMultiplier")
#>         coef <- coef(lm0)
#>         res <- getVarEstJK(stat = stat_reg_glm(fam = FALSE), 
#>             yvar = edf[, yvars[1]], wgtM = edf[, paste0(wgtl$jkbase, 
#>                 wgtl$jksuffixes)], co0 = coef, jkSumMult = jkSumMult, 
#>             pvName = 1)
#>         Ubar <- res$Bi
#>         Vjrr <- res$VsampInp
#>         varEstInputs[["JK"]] <- res$veiJK
#>     }
#>     else {
#>         X <- sparse.model.matrix(frm, edf)
#>         y <- edf$yvar0
#>         coef <- b <- co0 <- coef(lm0)
#>         D <- vcov(lm0)
#>         eta <- predict(lm0, type = "link")
#>         pred <- predict(lm0, type = "response")
#>         mu.eta <- family$mu.eta(eta)
#>         uhij <- (y - pred)/(pred * (1 - pred)) * as.matrix(X) * 
#>             mu.eta
#>         res <- getVarTaylor(uhij, edf, D, wgt, psuVar, stratumVar)
#>         vc <- D %*% res$vv %*% D
#>         dofNum <- res$nums
#>         dofDenom <- res$nums2
#>         Vjrr <- as.numeric(diag(vc))
#>         Ubar <- as.matrix(vc)
#>     }
#>     M <- 1
#>     Vimp <- 0
#>     varm <- NULL
#>     coefm <- NULL
#>     B <- 0 * Ubar
#> }
#> debug: if (varMethod == "j") {
#>     jkSumMult <- getAttributes(data, "jkSumMultiplier")
#>     coef <- coef(lm0)
#>     res <- getVarEstJK(stat = stat_reg_glm(fam = FALSE), yvar = edf[, 
#>         yvars[1]], wgtM = edf[, paste0(wgtl$jkbase, wgtl$jksuffixes)], 
#>         co0 = coef, jkSumMult = jkSumMult, pvName = 1)
#>     Ubar <- res$Bi
#>     Vjrr <- res$VsampInp
#>     varEstInputs[["JK"]] <- res$veiJK
#> } else {
#>     X <- sparse.model.matrix(frm, edf)
#>     y <- edf$yvar0
#>     coef <- b <- co0 <- coef(lm0)
#>     D <- vcov(lm0)
#>     eta <- predict(lm0, type = "link")
#>     pred <- predict(lm0, type = "response")
#>     mu.eta <- family$mu.eta(eta)
#>     uhij <- (y - pred)/(pred * (1 - pred)) * as.matrix(X) * mu.eta
#>     res <- getVarTaylor(uhij, edf, D, wgt, psuVar, stratumVar)
#>     vc <- D %*% res$vv %*% D
#>     dofNum <- res$nums
#>     dofDenom <- res$nums2
#>     Vjrr <- as.numeric(diag(vc))
#>     Ubar <- as.matrix(vc)
#> }
#> debug: jkSumMult <- getAttributes(data, "jkSumMultiplier")
#> debug: coef <- coef(lm0)
#> debug: res <- getVarEstJK(stat = stat_reg_glm(fam = FALSE), yvar = edf[, 
#>     yvars[1]], wgtM = edf[, paste0(wgtl$jkbase, wgtl$jksuffixes)], 
#>     co0 = coef, jkSumMult = jkSumMult, pvName = 1)
#> debug: Ubar <- res$Bi
#> debug: Vjrr <- res$VsampInp
#> debug: varEstInputs[["JK"]] <- res$veiJK
#> debug: M <- 1
#> debug: Vimp <- 0
#> debug: varm <- NULL
#> debug: coefm <- NULL
#> debug: B <- 0 * Ubar
#> debug: V <- Vjrr + Vimp
#> debug: names(coef) <- names(coef(lm0))
#> debug: se <- sqrt(V)
#> debug: names(se) <- names(coef)
#> debug: X <- model.matrix(frm, edf)
#> debug: fittedLatent <- as.vector(X %*% coef)
#> debug: fitted1 <- family$linkinv(fittedLatent)
#> debug: if (linkingError) {
#>     ye <- grep("_est_", yvars)
#>     Y <- sapply(ye, function(yi) {
#>         as.vector(edf[, yvars[yi]])
#>     }, simplify = TRUE)
#>     resid1 <- Y - fitted1
#>     colnames(resid1) <- yvars[ye]
#> } else {
#>     Y <- sapply(1:length(yvars), function(yi) {
#>         as.vector(edf[, yvars[yi]])
#>     }, simplify = TRUE)
#>     resid1 <- Y - fitted1
#>     colnames(resid1) <- yvars
#> }
#> debug: Y <- sapply(1:length(yvars), function(yi) {
#>     as.vector(edf[, yvars[yi]])
#> }, simplify = TRUE)
#> debug: resid1 <- Y - fitted1
#> debug: colnames(resid1) <- yvars
#> debug: nobs <- nrow(edf)
#> debug: n.ok <- nobs - sum(edf$origwt == 0)
#> debug: nvars <- ncol(X)
#> debug: rank <- rankMatrix(X)
#> debug: resdf <- n.ok - rank
#> debug: df.r <- resdf
#> debug: if (!is.null(coefm)) {
#>     if (!is.matrix(coefm)) {
#>         coefm <- t(as.matrix(coefm))
#>     }
#>     fitted2 <- family$linkinv(as.matrix(X %*% t(coefm)))
#>     resid2 <- Y - fitted2
#> }
#> debug: coefmat <- data.frame(coef = coef, se = se, t = coef/se)
#> debug: if (varMethod == "t") {
#>     m <- length(wgtl$jksuffixes)
#>     if (inherits(dofNum, "matrix")) {
#>         coefmat$dof <- apply((3.16 - 2.77/sqrt(m)) * dofNum^2/dofDenom, 
#>             1, mean)
#>     }
#>     else {
#>         coefmat$dof <- (3.16 - 2.77/sqrt(m)) * dofNum^2/dofDenom
#>     }
#> } else {
#>     coefmat$dof <- sapply(names(coef), function(cn) {
#>         DoFCorrection(varEstA = varEstInputs, varA = cn, method = "JR")
#>     })
#> }
#> debug: coefmat$dof <- sapply(names(coef), function(cn) {
#>     DoFCorrection(varEstA = varEstInputs, varA = cn, method = "JR")
#> })
#> debug: pti <- pt(coefmat$t, df = coefmat$dof)
#> debug: coefmat[, "Pr(>|t|)"] <- 2 * pmin(pti, 1 - pti)
#> debug: njk <- length(wgtl$jksuffixes)
#> debug: if (varMethod == "t") {
#>     njk <- NA
#> }
#> debug: varmeth <- ifelse(varMethod == "t", "Taylor series", "jackknife")
#> debug: res <- list(call = call, formula = formula, family = family, 
#>     coef = coef, se = se, Vimp = Vimp, Vjrr = Vjrr, M = M, varm = varm, 
#>     coefm = coefm, coefmat = coefmat, weight = wgt, npv = length(yvars), 
#>     jrrIMax = min(jrrIMax, length(yvars)), njk = njk, varMethod = varmeth, 
#>     residuals = resid1, fitted.values = fitted1, fittedLatent = fittedLatent, 
#>     residual.df = resdf)
#> debug: if (!is.null(coefm)) {
#>     res <- c(res, list(PV.residuals = resid2, PV.fitted.values = fitted2))
#> }
#> debug: if (returnVarEstInputs) {
#>     res <- c(res, list(varEstInputs = varEstInputs))
#>     if (varMethod == "t") {
#>         warning(paste0("Taylor series method not supported with the ", 
#>             sQuote("varEstInputs"), " argument set to ", dQuote("TRUE"), 
#>             "."))
#>     }
#> }
#> debug: if (madeB) {
#>     tryCatch(rbar <- (1 + 1/M) * (1/nrow(Ubar)) * sum(diag(B %*% 
#>         solve(Ubar))), error = function(e) {
#>         rbar <<- (1 + 1/M) * (1/nrow(Ubar)) * sum(diag(B %*% 
#>             MASS::ginv(Ubar)))
#>         frm <- Formula(frm)
#>         if (terms(frm, lhs = 0, rhs = NULL) == ~1) {
#>             warning("A variance estimate was replaced with NA because there was no variance across strata.", 
#>                 call. = FALSE)
#>         }
#>     })
#>     Ttilde <- (1 + rbar) * Ubar
#>     res <- c(res, list(B = B, U = Ubar, rbar = rbar, Ttilde = Ttilde))
#> } else {
#>     res <- c(res, list(B = B, U = Ubar))
#> }
#> debug: res <- c(res, list(B = B, U = Ubar))
#> debug: if (returnNumberOfPSU) {
#>     stratumVar <- getAttributes(data, "stratumVar")
#>     psuVar <- getAttributes(data, "psuVar")
#>     if ("JK1" %in% stratumVar) {
#>         res <- c(res, list(nPSU = nrow(edf)))
#>     }
#>     else if (all(c(stratumVar, psuVar) %in% colnames(edf))) {
#>         if (sum(is.na(edf[, c(stratumVar, psuVar)])) == 0) {
#>             res <- c(res, list(nPSU = nrow(unique(edf[, c(stratumVar, 
#>                 psuVar)]))))
#>         }
#>         else {
#>             warning("Cannot return number of PSUs because the stratum or PSU variables contain NA values.")
#>         }
#>     }
#> }
#> debug: if (!is.null(stratumVar) && !is.null(psuVar)) {
#>     if (all(c(stratumVar, psuVar) %in% colnames(edf))) {
#>         if (sum(is.na(edf[, c(stratumVar, psuVar)])) == 0) {
#>             res <- c(res, list(waldDenomBaseDof = waldDof(edf, 
#>                 stratumVar, psuVar)))
#>         }
#>     }
#>     if ("JK1" %in% getStratumVar(data)) {
#>         res <- c(res, list(waldDenomBaseDof = "JK1"))
#>     }
#> }
#> debug: if (all(c(stratumVar, psuVar) %in% colnames(edf))) {
#>     if (sum(is.na(edf[, c(stratumVar, psuVar)])) == 0) {
#>         res <- c(res, list(waldDenomBaseDof = waldDof(edf, stratumVar, 
#>             psuVar)))
#>     }
#> }
#> debug: if ("JK1" %in% getStratumVar(data)) {
#>     res <- c(res, list(waldDenomBaseDof = "JK1"))
#> }
#> debug: res <- c(res, list(n0 = nrow2.edsurvey.data.frame(data), nUsed = nrow(edf)))
#> debug: if (inherits(data, "edsurvey.data.frame")) {
#>     res <- c(res, list(data = data))
#> } else {
#>     res <- c(res, list(lm0 = lm0))
#> }
#> debug: res <- c(res, list(lm0 = lm0))
#> debug: class(res) <- "edsurveyGlm"
#> debug: return(res)
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
