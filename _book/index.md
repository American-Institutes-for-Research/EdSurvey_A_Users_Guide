--- 
title: " Analyzing NCES Data Using EdSurvey: A User's Guide"
author: EdSurvey Team\footnote{NCES 2021-044}
date: "2023-07-24"
site: bookdown::bookdown_site
description: |
  | The EdSurvey R package brings together the ability to download, extract data from, and analyze with common procedures all the methodologies that a researcher needs to analyze NCES survey data. Analyzing NCES Data Using EdSurvey\\: A User’s Guide is an e-book that provides guidance for how to use the `EdSurvey` R package to analyze NCES data.
  | This book covers analysis of data with complex sampling, plausible values, and longitudinal data methodologies inherent to NCES educational databases complete with examples in `EdSurvey`. Comprehensive examples walk readers through how to use many analysis types\\: from data access, processing, and manipulation to statistical analyses, including cross tabulation, gap analysis, correlation, regressions, and multilevel mixed models. Statistical methodologies for EdSurvey appear in Chapters 11 and 12.
  | The book has two formats: a web-based version, which is accessible through a web browser such as Edge or   Chrome, and an epub version for easy access on smart devices such as smartphones and tablets.

documentclass: book
bibliography: [biblio.bib]
csl: apa-annotated-bibliography.csl
pandoc_args: ["--csl", "apa-annotated-bibliography.csl"]
link-citations: yes
always_allow_html: true
url: https://github.com/American-Institutes-for-Research/EdSurvey_A_Users_Guide
cover-image: "images/cover.png"
apple-touch-icon: "touch-icon.png"
apple-touch-icon-size: 120
favicon: "favicon.ico"
---

# Analyzing NCES Data Using EdSurvey: A User's Guide  {.unnumbered}

<img src="images/cover.png" width="70%" style="display: block; margin: auto;" />

## Learning to Use `EdSurvey`

This user’s guide is intended for skipping around; the information is not ordered sequentially. To find help and see examples for a specific function, the question mark function allows users to get help about a function. For example, at the R prompt, after installing and loading `EdSurvey`, a user can get help about the downloadTIMSS function by typing ?downloadTIMSS.

### Available Resources

