# Installing R and `EdSurvey` and Loading the Package {#installation}

Last edited: February 2022

**Suggested Citation**<br></br>
Lee, M. Installing R and EdSurvey and Loading the Package. In Bailey, P. and Zhang, T. (eds.), _Analyzing NCES Data Using EdSurvey: A User's Guide_.

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
