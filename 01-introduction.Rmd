# Introduction

Last edited: February 2022

**Suggested Citation**<br></br>
Zhang, T. Introduction. In Bailey, P. and Zhang, T. (eds.), _Analyzing NCES Data Using EdSurvey: A User's Guide_.

Large-scale educational assessments---such as NAEP (National Assessment of Educational Progress), TIMSS (Trends in International Mathematics and Science Study), PISA (Programme for International Student Assessment)---collect data related to education in the United States and other nations. Because of the quality and quantity of the inherent information, the assessment data are valuable assets for policymakers, education practitioners, and researchers to explore and understand multiple education-related issues from childhood to adulthood, from schools, homes, and neighborhoods. These large-scale assessments measure activities and outcomes of educational systems and institutions in jurisdictions (e.g., districts, states, countries) and address how other jurisdictions educate their children and with what success. They gather demographic information and contextual data from participating students and their homes, schools, and teachers on various topics, such as crucial curricular, instructional, and resource-related factors that can impact the teaching and learning process. 

Because of their special sampling and testing designs, large-scale educational assessment data allow inference at the jurisdiction level regarding the target sample and domains assessed, for example, U.S. students’ achievement in mathematics in Grade 8. Meanwhile, the designs have implications for data analyses. Often, customized statistical analysis modules need to properly account for the designs in data analysis.

## Sampling Design

Most large-scale assessments employ a complex, multistage, clustered sampling design [@Johnson; @LaRoche; @PISA]. Initially, schools are selected based on specified probabilities. At the second stage, for NAEP and PISA assessments, students within sampled schools undergo random selection. For IEA (International Association for the Evaluation of Educational Achievement) studies, a random process selects one or two intact classrooms at each grade; then all students in these classrooms are assessed. Overall, the probability of selecting schools and students varies depending on school size and other characteristics. In data analyses, sampling weights therefore need to accommodate the fact that some units, such as schools or students, might have unequal probabilities in their selection process. 

There are other important considerations for NCES survey analysis. Simple random sampling for calculating standard errors of estimates is not appropriate for large-scale assessment data analyses. Student sampling occurs through clusters (e.g., same school or same class) and therefore have more similar characteristics than those sampled randomly. Although many variance estimation methods exist to adjust the clustering effects, the most popular approach used by NAEP, IEA studies, and OECD studies is replication methods. In particular, NAEP and IEA studies use the jackknife repeated replication method; OECD studies such as PISA employ balanced repeated replication (BRR) method [@Johnson; @Rust; @Wolter]. 

## Testing Design

Large-scale assessments create a large item pool to provide comprehensive coverage of a subject. For example, for NAEP mathematics and reading cognitive tests, the item number can range from 100 to 200 per subject per grade [@NAEP] . It is unrealistic to administer all items to students, and their parents or schools likely would not consent. Therefore, large-scale assessments such as NAEP, TIMSS, and PISA use a matrix sampling design of items in which each sampled student takes only a portion of the entire pool of test items. This design reduces student burden while allowing for maximum coverage of the content area for student performance. As a downside, however, it increases complexity for estimating student performance. Using traditional methods for generating student proficiency scores leads to biased variance estimates of population parameters. Instead, the plausible values technique has been employed for proficiency estimates and their variance estimation [@Mislevy; @Rutkowski]. This book summarizes the methodology used by `EdSurvey` for large-scale assessment data in [Chapter 8](#methods). 

## Why EdSurvey

Free tools supplied by assessment institutes and government agencies allow the research community to access and analyze large-scale datasets, including the International Database Analyzer (IDB Analyzer), NCES Electronic Code Books, NAEP Data Explorer, International Data Explorer, WesVar, and AM software. Nevertheless, research analysts use commercially available software packages (e.g., SPSS, SAS, STATA) for data merging, cleaning, and manipulation before importing the data into tools such as WesVar or AM to account for complex sample designs and use the plausible values. Most of the free tools are menu-driven software programs that do not create a sharable code. These tools were created with the average statistical user in mind and limit the types of the statistical analyses that they can support.

`EdSurvey` runs in R, a programming language licensed under the GNU General Public License and widely used by academic and research communities. The package can process and analyze large-scale assessment data with appropriate procedures. It is a one-stop shop for data downloading, processing, manipulating, and analyzing survey data. Other packages in R will analyze large-scale assessment data, including survey [@Lumley], lavaan.survey [@Oberski], svyPVpack [@svyPVpack], BIFIE [@BIFIE], and intsvy [@intsvy] . Among these packages, some have limited data coverage (e.g., tailored to international large-scale assessments only), and some require user input about the survey design and plausible values before being used. `EdSurvey` was developed to analyze all the large-scale assessments that the United States participates in under NCES, with the complex sampling design and plausible value methodology incorporated seamlessly. The advantages of `EdSurvey` are as follows: 

- Allows for data manipulation inside and outside the package. 
- Minimizes the memory footprint by reading in only required data.
- Enables users to search the names and labels of variables, view frequencies and percentages of response categories of variables, and visualize the data. 
- Performs complex sample analysis operations. 
- Computes analyses with plausible values. 
- Performs multilevel analyses and modeling. 
- Expands functions and data supports to meet the needs of all analysts of various levels of expertise.

`EdSurvey` follows the methodology used in large-scale assessments for estimation [@Johnson; @Mislevy]. It offers three methods for variance estimation: the jackknife replication method, BRR, and the Taylor series approximation. See [Chapter 8](#methods) for our estimation procedures, including means, percentages, percentiles, achievement levels, regression analysis, and variance estimation with or without the presence of plausible values.