Visit the [`EdSurvey` page](https://www.air.org/project/nces-data-r-project-edsurvey) at [AIR.org](https://www.air.org/) for a full listing of `EdSurvey` resources.

###	Trainings

The `EdSurvey` development team provides periodic workshops on the analysis of national and international education data. To learn more about these course offerings,

-  apply to the [NAEP Data Training Workshop](http://naep-research.airprojects.org/Opportunities/Training)
- explore the available courses at the [American Educational Research Association](https://www.aera.net/) and [IEA International Research Conference](https://www.iea.nl/news-events/irc) sites

###	Contact and Bug Report

Please report bugs and other issues on our GitHub repository at [https://github.com/American-Institutes-for-Research/EdSurvey/issues](https://github.com/American-Institutes-for-Research/EdSurvey/issues).

# Cover Page {.unnumbered}

## Analyzing NCES Data Using EdSurvey: A User's Guide {.unnumbered}

**July 2023**

**Michael Lee**<br></br>
**Ting Zhang**<br></br>
**Paul Bailey**<br></br>
**Eric Buehler**<br></br>
**Thomas Fink**<br></br>
**Huade Huo**<br></br>
**Sun-Joo Lee**<br></br>
**Yuqi Liao**<br></br>
American Institutes for Research

**Emmanuel Sikali**<br></br>
Senior Research Scientist<br></br>
National Center for Education Statistics

**U.S. DEPARTMENT OF EDUCATION**

_The content of this user’s guide was commissioned by the National Center for Education Statistics (NCES) and conducted by the American Institutes for Research (AIR) under Education Statistics Services Institute Network (ESSIN) Task Order 14: Assessment Division Support (Contract No. ED-IES-12-D-0002/0004). Task Order 14 supports NCES with expert advice and technical assistance on issues related to the National Assessment of Educational Progress (NAEP)._

_The authors are responsible for the contents of this guide, which is still under development. If you have any feedback, corrections, or suggestions for improvements to subsequent versions, please contact us at [https://github.com/American-Institutes-for-Research/EdSurvey/issues](https://github.com/American-Institutes-for-Research/EdSurvey/issues). Mention of trade names, commercial products, or organizations does not imply endorsement by the U.S. Government._

# Preface {.unnumbered}

_Analyzing NCES Data Using `EdSurvey`: A User's Guide_ is the first introductory manual dedicated to introducing this R package to the education research community. Until now, most of the instruction has occurred at national and international conferences and in scientific journals. `EdSurvey` was introduced to the research community during the American Education Research Association (AERA) annual conference in Washington, D.C., in April 2016. The first version was optimized to analyze only NAEP data. Since then, significant development has continued at a steady pace. This manual is based on the 4.0.1. As the user downloads this package on the Comprehensive R Archive Network (CRAN), he or she might discover features not presented or discussed in this manual. The development team strongly suggests using the vignettes that are regularly published with the addition of each new feature.

The team also understands that programming might be intimidating to some education researchers. To lower the entry level of programming skills, this user’s guide provides comprehensive examples that are easy to follow and adaptable to many research questions and investigations. The team assumes that users of this manual have some basic understanding and knowledge of programming and R software. Experienced R users might find themselves equipped to jump to a specific section of interest. For those who do not have such knowledge yet, many courses are available in the public domain that will suffice for acquiring this prerequisite knowledge.

## Rationale for `EdSurvey`

`EdSurvey` was conceived to streamline access and analyses of NCES data by taking advantage of advances in computing and meeting the shifting trend in higher education to move away from using commercial statistical software packages in favor of open-source software packages, such as R, Python, and Julia. Starting in the late 1980s, NCES conceived and developed an approach to make its data available to the research community. Under this approach, the data are distributed on CD-ROM or DVD formats. In these magnetic devices, data are stored in ASCII format in a dedicated folder, and the data manuals and other files will enable the analyst to access the data as intended by NCES.

## History of NCES Data Analysis

Until the advent of `EdSurvey`, to access NCES data, researchers had to implicitly follow the specific steps described later in this foreword while using all the associated software packages that exist solely for each step. Analysts of NCES data had to carefully execute each step; otherwise, any mistake meant having to start over.

As mentioned previously, NCES settled on creating one set of files that could be stored on a CD-ROM or DVD for each data set released. The set of files contained enough information for any user or consumer of NCES data, regardless of the statistical software package used. For accessibility, a decision was made that the following three steps would generally make the data available to the average user, and these steps are still applicable today. 
* allowing  analysts to first select the variables for their analysis, then generating syntax files either in SPSS, SAS, or sometimes STATA
* using the syntax file to generate a reduced data file in the appropriate statistical software from the previous step, cleaning and performing all the necessary recodes
* importing these data in software programs such as WESVAR or AM for testing hypotheses
AM and WESVAR are needed because, traditionally, NCES data are collected using multistage sampling methodologies. Earlier versions of SAS and SPSS were inadequate for analyzing such sample data [@AM].  

### Step 1: Importing NCES Data Using the Electronic Code Book

NCES data constitute very large datasets, with several hundred variables and thousands of cases. Because the memory of personal computers was a few gigabytes      a decade ago, analysts could not upload all the data into their working memory to manipulate the data for their investigations. This problem is still relevant today. For example, NAEP mathematics or reading assessment at Grades 4 and 8 can have more than 1500 variables and close to 250,000 cases. It was then decided that each NCES dataset would be produced along with an electronic code book (ECB). The ECB allowed analysts to explore all the variables in the data files, including obtaining the frequency distribution for each category of a nominal or ordinal variable and the distribution information (min, max, standard deviation, and mean) for variables in the interval and ratio levels of measurement. An analyst may determine variables of interest after reviewing the ECB and then create either an SPSS or SAS syntax file from the ECB.

Across time, NCES noticed that almost every data collection program within NCES created its own ECB with varying unique features. Thus, someone had to analyze data from different program offices to learn the individual features of each ECB.

### Step 2: Data Cleaning and Recoding

In this step, the analyst can use the ECB to generate final data. This step also is the appropriate place to perform all the data cleaning and recoding.

### Step 3: Performing Hypotheses Testing and Variance Estimation

Use WESVAR or AM to specify the sampling design feature, compute estimates and proportions along with their standard errors, and perform all hypothesis testing. AM and WESVAR are utility tools for performing analyses with complex samples; they are not traditional statistical software packages. The types of analyses that AM and WESVAR were designed to perform were limited, and they did not generate sharable codes. NCES  could not be responsive to all the various requests for improvement or the need for updates.

Analysts must carefully plan their analyses, selecting all needed variables in Step 1 and performing all their data cleaning and manipulation in Step 2. In Step 3, every time a mistake originating from a previous step is discovered, the analyst must start over. 

AM and WESVAR were developed primarily for the computations of variance from complex samples and the estimation of group scores using students’ plausible values from large-scale assessment datasets. AM and WESVAR cannot generate additional outputs other than the ones incorporated when they were created. They also were created to be mostly menu driven to allow average analysts to comfortably use them without the requirement for writing code.

As one can see, the analyst of NCES data needs to have all the knowledge described previously before accessing the data and testing their hypotheses. Across time, the features of the analysis package remained unchanged because of budgetary constraints and software limitations. NCES data users inquired why AM and WESVAR couldn’t offer more features, such as the ability to share code with collaborators and advanced data manipulation. In 2014, NCES prioritized creating an analysis tool that would seek to address the issues raised by the research community.

Thus, NCES set out to create a tool that would incorporate all the steps listed previously, which could be expanded by the research community by allowing (a) input for analyses functions to be included in the tool, (b) analyses functions to be contributed by the research community, and (c) code sharing. Most importantly, the tool had to be affordable to the research community. Around that same time, institutions of higher learning were moving away from traditional software packages and favoring open-source packages.

## Development of the `EdSurvey` R Package

R is a programming language and software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing [@R-base]. Because the R language is widely used in academia and the research community for developing statistical software for statistical analysis, NCES chose this language to create the tool called `EdSurvey`. R software's free and extensible distribution ecosystem, [CRAN](https://cran.r-project.org/), provides access to a wide variety of bundled code for computing. Today, with `EdSurvey`, researchers who use NCES data have an additional tool for data access and analyses.

`EdSurvey` is a package developed in the R programming language. It is callable from the R programming environment, and it augments the capability of R base, thus creating a powerful environment for analysts. In addition to the augmentation of R base with `EdSurvey`, users could also add different existing packages, such as [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)---a data visualization package written in R---to create eye-catching graphics to share the results of the `EdSurvey` output with their audiences. So, analysts using `EdSurvey` have access to any other package from CRAN. They also can create a package that is `EdSurvey` callable to augment its functionality.

This manual is a guide for analysts who want to analyze their data collection of choice. Before expanding on `EdSurvey`’s functionality, the next section will expand on the structure of NCES datasets.

## Considerations for Analyzing NCES Data

It is important to remind the reader that NCES data are either samples or censuses. Census data are collected from the universe of possible entities of interest, mostly schools, school districts, and postsecondary institutions. Sample data are collected using multistage complex sample methodologies, with the population of interest being American children and students from 9 months old through postsecondary education, including teachers, principals, schools, and school districts. These sampled data subset into two major groups: cross-sectional and longitudinal. Cross-sectional data can partition into assessment data and nonassessment data. Assessment data such as NAEP and TIMSS are cross-sectional, complex, sampled data with an assessment component. The assessment component allows for inference on student groups' cognitive performance on a variety of subjects. Thus, this manual has three major analysis sections: assessment data, longitudinal data, and cross-sectional data. All these sample datasets are collected using multistage sample methodologies to ensure representativeness of the population of interest.

Complex samples require different methodologies to compute estimates and their associated standard errors. These methodologies might either require full sample weights and their replicates or the stratum variable and the primary sampling unit. Longitudinal data, also known as panel data, collect data on individuals across time. For those familiar with econometrics terminology, the development team notes that NCES panel data are unbalanced because it is very expensive to follow subjects across time. The sample sizes decrease as time elapses. Assessment data are cross-sectional, with an assessment component measuring what students know and can do for reporting and research.

`EdSurvey` was conceived and developed to be the go-to analysis tool for all cross-sectional, assessment, and longitudinal datasets produced by NCES. The package incorporates all the primary functionalities of the ECB. The researcher starts by forming a connection to the survey data to access the codebook, search the variables, and perform other operations before selecting the needed variables for an analysis. Because the package contains functionalities within one piece of software, it is easy for a researcher to research and select new variables to answer a specific research question. This user’s guide will showcase these functions with examples from different datasets.   

## Overview of EdSurvey Fundamentals

`EdSurvey` has a built-in command design to perform specific tasks on NCES data files. Some of these commands can access other files than the data file, such as the codebook  .  The second group of commands is designed to help the analyst explore the design variables or other variables such as plausible values. A third group of commands is designed for statistical analyses, including creating summary statistics that usually appear in NCES reports (e.g., means, standard errors, achievement level, and percentile results), correlations, and regressions. The last group of commands allows the performance of more advanced analyses, such as hierarchical linear modeling and direct estimation (as of Version 2.7). As development continues, more functions will become available in subsequent releases.

In general, the built-in functions in `EdSurvey` have the following structure : 

$Command (argument_1, argument_2, … argument_i, option_1, option_2, …)$

where $Command$ is the action that the analyst wants to perform, and $argument_i  $ is a required element that must appear after this particular command. The number of arguments depends on the given command, and $option_i$: is added to enhance the output from the command.

After the user installs `EdSurvey`, the next logical thing to do is to read built-in data files, read data from a repository, or read the Restricted-Use D ata received from the Institute of Education Sciences data officer. The command to read the data is ReadDATA, where data can be substituted with NAEP, TIMSS, and so forth. To execute this command, `EdSurvey` must know the location of the data file. So, the argument that specifies the path to the folder where the data file is located is necessary for the command to run. It also is important to have a very good understanding of the data of interest before unleashing this command because you must always be aware of the available resources on your computer. For example, the 2015 TIMSS data includes fourth-grade mathematics and science assessment results relating to students, parents, teachers, schools, and curricular background data covering 47 participating countries and six benchmarking entities. The same data are available for eighth-grade students but only for 39 countries and six benchmarking entities. Running the command `readTIMSS` will load all that data in your working memory:




```r
Mydatafile <-   readTIMSS(path = "~/TIMSS/2015")
```

To avoid memory overload , the development team recommends that analysts load only the data of their grade and country (or countries) of interest from the repository, as illustrated in the following example:


```r
#Read Grade 4 Denmark 2015 TIMSS survey into the dataframe Dnk2015 
Dnk2015 <- readTIMSS(path = "~/TIMSS/2015", countries = "dnk", gradeLvl = 4)
Dnk2015
```


```
#> Found cached Grade 4 data for country code "dnk: Denmark".
#> edsurvey.data.frame data level detail:
#> |---DataLevel----|----Rows----|--Columns---|---MergeType----|-------MatchedRecords-------|-OK-|
#> |Student         |        3710|        1196|                |*base level*                | ✓  |
#> |>School         |        3710|         101|many:one        |3710 of 3710                | ✓  |
#> |>Teacher        |        5897|         745|one:many        |5897 of 5897                | ✓  |
#> edsurvey.data.frame for 2015 TIMSS International
#>   (Mathematics and Science; Grade 4) in Denmark
#> Dimensions: 5897 rows and 2043 columns.
#> 
#> There are 4 full sample weights in this
#>   edsurvey.data.frame:
#>   'totwgt' with 150 JK replicate weights (the
#>   default).
#> 
#>   'tchwgt' with 150 JK replicate weights.
#> 
#>   'matwgt' with 150 JK replicate weights.
#> 
#>   'sciwgt' with 150 JK replicate weights.
#> 
#> 
#> There are 14 subject scale(s) or subscale(s) in this
#>   edsurvey.data.frame:
#> 'mmat' subject scale or subscale with 5 plausible
#>   values (the default).
#> 
#> 'ssci' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'mdat' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'mgeo' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'mnum' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'sear' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'slif' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'sphy' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'mkno' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'mapp' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'mrea' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'skno' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'sapp' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 'srea' subject scale or subscale with 5 plausible
#>   values.
#> 
#> 
#> Omitted Levels: 'Multiple', 'NA', 'OMITTED', 'OMITTED
#>                 OR INVALID', 'OMITTED (BLANK ONLY)',
#>                 'BLANK(OMITTED)', 'BLANK(MISSING)',
#>                 'BLANK(MISS)', 'MIS.', 'MISS.', 'N.
#>                 REA.', 'N.REA.', 'N. ADM.', 'N.
#>                 ADMIN.', 'NOT ADMIN', 'NOT APPL',
#>                 'NOT ADMINISTERED', 'NOT REACHED',
#>                 'NOT ADMIN.', 'NOT APPLICABLE',
#>                 'LOGICALLY NOT APPLICABLE',
#>                 'MISSING', and '(Missing)'
#> Achievement Levels:
#> Low International Benchmark: 400
#> Intermediate International Benchmark: 475
#> High International Benchmark: 550
#> Advanced International Benchmark: 625
```


Once the data are loaded, `EdSurvey` automatically detects the design elements needed for computing the estimates and standard errors. In the case of assessment data, this standard error has two components: the sampling error and the measurement error. The elements from the data file needed for their computation are the full sample weight, the replicate weights (or the stratum and the principal sampling unit variables), as well as the plausible values. One read function is unique to one study in `EdSurvey` because each NCES data file has its structure, data layout variable coding, and size. It also should be noted that, in general, different survey programs use different  methodologies to compute these variances. Read more about reading in survey data in [Chapter 4](#dataAccess).

Once read into `EdSurvey`, the next set of commands available to the analyst is showCommand, namely, `showCodebook`, `showWeights`, and `showPlausibleValues`. The following example illustrates the usage of `showPlausibleValues`:


```r
showPlausibleValues(data = Dnk2015, verbose=TRUE)
#> There are 14 subject scale(s) or subscale(s) in this
#>   edsurvey.data.frame:
#> 'mmat' subject scale or subscale with 5 plausible
#>   values (the default).
#>   The plausible value variables are: 'asmmat01',
#>   'asmmat02', 'asmmat03', 'asmmat04', and 'asmmat05'
#> 
#> 'ssci' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asssci01',
#>   'asssci02', 'asssci03', 'asssci04', and 'asssci05'
#> 
#> 'mdat' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asmdat01',
#>   'asmdat02', 'asmdat03', 'asmdat04', and 'asmdat05'
#> 
#> 'mgeo' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asmgeo01',
#>   'asmgeo02', 'asmgeo03', 'asmgeo04', and 'asmgeo05'
#> 
#> 'mnum' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asmnum01',
#>   'asmnum02', 'asmnum03', 'asmnum04', and 'asmnum05'
#> 
#> 'sear' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'assear01',
#>   'assear02', 'assear03', 'assear04', and 'assear05'
#> 
#> 'slif' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asslif01',
#>   'asslif02', 'asslif03', 'asslif04', and 'asslif05'
#> 
#> 'sphy' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'assphy01',
#>   'assphy02', 'assphy03', 'assphy04', and 'assphy05'
#> 
#> 'mkno' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asmkno01',
#>   'asmkno02', 'asmkno03', 'asmkno04', and 'asmkno05'
#> 
#> 'mapp' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asmapp01',
#>   'asmapp02', 'asmapp03', 'asmapp04', and 'asmapp05'
#> 
#> 'mrea' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asmrea01',
#>   'asmrea02', 'asmrea03', 'asmrea04', and 'asmrea05'
#> 
#> 'skno' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'asskno01',
#>   'asskno02', 'asskno03', 'asskno04', and 'asskno05'
#> 
#> 'sapp' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'assapp01',
#>   'assapp02', 'assapp03', 'assapp04', and 'assapp05'
#> 
#> 'srea' subject scale or subscale with 5 plausible
#>   values.
#>   The plausible value variables are: 'assrea01',
#>   'assrea02', 'assrea03', 'assrea04', and 'assrea05'
```

The option `verbose = TRUE` adds the additional descriptions. Please note that when running analyses with plausible values, one needs to supply only a short name for the set of plausible values, as found through this function, such as the "mmat" (mathematics performance scale) or "ssci" (science performance scale) in the TIMSS datasets. `EdSurvey` uses each plausible value in calculations and correctly accounts for the imputation variance from the plausible values [@Mislevy].

The last function described here is the search function. The command `searchSDF` searches a survey data frame and returns variable names and labels meeting the criteria specified by the user. Users can search by either the variable name or the labels of variables. The following examples illustrate several but not all possible implementations of the search function:


```r
# Search for variables with a name or label that contains “computer”
searchSDF(string = "computer", data = Dnk2015)
#>    variableName
#> 1       asbg05a
#> 2       asbg05b
#> 3       asbg10a
#> 4       asbg10b
#> 5       asbg10c
#> 6        acbg11
#> 7      acbg14ah
#> 8      acbg14bb
#> 9      acbg14cb
#> 10      atbm05a
#> 11     atbm05ba
#> 12     atbm05bb
#> 13     atbm05bc
#> 14      atbs04a
#> 15     atbs04ba
#> 16     atbs04bb
#> 17     atbs04bc
#> 18     atbs04ca
#> 19     atbs04cb
#> 20     atbs04cc
#> 21     atbs04cd
#>                                              Labels
#> 1            GEN\\HOME POSSESS\\COMPUTER TABLET OWN
#> 2         GEN\\HOME POSSESS\\COMPUTER TABLET SHARED
#> 3       GEN\\USE COMPUTER TABLET FOR HOMEWORK\\HOME
#> 4     GEN\\USE COMPUTER TABLET FOR HOMEWORK\\SCHOOL
#> 5      GEN\\USE COMPUTER TABLET FOR HOMEWORK\\OTHER
#> 6                       GEN\\TOTAL NUMBER COMPUTERS
#> 7           GEN\\SHORTAGE\\GEN\\COMPUTER TECHNOLOGY
#> 8             GEN\\SHORTAGE\\MAT\\COMPUTER SOFTWARE
#> 9             GEN\\SHORTAGE\\SCI\\COMPUTER SOFTWARE
#> 10    MAT\\COMPUTER TABLET AVAILABILITY DURING MATH
#> 11 MAT\\ACCESS TO COMPUTER\\EACH STD HAS A COMPUTER
#> 12     MAT\\ACCESS TO COMPUTER\\CLASS HAS COMPUTERS
#> 13    MAT\\ACCESS TO COMPUTER\\SCHOOL HAS COMPUTERS
#> 14     SCI\\COMPUTER TABLET AVAILABILITY DURING SCI
#> 15 SCI\\ACCESS TO COMPUTER\\EACH STD HAS A COMPUTER
#> 16     SCI\\ACCESS TO COMPUTER\\CLASS HAS COMPUTERS
#> 17    SCI\\ACCESS TO COMPUTER\\SCHOOL HAS COMPUTERS
#> 18 SCI\\COMPUTER TABLET ACTIVITIES\\PRACTICE SKILLS
#> 19   SCI\\COMPUTER TABLET ACTIVITIES\\LOOK UP IDEAS
#> 20   SCI\\COMPUTER TABLET ACTIVITIES\\DO PROCEDURES
#> 21 SCI\\COMPUTER TABLET ACTIVITIES\\STUDY PHENOMENA
#>    fileFormat
#> 1     Student
#> 2     Student
#> 3     Student
#> 4     Student
#> 5     Student
#> 6      School
#> 7      School
#> 8      School
#> 9      School
#> 10    Teacher
#> 11    Teacher
#> 12    Teacher
#> 13    Teacher
#> 14    Teacher
#> 15    Teacher
#> 16    Teacher
#> 17    Teacher
#> 18    Teacher
#> 19    Teacher
#> 20    Teacher
#> 21    Teacher
```

One can use Boolean algebra in their search:


```r
# Search for a variable with name or label that contains computer, or    internet, or phone
searchSDF(string="computer|internet|phone", data=Dnk2015)
#>    variableName
#> 1       m051134
#> 2       asbg05a
#> 3       asbg05b
#> 4       asbg05e
#> 5       asbg10a
#> 6       asbg10b
#> 7       asbg10c
#> 8       mr51134
#> 9       mi51134
#> 10       acbg11
#> 11     acbg14ah
#> 12     acbg14bb
#> 13     acbg14cb
#> 14      atbm05a
#> 15     atbm05ba
#> 16     atbm05bb
#> 17     atbm05bc
#> 18      atbs04a
#> 19     atbs04ba
#> 20     atbs04bb
#> 21     atbs04bc
#> 22     atbs04ca
#> 23     atbs04cb
#> 24     atbs04cc
#> 25     atbs04cd
#>                                              Labels
#> 1              MONTHS PETER PAID LESS FOR PHONE (1)
#> 2            GEN\\HOME POSSESS\\COMPUTER TABLET OWN
#> 3         GEN\\HOME POSSESS\\COMPUTER TABLET SHARED
#> 4            GEN\\HOME POSSESS\\INTERNET CONNECTION
#> 5       GEN\\USE COMPUTER TABLET FOR HOMEWORK\\HOME
#> 6     GEN\\USE COMPUTER TABLET FOR HOMEWORK\\SCHOOL
#> 7      GEN\\USE COMPUTER TABLET FOR HOMEWORK\\OTHER
#> 8              MONTHS PETER PAID LESS FOR PHONE (1)
#> 9              MONTHS PETER PAID LESS FOR PHONE (1)
#> 10                      GEN\\TOTAL NUMBER COMPUTERS
#> 11          GEN\\SHORTAGE\\GEN\\COMPUTER TECHNOLOGY
#> 12            GEN\\SHORTAGE\\MAT\\COMPUTER SOFTWARE
#> 13            GEN\\SHORTAGE\\SCI\\COMPUTER SOFTWARE
#> 14    MAT\\COMPUTER TABLET AVAILABILITY DURING MATH
#> 15 MAT\\ACCESS TO COMPUTER\\EACH STD HAS A COMPUTER
#> 16     MAT\\ACCESS TO COMPUTER\\CLASS HAS COMPUTERS
#> 17    MAT\\ACCESS TO COMPUTER\\SCHOOL HAS COMPUTERS
#> 18     SCI\\COMPUTER TABLET AVAILABILITY DURING SCI
#> 19 SCI\\ACCESS TO COMPUTER\\EACH STD HAS A COMPUTER
#> 20     SCI\\ACCESS TO COMPUTER\\CLASS HAS COMPUTERS
#> 21    SCI\\ACCESS TO COMPUTER\\SCHOOL HAS COMPUTERS
#> 22 SCI\\COMPUTER TABLET ACTIVITIES\\PRACTICE SKILLS
#> 23   SCI\\COMPUTER TABLET ACTIVITIES\\LOOK UP IDEAS
#> 24   SCI\\COMPUTER TABLET ACTIVITIES\\DO PROCEDURES
#> 25 SCI\\COMPUTER TABLET ACTIVITIES\\STUDY PHENOMENA
#>    fileFormat
#> 1     Student
#> 2     Student
#> 3     Student
#> 4     Student
#> 5     Student
#> 6     Student
#> 7     Student
#> 8     Student
#> 9     Student
#> 10     School
#> 11     School
#> 12     School
#> 13     School
#> 14    Teacher
#> 15    Teacher
#> 16    Teacher
#> 17    Teacher
#> 18    Teacher
#> 19    Teacher
#> 20    Teacher
#> 21    Teacher
#> 22    Teacher
#> 23    Teacher
#> 24    Teacher
#> 25    Teacher
```

Remember that TIMSS contains assessment data in mathematics and science at Grades 4 and 8 as well as student, parent, teacher, school, and curricular background data. One could narrow the search to a given background data file.


```r
#Search a keyword in the student file only
searchSDF(string = "computer", data = Dnk2015, fileFormat ="student")
#>   variableName
#> 1      asbg05a
#> 2      asbg05b
#> 3      asbg10a
#> 4      asbg10b
#> 5      asbg10c
#>                                          Labels fileFormat
#> 1        GEN\\HOME POSSESS\\COMPUTER TABLET OWN    Student
#> 2     GEN\\HOME POSSESS\\COMPUTER TABLET SHARED    Student
#> 3   GEN\\USE COMPUTER TABLET FOR HOMEWORK\\HOME    Student
#> 4 GEN\\USE COMPUTER TABLET FOR HOMEWORK\\SCHOOL    Student
#> 5  GEN\\USE COMPUTER TABLET FOR HOMEWORK\\OTHER    Student
```

The addition of the option `levels = TRUE` in the search function enables a close view of the categorical variable of interest. The next example showcases a different search and the usage of the argument levels.


```r
# Search multiple keywords
searchSDF(string = c("computer","homework","school"), data = Dnk2015, levels = TRUE)
#> Variable: asbg10b
#> Label: GEN\USE COMPUTER TABLET FOR HOMEWORK\SCHOOL
#> Levels (Lowest level first):
#>      1. EVERY DAY OR ALMOST EVERY DAY
#>      2. ONCE OR TWICE A WEEK
#>      3. ONCE OR TWICE A MONTH
#>      4. NEVER OR ALMOST NEVER
#>      9. OMITTED OR INVALID
```


```r
# Display levels of the variable "asbg10b"
levelsSDF(varnames = "asbg10b", data = Dnk2015)
#> Levels for Variable 'asbg10b' (Lowest level first):
#>     1. EVERY DAY OR ALMOST EVERY DAY (n = 840)
#>     2. ONCE OR TWICE A WEEK (n = 1368)
#>     3. ONCE OR TWICE A MONTH (n = 671)
#>     4. NEVER OR ALMOST NEVER (n = 603)
#>     9. OMITTED OR INVALID* (n = 122)
#>     NOTE: * indicates an omitted level.
```


Please note that these estimates are weighted. To see the unweighted frequency table, use the option `weightVar = NULL`:


```r
summary2(data = Dnk2015, variable = "asbg10b", weightVar = NULL)
#> Estimates are not weighted.
#>                         asbg10b    N   Percent
#> 1 EVERY DAY OR ALMOST EVERY DAY  840 22.641509
#> 2          ONCE OR TWICE A WEEK 1368 36.873315
#> 3         ONCE OR TWICE A MONTH  671 18.086253
#> 4         NEVER OR ALMOST NEVER  603 16.253369
#> 5            OMITTED OR INVALID  122  3.288410
#> 6                          <NA>  106  2.857143
```

Additional data exploration functions are in [Chapter 5](#understandingData).

The previous examples give a brief introduction to `EdSurvey` commands, what they look like, and their purpose. Many more commands appear in the subsequent chapters. These commands were created based on questions, inquiries, suggestions, and surveys collected from more than 2 decades of training at NCES, AERA, and National Council for Measurement in Education and interacting with analysts of our data products. The researcher should pay particular attention to commands that are specific to some types of data and those that apply to any dataset. As users progress through this manual while analyzing their data, they must always remember that (a) they are in the R environment, (b) all the commands of R base are available to them at any given time, and (c) they have to ability to augment `EdSurvey` with tools from other packages in CRAN.
At the end of this manual, Chapters 11 and 12   detail some of the mathematics used to create some of the functions in `EdSurvey`. This is done purposefully. The development team wants the user to be aware that even though this package makes many computations easily accessible, there are intensive computations and several methodologies that either existed or were developed that were implemented in this package. The entire `EdSurvey` package is not complete because it is still being developed. The team strongly encourages that anyone who has suggestions of methodology that could be added or that they have developed themselves as an add-on to [contact us]( https://github.com/American-Institutes-for-Research/EdSurvey) for possible implementation. The development team will not guarantee inclusion but will give any suggestions a fair assessment.
