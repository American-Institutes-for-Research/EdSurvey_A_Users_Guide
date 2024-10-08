---
title: "Dire"
output: word_document
date: "2023-09-28"
---

# NOTE: This section will be merged into the main Dire Section

## Using the Dire Package for Linked Data

The `Dire` package is particularly valuable when dealing with linking external datasets. If one aims to integrate external data with the LSA and relies on pre-existing PVs, it can introduce biases in the analysis, as the external data information wasn't originally accounted for in the conditioning model.

In most public datasets, such as PISA and TIMSS, the school IDs are obfuscated, with the actual IDs being omitted from the released data. Typically, this information resides in restricted files, accessible only upon approved requests. To demonstrate how to link external data to LSA data, we'll work with a simulated dataset containing school IDs, by using the publicly available Common Core Data (CCD). This will then be merged with the Census dataset. Once these two disparate sources are combined, we will fit a direct estimation model and subsequently derive PVs conditioned on the newly incorporated variables. In this example we will generate 8th grade mathematics assessment and use the NAEP item parameters. 

Here are the main steps:
-	Download the CCD data and select relevant variables.
-	Generate a school dataset incorporating a few specific variables.
-	Produce student variables conditioned on the school dataset.
-	Generate both PSU and statvar variables.
-	Construct JK replicate weights.
-	Create blocks and booklets for student distribution.
-	Generate item responses from students.
-	Download data from the ACS.
-	Link the two datasets together.
-	Fit an MML model using the combined data.
-	Draw PVs based on the model.


For this example we will download 2014-2015 Common Core of Data (CCD) public school information. Please check out the CCD website for more information[https://nces.ed.gov/ccd/](https://nces.ed.gov/ccd/). Initialy we will download directory, membership and geographic location files. 

The first file is the directory file, which has the NCES school IDs, school ZIP codes and state information, this file is called in this example `ccd_dir`. The second file is called `ccd_mem` and it is the Membership flat file. It contains information about the membership of each school, including the number of eighth graders in each school, which we will need to create the school weights. 

The third file provides information about the geographic location of the school, which is called `edge`. 


```r
# Get the CCD links, this data is publicly available
ccd_dir_url <-"https://nces.ed.gov/ccd/data/zip/ccd_sch_029_1415_w_0216601a_txt.zip"
ccd_mem_url <- "https://nces.ed.gov/ccd/data/zip/ccd_sch_052_1415_w_0216161a_txt.zip"
edge_url <- "https://nces.ed.gov/ccd/data/zip/EDGE_GEOIDS_201415_PUBLIC_SCHOOL_csv.zip"

# Download the CCD files
download.file(ccd_dir_url, "~/CCD/ccd_dir.zip")
download.file(ccd_mem_url, "~/CCD/ccd_mem.zip")
download.file(edge_url, "~/CCD/edge.zip")
```


After downloading these zip files, we will unzip and read the files. 


```r
unzip("~/CCD/ccd_dir.zip", exdir = "~/CCD/")
unzip("~/CCD/ccd_mem.zip", exdir = "~/CCD/")
unzip("~/CCD/edge.zip", exdir = "~/CCD/")

ccd_dir <- read.delim('~/CCD/ccd_sch_029_1415_w_0216601a.txt',colClasses = "character")
ccd_mem <- read.delim('~/CCD/ccd_sch_052_1415_w_0216161a.txt',colClasses = "character")
edge <- read.delim('~/CCD/EDGE_GEOIDS_201415_PUBLIC_SCHOOL.csv', sep = ",", colClasses = "character") # Geographical location for utol4 variable
```

In line with the designated sampling frame, special education schools  will be excluded from the 'ccd_dir' dataset. Also schools with different state address on their mailing address than their actual address will be removed to ensure the location information is accurate. Schools without specific grade levels, such as ungraded schools, and vocational schools lacking enrollment will be naturally filtered out in subsequent steps, as they will not possess records for the number of eighth-grade students. However, certain institutions like prison and hospital schools, home-school entities, and juvenile correctional facilities could not be systematically removed due to the absence of specific identifying data in the 2014-15 CCD files. 

After excluding the schools mentioned above, we will merge the directory and membership files and name it as `ccd_dir_mem`.


```r
ccd_dir <- ccd_dir[,c('FIPST','STATENAME','NCESSCH','LSTATE','LZIP','LZIP4',
                     'SCH_TYPE', 'OUT_OF_STATE_FLAG')]

# Filtering out special education schools (according to the sampling frame)
ccd_dir <- ccd_dir[ccd_dir$SCH_TYPE!='2',]

# Filtering out schools
ccd_dir <- ccd_dir[ccd_dir$OUT_OF_STATE_FLAG=='N',]

# Select only required membership variables
ccd_mem <- ccd_mem[,c('FIPST','NCESSCH','STABR','G08','TOTAL')]

# Merge the directory and memory files
ccd_dir_mem <- merge(ccd_dir,ccd_mem,on='NCESSCH')
```

On the next step, we will create the `utol4` and `utol12` variables from the location information in the `edge` dataset. After saving these variables as factors, we merge this data with the merged directory and memory files. Therefore, the final object, `ccdMerged`, will be the merged of these three datafiles downloaded from CCD.


```r
edge <- edge[,c('NCESSCH','LOCALE')]
utol12Lvls <- c("City, large", "City, midsize", "City, small", "Suburb, large", 
                "Suburb, midsize", 
                "Suburb, small", "Town, fringe", "Town, distant", "Town, remote", 
                "Rural, fringe", "Rural, distant", "Rural, remote")

utol4Lvls <- c("City","Suburb","Town","Rural")
utol4Lvls <- rep(utol4Lvls,each =3)

localeLvls <- c(11, 12, 13, 21, 22, 23, 31, 32, 33, 41, 42, 43)

# Convert utol categories into factors
edge$utol12 <- factor(edge$LOCALE, localeLvls, utol12Lvls)
edge$utol4 <- factor(edge$LOCALE, localeLvls, utol4Lvls)

# Merge the manipulated directory, membership and edge files
ccdMerged <- merge(ccd_dir_mem, edge[,c('NCESSCH','utol4','utol12')], by="NCESSCH")
```


In this example we will generate 
After merging the files, we filter out any schools with missing values (-1 or -2 according to the Membership file documentation) for the number of eighth graders.


```r
ccdMerged <- ccdMerged[ccdMerged$LSTATE == ccdMerged$STABR, 
                c('FIPST','NCESSCH','LSTATE','LZIP','G08','TOTAL', 
                  'utol4', 'utol12')]

ccd <- ccdMerged[!(ccdMerged$G08 %in% c('-1','-2', '0', '1', '2')),]

# Convert the number of 8th graders and total number of students variables to numeric
ccd$G08 <- as.numeric(ccd$G08)
ccd$TOTAL <- as.numeric(ccd$TOTAL)
```

Finally, the school file is ready with a few variables, `ccd`, state code (`FIPST`), zip code (`LZIP`), number of 8th graders (`G08`), total number students (`TOTAL`) and location information (`utol4` and `utol12`). Now we will generate the school selection probabilities, `schProb`, and the school weights, `schWeight`, based on the total number of 8th graders in the school and in their corresponding state. Additionally, we will sample up to 30 students from each school if there are enough students and calculate the student selection probability and student weights. Please note that, this sampling scheme we use here very simple and we only consider one factor of many factors for sampling and weighting. 


```r
# Get the state abbreviations in the dataset
states <- names(table(ccd$LSTATE))

# Create an empty variable for school probability
ccd$schProb <- NA

# School probability is the proportion of the number of 8th graders in the school and 
# total 8th graders in the state
for(state in states){
  ccdTmp <- subset(ccd, LSTATE == state)
  ccd[ccd$LSTATE==state,"schProb"] <-  ccdTmp$G08/sum(ccdTmp$G08)
}

# School weight is the inverse probability of school selection
ccd$schWeight <- 1/ccd$schProb

# Sum student weights within state
ccd$selectedNstu <- NA

# If the school has less than 30 8th graders, all students will be included in the sample
for(sch in 1:nrow(ccd)){
  if(ccd$G08[sch] <= 30){
    ccd$selectedNstu[sch] <- ccd$G08[sch]
  } else {
    ccd$selectedNstu[sch] <- 30
  }
}

# Student Selection probability 
ccd$stuProb <- (1/ccd$G08)*(ccd$TOTAL/sum(ccd$G08))
ccd$stuWeight <- 1/ccd$stuProb
```

At this stage we created a dataframe with state information, zip code, location, number of students, student and school weights. Now, we will sample randomly 10 schools from each state.


```r
set.seed(3345) #seed is important to select the same schools each time
selSchools <- vector(mode="character")
for(state in states){
  ccdTmp <- subset(ccd, LSTATE == state)
  # Select schools from the states only with more than 10 schools
  if(nrow(ccdTmp) > 10){
    selSchTmp <- sample(ccd$NCESSCH, size = 10, prob = ccd$schProb, replace=TRUE)
  } 
  selSchools <- c(selSchools, selSchTmp)
}

# Get the Sample school level data
ccdSample <- ccd[ccd$NCESSCH %in% selSchools,]
```

Let's select some of the variables of the dataset to only have the necessary variables.


```r
# School level variables
schoolVars <- c("FIPST", "LZIP", "G08", "TOTAL", "utol12", "schWeight", "stuWeight")
schoolData <- ccdSample[,schoolVars]
```

After getting the school level dataset, we will generate student level information conditioned on the school level data using the conditional distribution of multivariate distribution. 

Given a multivariate normal random vector $X = \begin{bmatrix} X_1 \\ X_2 \end{bmatrix}$, with known distribution parameters: mean vector $\mu = \begin{bmatrix} \mu_1 \\ \mu_2 \end{bmatrix}$ and covariance matrix $\Sigma = \begin{bmatrix} \Sigma_{11} & \Sigma_{12} \\ \Sigma_{21} & \Sigma_{22} \end{bmatrix}$, the conditional distribution of $X_1$ given $X_2 = a$ (a known vector) is also normally distributed with:

\begin{itemize}
    \item Mean: $\bar{\mu} = \mu_1 + \Sigma_{12} \Sigma_{22}^{-1} (a - \mu_2)$
    \item Covariance: $\bar{\Sigma} = \Sigma_{11} - \Sigma_{12} \Sigma_{22}^{-1} \Sigma_{21}$
\end{itemize}

\subsection*{Function \texttt{mubar}}

This function computes the conditional mean $\bar{\mu}$.


```r
mubar <- function(a, m1, sigma12, sigma22, m2){
  return(m1 + sigma12 %*% MASS::ginv(sigma22) %*% t(a - m2)) #is it correct for the generalized inverse
}
```

- `a` The observed value of $X_2$.
- `m1` The mean vector $\mu_1$ of the first variable.
- `sigma12` The cross-covariance matrix $\Sigma_{12}$.
- `sigma22` The covariance matrix $\Sigma_{22}$ of the second variable.
- `m2` The mean vector $\mu_2$ of the second variable.

The `MASS::ginv` function is used for calculating the generalized inverse of $\Sigma_{22}$, allowing the computation to proceed even when $\Sigma_{22}$ is singular or not full rank.

\subsection*{Function \texttt{}}

The other function is `sigmabar`, and it computes the conditional covariance $\bar{\Sigma}$.


```r
sigmabar <- function(sigma11, sigma12, sigma22){
  sigma21 <- t(sigma12)
  return(sigma11 - sigma12 %*% MASS::ginv(sigma22) %*% sigma21)
}
```
- sigma11 The covariance matrix $\Sigma_{11}$ of the first variable.
- sigma12 The cross-covariance matrix $\Sigma_{12}$.
- sigma22 The covariance matrix $\Sigma_{22}$ of the second variable.

Here, $\sigma21$ is the transpose of $\sigma12$ ($\Sigma_{21} = \Sigma_{12}^T$) due to the symmetry of covariance matrices. The generalized inverse of $\Sigma_{22}$ is used similarly as in the `mubar` function.




