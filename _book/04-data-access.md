# Data Access {#dataAccess}

To obtain and read in different types of assessment data, each section in this chapter shows information about licensing, downloading, and some simple examples. Before processing NCES datasets with `EdSurvey`, review the available study documentation to familiarize yourself with each unique study. 

Its good practice to keep source data in a structured folder scheme.  For `EdSurvey` we recommend having one `root` data folder, subfolders for each study, and year/group folders within each study subfolder.  For example, `C:/EdSurveyData` would be the `root` folder.  Then `C:/EdSurveyData/TIMSS` would be the `TIMSS` study folder.  Lastly, each year of TIMSS data would then have another subfolder such as `C:/EdSurveyData/TIMSS/2015`. This structure helps organize the data and is the method used by the `download` functions.

## NAEP: National Assessment of Educational Progress

NAEP is a measure used to study U.S. student achievement in urban districts, states, and the nation in many subjects, including reading, mathematics, science, writing, and other subjects for Grades 4, 8, and 12. The assessments are sponsored by the NCES within the U.S. Department of Education and the Institute of Education Sciences (IES). Further study information can be found on the [NAEP Webpage](https://nces.ed.gov/nationsreportcard/).  All NAEP datasets are restricted-use files from NCES; however, a publicly available sample dataset called NAEP Primer can be accessed through the R package `NAEPprimer`.

NAEP study files are primarily used to analyze student performance and usually include school-level data, which are automatically handled by the `readNAEP` function.  Additional arguments to `readNAEP` include `defaultWeight`, `defaultPvs`, `dropOmittedLevels`, and `frPath`.  These arguments should be modified from their default values only in rare situations.  Consult the `readNAEP` function documentation for more details on their use.

Before beginning to analyze NAEP data, be sure to read the provided user guide and documentation provided by NCES to familiarize yourself with the study and apply their guidance for analysis.

When the `readNAEP` function is called, it locates the specified ASCII fixed-width data file (.dat) from the supplied `path` argument. The `readNAEP` function then scans for the data files (.dat) associated with the layout file (.fr2) located in the `Select/Parms` folder which contains all the information needed for parsing the data file.  Lastly, the `readNAEP` function scans the folder for its associated school-level data file. The main student-level files have a naming scheme of `xxxxTxxx.dat`, whereas the school-level files have a naming scheme of `xxxxCxxx.dat`.  The data are read in on the fly, and `EdSurvey` stores the file connection information, and associated meta-data without having to load the entire dataset into memory.

### Reading NAEP Data

```r
#reading in the NAEP Primer data using the package NAEPprimer
naep.1 <- readNAEP(path = system.file("extdata/data", "M36NT2PM.dat", package = "NAEPprimer"))

#pointing to a NAEP restricted-use file directly by path
naep.2 <- readNAEP(path = "C:/RUD_DATA/NAEP/M36NT2PM.dat")
```

## ECLS: Early Childhood Longitudinal Study {#ECLS-data}

ECLS includes of three U.S. longitudinal studies. Two public-use datasets feature students beginning at the kindergarten level known as the ECLS-K studies.  The first began with a sample of kindergarten students beginning in 1998 that were followed through grade 8 (i.e., ECLS-K).  The second study was a group of kindergarten students beginning in 2011 through grade 5 (i.e., ECLS-K:2011). The final ECLS study is known as ECLS-B which followed children ages 9 months through their preschool level. The ECLS-B is a restricted-use dataset only. All three studies were sponsored by NCES.  Further study information can be found on the [NCES ECLS Study webpage](https://nces.ed.gov/ecls/index.asp).

Before beginning to analyze ECLS data, be sure to read the published user guides and documentation provided by NCES to familiarize yourself with the study and apply their guidance for analysis.  Be advised that are a large number of weight variables, so care must be used to select the appropriate weight for analysis.

When a `readECLS_K1998`, `readECLS_K2011`, or `readECLS_B` call is first used to read in the data, it will process the data to prepare it for `EdSurvey` on the first read call. This step will take significant time, because of the large size of the data files. The preparation involves parsing the SPSS (.sps) script file to gather all the relevant data and variable information and then outputting a fixed-width data (.txt) file suitable for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

The `downloadECLS` function downloads and extracts the ECLS data from the [NCES Online Codebook](https://nces.ed.gov/OnlineCodebook) for the ECLS-K 1998 study. For the ECLS-K 2011 study, the files are downloaded from the [NCES ECLS Study Data Products webpage](https://nces.ed.gov/ecls/dataproducts.asp).  For the ECLS-B study, the files are restricted-use and must be obtained through an IES restricted-use data license.  Additional specifics on what files are required are detailed within the specific section for each study.

###	ECLS-K

The ECLS-K study mainly comprises of public-use study data at the student/child level.  It also has files for school data, and teacher data that were gathered throughout the study.  The student, school, and teacher data are to be analyzed separately; the data cannot be joined/merged together.

The `downloadECLS` function downloads all the ECLS-K data from the [NCES Online Codebook](https://nces.ed.gov/OnlineCodebook).  The format required for the `readECLS_K1998` function is a fixed-width data file (.dat), along with the NCES formatted text layout file (.txt) which includes all the relevant details about the data file.

#### Obtaining ECLS-K Data

```r
#download ECLS-K data to the root folder
downloadECLS_K(root = "C:/EdSurveyData", years = 1998)

#if cache = TRUE, it will perform the data caching step now 
#instead of the first readECLS_K2011 call
downloadECLS_K(root = "C:/EdSurveyData", years = 1998, cache = TRUE)

#for no console (silent) output, you can set verbose = FALSE
downloadECLS_K(root = "C:/EdSurveyData", years = 1998, verbose = FALSE)
```

#### Reading ECLS-K Data

```r
#read in the student/child data file, specifying the files directly
eclsk98.1 <- readECLS_K1998(path = "C:/EdSurveyData/ECLS_K/1998",
                            filename = "eclsk_98_99_k8_child_v1_0.dat",
                            layoutFilename = "Layout_k8_child.txt")

#by default, the filename is specified as 'eclsk_98_99_k8_child_v1_0.dat',
#and the default layoutFilename as 'Layout_k8_child.txt',
#so you can omit the filename and layoutFilename argument when using default filenames.
eclsk98.2 <- readECLS_K1998(path = "C:/EdSurveyData/ECLS_K/1998")

#read in the teacher data file, specifying the filename and its associated layout file
eclsk98.3 <- readECLS_K1998(path = "C:/EdSurveyData/ECLS_K/1998",
                            filename = "ECLSK_98_99_K8_TCH_v1_0.dat",
                            layoutFilename = "Layout_k8_tch.txt")

#setting verbose = FALSE stops console message output (silent) of the function.
eclsk98.4 <- readECLS_K1998(path = "C:/EdSurveyData/ECLS_K/1998", verbose = FALSE)
```

### ECLS-K:2011

The ECLS-K:2011 study mainly comprises of public-use study data at the student/child level. There are no additional data files at the school and teacher levels.

The `downloadECLS` function downloads all the ECLS-K:2011 data from the [NCES ECLS Study Data Products webpage](https://nces.ed.gov/ecls/dataproducts.asp).  The format required for the `readECLS_K2011` function is a fixed-width data file (.dat), along with the SPSS script syntax file (.sps), which includes all the relevant details about the fixed-width data file.  An NCES formatted data layout file is currently not available for ECLS-K 2011, so users should use the SPSS script syntax file.

#### Obtaining ECLS-K:2011 Data

```r
#download ECLS-K 2011 data to the root folder
downloadECLS_K(root = "C:/EdSurveyData", years = 2011)

#if cache = TRUE, it will perform the data caching step now 
#instead of the first readECLS_K2011 call
downloadECLS_K(root = "C:/EdSurveyData", years = 2011, cache = TRUE)

#for no console (silent) output, you can set verbose = FALSE
downloadECLS_K(root = "C:/EdSurveyData", years = 2011, verbose = FALSE)
```

#### Reading ECLS-K:2011 Data

```r
#read in the student/child data, file specifying the files directly
eclsk11.1 <- readECLS_K2011(path = "C:/EdSurveyData/ECLS_K/2011",
                            filename = "childK5p.dat",
                            layoutFilename = "ECLSK2011_K5PUF.sps")

#by default, the filename is specified as 'childK5p.dat',
#and the default layoutFilename as 'ECLSK2011_K5PUF.sps',
#so you can omit the filename and layoutFilename argument when using default filenames
eclsk11.2 <- readECLS_K2011(path = "C:/EdSurveyData/ECLS_K/2011")

#setting verbose = FALSE stops console message output (silent) of the function
eclsk11.3 <- readECLS_K2011(path = "C:/EdSurveyData/ECLS_K/2011", verbose = FALSE)
```

### ECLS-B

The ECLS-B study comprises of restricted-use study data at the child level. The format required for the `readECLS_B` function is a fixed-width data file (.dat), along with the SPSS script syntax file (.sps), which includes all the relevant details about the fixed-width data file.  The SPSS script syntax (.sps) file must be generated using the ECLS-B supplied electronic codebook (ECB) program that is included with the ECLS-B restricted-use data.  Using the ECB program you can select your variables and generate the SPSS script (.sps) syntax file from the tool.

#### Reading ECLS_B Data

```r
#read in the ECLS-B data
eclsb.1 <- readECLS_B(path = "C:/RUD_DATA/ECLS_B",
                      filename = "ChildK07.dat",
                      layoutFilename = "eclsb.sps")
```

## ELS: Education Longitudinal Study of 2002

The ELS:2002 study was a U.S. longitudinal study designed to follow high school sophomores (Grade 10) in the fall 2002 school year with follow-ups every 2 years through high school into their college/adult paths.  Follow-ups where conducted in 2004, 2006, and 2012. NCES sponsored the study.  Further study information can be found on the [NCES ELS Study webpage](https://nces.ed.gov/surveys/els2002/).

Before beginning to analyze with ELS data, be sure to read the published user guides and documentation provided by NCES to familiarize yourself with the study and apply their guidance for analysis.  Be advised that there are a large number of weight variables, so care must be used to select the appropriate weight for analysis.

The data for ELS comprises two large student-level files (one student data file plus one file for weight replicates), which contain all the available variables across the data collections, as well three school-level data files for different study periods.  The student and school data files cannot be merged or joined for analysis.

When a `readELS` call is first used to read in the data, it will perform process the data to prepare it for `EdSurvey` on the first read call. This step will take significant time, because of the large size of the data files. The preparation involves parsing the SPSS (.sav) files to gather all the relevant data and variable information, then outputting a fixed-width (.txt) data file suitable for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

The `downloadELS` function downloads and extracts the ELS data from the [NCES Online Codebook](https://nces.ed.gov/OnlineCodebook) in the SPSS data file format to the specified `root` folder.

### Obtaining ELS Data

```r
#download ELS:2002 data to the root folder
downloadELS(root = "C:/EdSurveyData", years = 2002)

#if cache = TRUE, it will perform the data caching step now
#instead of the first readELS call
downloadELS(root = "C:/EdSurveyData", years = 2002, cache = TRUE)

#for no console (silent) output, you can set verbose = FALSE
downloadELS(root = "C:/EdSurveyData", years = 2002, verbose = FALSE)
```

### Reading ELS Data

```r
#reading in the ELS student data file
els.1 <- readELS(path = "C:/EdSurveyData/ELS/2002",
                 filename = "els_02_12_byf3pststu_v1_0.sav",
                 wgtFilename = "els_02_12_byf3stubrr_v1_0.sav")

#by default the filename is specified as 'els_02_12_byf3pststu_v1_0.sav',
#and the default wgtFilename as 'els_02_12_byf3stubrr_v1_0.sav,'
#so you can omit the filename and wgtFilename argument when using default filenames
els.2 <- readELS(path = "C:/EdSurveyData/ELS/2002")

#to read in a school data file
#wgtFilename can either be omitted or set to 'NA' value as it's not applicable
els.3 <- readELS(path = "C:/EdSurveyData/ELS/2002",
                 filename = "els_02_12_byf1sch_v1_0.sav",
                 wgtFilename = NA)

#setting verbose = FALSE stops console message output (silent) of the function.
els.4 <- readELS(path = "C:/EdSurveyData/ELS/2002", verbose = FALSE)
```

## HSLS: High School Longitudinal Study of 2009

The HSLS:09 study was a U.S. longitudinal study designed to follow high school freshman (Grade 9) in the fall 2009 school year through high school into their adult roles.  The study had four additional follow-up data collections. The first follow-up occurred in 2012 when the students were high school juniors (Grade 11).  The next collection was done in 2013 when the students were high school seniors (Grade 12).  Another collection was completed 3 years after high school graduation in 2016.  The final collection was in 2017, which was 4 years after high school graduation, but the data have yet to be released.  NCES sponsored the study.  Further study information be found on the [NCES HSLS Study webpage](https://nces.ed.gov/surveys/hsls09/index.asp).

Before beginning to analyze with HSLS data, be sure to read the published user guides and documentation provided by NCES to familiarize yourself with the study and apply their guidance for analysis.  Be advised that there are a large number of weight variables for HSLS, so care must be used to select the appropriate weight for analysis.

The data for HSLS comprises of one large student-level file, which contains all the available variables across the data collections, as well as a school-level data file.  The student and school data files are not meant to be merged, or joined, for analysis.

When a `readHSLS` call is first used to read in the data, it will process the data to prepare it for the `EdSurvey` package on the first read call. This step will take significant time, because of the large size of the HSLS data files. The preparation involves parsing the SPSS (.sav) files to gather all the relevant data and variable information and then outputting a fixed-width (.txt) data file suitable for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

The `downloadHSLS` function downloads and extracts the HSLS data from the [NCES Online Codebook](https://nces.ed.gov/OnlineCodebook) in the SPSS data file format to the specified `root` folder.

### Obtaining HSLS Data

```r
#download HSLS:09 data to the root folder
downloadHSLS(root = "C:/EdSurveyData", years = 2009)

#if cache = TRUE, it will perform the data caching step now
#instead of the first readHSLS call
downloadHSLS(root = "C:/EdSurveyData", years = 2009, cache = TRUE)

#for no console (silent) output, you can set verbose = FALSE
downloadHSLS(root = "C:/EdSurveyData", years = 2009, verbose = FALSE)
```

### Reading HSLS Data

```r
#reading in the HSLS student data file
hsls.1 <- readHSLS(path = "C:/EdSurveyData/HSLS/2009", 
                   filename = "hsls_16_student_v1_0.sav")

#by default the filename is specified as 'hsls_16_student_v1_0.sav', 
#so you can omit the filename argument.
hsls.2 <- readHSLS(path = "C:/EdSurveyData/HSLS/2009")

#to read in the school data file
hsls.3 <- readHSLS(path = "C:/EdSurveyData/HSLS/2009", 
                   filename = "hsls_09_school_v1_0.sav")

#in rare instances (such as using restricted-use data),
#you also may need to specify a `weight` file 
#that contains the study replicate weight variables
hsls.4 <- readHSLS(path = "C:/EdSurveyData/HSLS/2009", 
                   filename = "student.sav", 
                   wgtFilename = "student_weight.sav")

#setting verbose = FALSE stops console message output (silent) of the function.
hsls.5 <- readHSLS(path = "C:/EdSurveyData/HSLS/2009", verbose = FALSE)
```

## ICCS and CivED: International Civic and Citizen Education Study and Civic Education Study 1999

ICCS and CivED have been combined into the same set of data functions, because they both involve civic education. The CivED study was conducted in 1999 by [IEA (International Association for the Evaluation of Educational Achievement)](https://www.iea.nl) and the Humboldt University of Berlin.  The CivED study comprised primarily of Grade 8 students and also had a Grade 12 student component.  The Grade 8 dataset included school and teacher information, as well as the ability to link student data with teacher and school level data. The Grade 12 data has student-level information only.

The ICCS study was first implemented in 2009 with a follow-up cycle in 2016 and one in progress for 2022. `EdSurvey` currently supports the read-in and analysis of the 2009 and 2016 data. The ICCS study was coordinated with many partners, including, [IEA (International Association for the Evaluation of Educational Achievement)](https://www.iea.nl), [ACER (Australian Council for Educational Research)](https://www.acer.org/au), [LPS (Laboratorio di Pedagogia Sperimentale)](https://scienzeformazione.uniroma3.it/ricerca/laboratori-di-ricerca/laboratorio-di-pedagogia-sperimentale-lps/) at Roma Tre University, and many other national centers.  The ICCS study had a target population of students primarily in Grade 8, along with some data for students in Grade 9. Also available are school- and teacher-level data.  Unlike most other IEA datasets, the ICCS study cannot link student-level data to teacher-level data, so the user must specify which `dataSet` they wish to analyze in the `readCivEDICCS` function argument.

Before beginning to analyze CivED/ICCS data, be sure to read the published user guides and documentation provided by IEA to familiarize yourself with the study and apply their guidance for analysis. The user guide identifies the International Organization for Standardization (ISO) three-digit country codes that will be used as arguments for the `readCivEDICCS` function to read in specific countries. The three-digit ISO country codes  also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3).

When a `readCivEDICCS` call is first used to read in the data, it will process the data to prepare it for `EdSurvey` on the first read call. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer. The preparation involves parsing the SPSS files (.sav) to gather all the relevant data and variable information, merging all necessary files, and then outputting to a fixed-width (.txt) data file. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

The `downloadCivEDICCS` function provides user instructions for downloading the datasets from the IEA Data Repository for both the CivED and ICCS studies.

The `readCivEDICCS` function supports both datasets with all the study data, although care must be taken to correctly specify the correct parameters.

### Obtaining CivED Data

```r
#View instructions for obtaining the CivED Study files from the IEA Data Repository
downloadCivEDICCS(years = 1999)
```

### Obtaining ICCS Data

```r
#View instructions for obtaining the ICCS Study files from the IEA Data Repository
downloadCivEDICCS(years = 2009)
```

### Reading CivED Data

```r
#reading in a single country for a single year for 8th-grade student data
#having dataSet = "student", includes School-, Student-, and Teacher-level 
#information (because they can be merged).
#returns a single edsurvey.data.frame
cived.1 <- readCivEDICCS(path = "C:/EdSurveyData/CivED/1999",
                         countries = "deu",
                         dataSet = "student",
                         gradeLvl = 8)

#reading in multiple countries for a single year for 8th-grade student data
#returns an edsurvey.data.frame.list
cived.2 <- readCivEDICCS(path = "C:/EdSurveyData/CivED/1999",
                         countries = c("deu", "cze"),
                         dataSet = "student",
                         gradeLvl = 8)

#use the wildcard to search for all available countries in the path
#specifying the dataSet= "teacher", includes the Teacher and School levels only 
#(because they can be merged)
cived.3 <- readCivEDICCS(path = "C:/EdSurveyData/CivED/1999",
                         countries = "*",
                         dataSet = "teacher",
                         gradeLvl = 8)

#for CivED there is a grade 12 dataset with only student-level data
#returns an edsurvey.data.frame.list
cived.4 <- readCivEDICCS(path = "C:/EdSurveyData/CivED/1999",
                         countries = c("cze", "est"),
                         dataSet = "student",
                         gradeLvl = 12)
```

### Reading ICCS Data

```r
#reading in a single country for a single year for 8th-grade student data
#having dataSet = "student", includes School- and Student-level data
#(they can be merged together).
#returns a single edsurvey.data.frame
iccs.1 <- readCivEDICCS(path = "C:/EdSurveyData/ICCS/2009",
                        countries = "kor",
                        dataSet = "student",
                        gradeLvl = 8)

#reading in a single country for a single year for 8th-grade teacher data
#having dataSet = "teacher", includes School- and Teacher-level data
#(they can be merged together).
#returns a single edsurvey.data.frame
iccs.2 <- readCivEDICCS(path = "C:/EdSurveyData/ICCS/2009",
                        countries = "kor",
                        dataSet = "teacher",
                        gradeLvl = 8)

#use the wildcard to search for all available countries in the path. 
#you must still specify the dataSet and gradeLvl arguments
#for the correct dataset to analyze
iccs.3 <- readCivEDICCS(path = "C:/EdSurveyData/ICCS/2009",
                        countries = "*",
                        dataSet = "student",
                        gradeLvl = 8)

#for ICCS there is a grade 9 dataset with only student-level data
#returns an edsurvey.data.frame.list
iccs.4 <- readCivEDICCS(path = "C:/EdSurveyData/ICCS/2009",
                        countries = c("swe", "nor"),
                        dataSet = "student",
                        gradeLvl = 9)
```

## ICILS: International Computer and Information Literacy Study

The ICILS study is a global study that focuses on target populations of Grade 8 students to help understand aspects of their computer use and information literacy. The study has two cycles of public-use datasets from 2013 and 2018. The study partners are [IEA (International Association for the Evaluation of Educational Achievement)](https://www.iea.nl) and [ACER (Australian Council for Educational Research)](https://www.acer.org/au). In addition to student-level data, data are collected for both the school and teacher levels. Student-level data cannot be directly joined to teacher-level data as part of the study design.

The `downloadICILS` function provides instructions on obtaining the ICILS data from the [IEA Data Repository](https://www.iea.nl/data-tools/repository/icils).  The `readICILS` function supports the SPSS (.sav) data file format.

Before beginning to analyze ICILS data,  be sure to read the published user guides and documentation provided by IEA/ACER to familiarize yourself with the study and apply their guidance for analysis.  The user guide also identifies the ISO three-digit country codes that will be used as arguments for the `readICILS` function to read in specific countries.  The three-digit ISO country codes can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3).

When a `readICILS` call is first used to read in the data, it will process the data to prepare it for `EdSurvey`. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer initially.  The preparation involves parsing the SPSS (.sav) files to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a fixed-width (.txt) data file. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

An `edsurvey.data.frame` of ICILS data will handle all the necessary merging/linking of school data to both student- and teacher-level data behind the scenes for the user.  The `dataSet` argument must be specified as either `student` or `teacher` to indicate which set of data you wish to analyze.  Both the `student` and `teacher` datasets can be merged to the `school` level data, which will be available for the user automatically.

### Obtaining ICILS Data

```r
#the downloadICILS function will display instructions for
#downloading the ICILS data from the IEA Data Repository
downloadICILS(years = 2013)
```

### Reading ICILS Data

```r
#reading in a single country for ICILS 2013 student data
#returns a single edsurvey.data.frame
icils.1 <- readICILS(path = "C:/EdSurveyData/ICILS/2013",
                     countries = "chl",
                     dataSet = "student")

#reading in multiple countries for a single year for teacher level data
#returns an edsurvey.data.frame.list
icils.2 <- readICILS(path = "C:/EdSurveyData/ICILS/2013",
                     countries = c("pol", "svk", "svn"),
                     dataSet = "teacher")

#use the wildcard to search for all available countries in the path. 
#returns edsurvey.data.frame.list of all found countries
icils.3 <- readICILS(path = "C:/EdSurveyData/ICILS/2013",
                     countries = "*",
                     dataSet = "student")

#specify multiple paths if wishing to read in multiple years.
#returns an edsurvey.data.frame.list
icils.4 <- readICILS(path = c("C:/EdSurveyData/ICILS/2013", 
                              "C:/EdSurveyData/ICILS/2018"), 
                     countries = c("deu", "dnk"),
                     dataSet = "student")
```

## TIMSS: Trends in International Mathematics and Science Study

TIMSS is a global study focusing on target populations of Grade 4 and Grade 8 students. The study began in 1995 and has release cycles every 4 years comprising public-use datasets from 1995, 1999, 2003, 2007, 2011, 2015, and 2019 released in conjunction with the [Boston College Lynch School of Education](https://timssandpirls.bc.edu/) and [IEA](https://www.iea.nl). In addition to the student assessment data, the database includes student, teacher, school, and curricular background data for both grades.

The `downloadTIMSS` function downloads and unzips the data hosted by the [Boston College TIMSS and PIRLS Database](https://timssandpirls.bc.edu/) for the following years: 2003, 2007, 2011, 2015, and 2019. The same data also can be found and manually downloaded from the [IEA Data Repository](https://www.iea.nl/index.php/data-tools/repository/timss). The required data format used by the `readTIMSS` function is the SPSS (.sav) file format version. Use the IEA Data Repository if you wish to obtain and analyze 1995 or 1999 data because the Boston College TIMSS Database does not provide SPSS (.sav) files for those study years.

Before beginning to analyze TIMSS data, be sure to read the studies published user guides and documentation provided by Boston College and IEA to familiarize yourself with the study and apply their guidance for analysis. The user guide identifies the ISO three-digit country codes that will be used as arguments for the `readTIMSS` function to read in specific countries.  The three-digit ISO country codes also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3).  TIMSS data include other jurisdictions and subgroups that are not countries, and the published TIMSS documentation will include the specific codes needed if you wish to analyze those as well.  The `readTIMSS` function also supports a wildcard character of `*` for the `countries` parameter, which will scan the specified `path` directories for all available countries.

When a `readTIMSS` call is first used to read in the data, it will process the data to prepare it for `EdSurvey` on the first read call. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer initially.  The preparation involves parsing the SPSS (.sav) files to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a fixed-width (.txt) data file. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

An `edsurvey.data.frame` of TIMSS data will handle all the necessary merging/linking of the school- and teacher-level data behind the scenes for the user, based on the variables requested in a function.  For the Grade 8 data files, the teacher surveys have both a math and science component.  The variable names duplicated between them have been modified to indicate if they are math or science by adding a `.math` and a `.sci` to the end of the variable name.  For example the `btbg05e` variable is common in both the math and science teacher questionnaire.  This variable has been renamed within `EdSurvey` to be `btbg05e.math` and `btbg05e.sci` to indicate the teacher questionnaire type and aid users in their analysis.

In 2015, countries with less-developed education systems had the opportunity to participate in TIMSS Numeracy, which included items of lower difficulty.  TIMSS Numeracy data are automatically included in `readTIMSS` for 2015 data, and `gradeLvl = 4` is specified.

### Obtaining TIMSS Data

```r
#obtain the data to analyze for both 2011 and 2015 study years
downloadTIMSS(root = "C:/EdSurveyData", years = c(2011, 2015), cache = FALSE, verbose = TRUE)

#if you wish to prepare to analyze all countries to have them ready for analysis,
#set the cache argument to TRUE (cache = TRUE).  Be prepared that this may take some time.
#setting the verbose argument to TRUE will keep you informed of the progress in the console
downloadTIMSS(root = "C:/EdSurveyData", years = c(2011, 2015), cache = TRUE, verbose = TRUE)

#for silent output with no message output set the verbose argument to FALSE (verbose = FALSE).
#setting verbose to FALSE is not recommended if cache is set to TRUE 
#because you won't see the progress.
downloadTIMSS(root = "C:/EdSurveyData", years = c(2011, 2015), cache = FALSE, verbose = FALSE)
```

### Reading TIMSS Data

```r
#reading in a single country for a single year for 4th grade
#returns a single edsurvey.data.frame
timss.1<- readTIMSS(path = "C:/EdSurveyData/TIMSS/2015", countries = "usa", gradeLvl = 4)

#reading in multiple countries for a single year for 8th grade
#returns an edsurvey.data.frame.list
timss.2 <- readTIMSS(path = "C:/EdSurveyData/TIMSS/2015",
                     countries = c("aus", "swe", "nor"),
                     gradeLvl = 8)

#use the wildcard to search for all available countries in the path. 
#returns an edsurvey.data.frame.list
timss.3 <- readTIMSS(path = "C:/EdSurveyData/TIMSS/2015", 
                     countries = "*", 
                     gradeLvl = 4)

#specify multiple paths if wishing to read in multiple years.
#returns an edsurvey.data.frame.list
timss.4 <- readTIMSS(path = c("C:/EdSurveyData/TIMSS/2015", 
                              "C:/EdSurveyData/TIMSS/2011"), 
                     countries = c("usa", "swe"),
                     gradeLvl = 4)
```

## TIMSS Advanced: Trends in International Mathematics and Science Study

TIMSS Advanced study is a global study that focuses on target populations of secondary school students in their final year, targeting their progress in advanced mathematics and advanced physics. The first study was conducted in 1995, with varying release years of public-use datasets from 1995, 2008, and 2015. The studies were conducted in conjunction with the [Boston College Lynch School of Education](https://timssandpirls.bc.edu/) and [IEA](https://www.iea.nl). In addition to the student assessments and home questionnaires, the data includes a school questionnaire and a teacher-level questionnaires for both the math and physics datasets.

The `downloadTIMSSAdv` function downloads and unzips the data hosted by the [Boston College TIMSS and PIRLS Database](https://timssandpirls.bc.edu/) for the following years: 1995, 2008, and 2015.  The same data also can be found and manually downloaded from the [IEA Data Repository](https://www.iea.nl/data-tools/repository/timssadvanced).  The required data format used by the `readTIMSSAdv` function is the SPSS (.sav) file format version.

Before beginning to analyze TIMSS Advanced data, be sure to read the published user guides and documentation provided by Boston College and IEA to familiarize yourself with the study and apply their guidance for analysis.  The user guide also identifies the ISO three-digit country codes that will be used as arguments for the `readTIMSSAdv` function to read in specific countries.  The three-digit ISO country codes also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3). TIMSS Advanced data include other jurisdictions and subgroups that are not countries, and the published TIMSS Advanced documentation includes the specific codes needed if you wish to analyze those as well. The `readTIMSSAdv` function also supports a wildcard character of `*` for the `countries` parameter, which will scan the specified `path` directories for all available countries.

When a `readTIMSSAdv` call is first used to read in the data, it will process the data to prepare it for the `EdSurvey` package on the first read call. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer initially. The preparation involves parsing the SPSS (.sav) files to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a fixed-width (.txt) data file.  By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

An `edsurvey.data.frame` of TIMSS data will handle all the necessary merging/linking of the school- and teacher-level data behind the scenes for the user, based on the variables requested in a function.  Specify which subject you wish to analyze using the `subject` argument to select either `math` or `physics` for analysis.

### Obtaining TIMSS Advanced Data

```r
#obtain the data to analyze for both 2008 and 2015 study years
downloadTIMSSAdv(root = "C:/EdSurveyData", years = c(2008, 2015), 
                 cache = FALSE, verbose = TRUE)

#if you wish to prepare to analyze all countries to have them ready for analysis,
#set the cache argument to TRUE (cache = TRUE).  Be prepared that this may take some time.
#setting the verbose argument to TRUE will keep you informed of the progress in the console.
downloadTIMSSAdv(root = "C:/EdSurveyData", years = c(2008, 2015),
                 cache = TRUE, verbose = TRUE)

#for silent output with no message output, set the verbose argument to FALSE (verbose = FALSE).
#setting verbose to FALSE is not recommended if cache is set to TRUE, 
#because you won't see the progress.
downloadTIMSSAdv(root = "C:/EdSurveyData", years = c(2008, 2015),
                 cache = FALSE, verbose = FALSE)
```

### Reading TIMSS Advanced Data

```r
#reading in a single country for a single year for the 'math' subject data
#returns a single edsurvey.data.frame
timssadv.1 <- readTIMSSAdv(path = "C:/EdSurveyData/TIMSSAdv/2015",
                           countries = "usa", subject = "math")

#reading in multiple countries for a single year
#returns an edsurvey.data.frame.list
timssadv.2 <- readTIMSSAdv(path = "C:/EdSurveyData/TIMSSAdv/2015",
                           countries = c("fra", "ita", "svn"),
                           subject = "physics")

#use the wildcard to search for all available countries in the path. 
#returns edsurvey.data.frame.list
timssadv.3 <- readTIMSSAdv(path = "C:/EdSurveyData/TIMSSAdv/2015",
                           countries = "*",
                           subject = "math")

#specify multiple paths if wishing to read in multiple years.
#returns an edsurvey.data.frame.list
timssadv.4 <- readTIMSSAdv(path = c("C:/EdSurveyData/TIMSSAdv/2015", 
                                    "C:/EdSurveyData/TIMSSAdv/2008"),
                           countries = c("nor", "swe"),
                           subject = "physics")
```

## PIAAC: Program for the International Assessment of Adult Competencies

PIAAC is a global study that focuseson assessing adult skill competency. The study had one cycle with three data collection rounds.  The first round was conducted in 2011--2012 with 24 countries. The second round was conducted in 2014--2015 with nine countries.  The third round was conducted in 2017 with six countries.  Only the United States had two rounds of collection (round 1 and round 3).  The study was conducted by the Organization for Economic Co-operation and Development (OECD), and further study information can be found on the [PIAAC website](https://www.oecd.org/skills/piaac/).

The `downloadPIAAC` function downloads and unzips the data hosted by the OECD for cycle one of the PIAAC study. The same data also can be found and manually downloaded from the [PIAAC website](https://www.oecd.org/skills/piaac/data/).  The required data format used by the `readPIAAC` function is their comma seperated values (.csv) file format version.  In addition, the `readPIAAC` function requires the provided Microsoft Excel International Codebook file to gather necessary details about the files and variables.

Before beginning to analyze PIAAC data, be sure to read the published user guides and documentation provided by OECD to familiarize yourself with the study and to apply their guidance for analysis. The user guide identifies the ISO three-digit country codes that will be used as arguments for the `readPIAAC` function to read in specific countries.  The three-digit ISO country codes also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3). The `readPIAAC` function also supports a wildcard character of `*` for the `countries` parameter, which will scan the specified `path` directories for all available countries.

When a `readPIAAC` call is first used to read in the data, it will process the data to prepare it for `EdSurvey` on the first read call. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer initially. The preparation involves parsing the CSV (.csv) files and codebook to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a CSV (.txt) data file for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

### Obtaining PIAAC Data

```r
#obtain the data to analyze cycle 1 data.
downloadPIAAC(root = "C:/EdSurveyData", cycle = 1, cache = FALSE, verbose = TRUE)

#if you wish to prepare to analyze all countries to have them ready for analysis,
#set the cache argument to TRUE (cache = TRUE).  Be prepared that this may take some time.
#setting the verbose argument to TRUE will keep you informed of the progress in the console
downloadPIAAC(root = "C:/EdSurveyData", cycle = 1, cache = TRUE, verbose = TRUE)

#for silent output with no message output, set the verbose argument 
#to FALSE (verbose = FALSE).
#setting verbose to FALSE is not recommended if cache is set to TRUE, 
#because you won't see the progress
downloadPIAAC(root = "C:/EdSurveyData", cycle = 1, cache = FALSE, verbose = FALSE)
```

### Reading PIAAC Data

```r
#reading in a single country
#returns a single edsurvey.data.frame
piaac.1 <- readPIAAC(path = "C:/EdSurveyData/PIAAC/Cycle 1/", countries = "pol")

#reading in multiple countries
#returns an edsurvey.data.frame.list
piaac.2 <- readPIAAC(path = "C:/EdSurveyData/PIAAC/Cycle 1/", 
                     countries = c("pol", "ltu", "tur"))

#use the wildcard to search for all available countries in the path. 
#returns edsurvey.data.frame.list
piaac.3 <- readPIAAC(path = "C:/EdSurveyData/PIAAC/Cycle 1/", countries = "*")

#setting verbose to FALSE (verbose = FALSE) suppresses console message output.
#returns an edsurvey.data.frame.list
piaac.4 <- readPIAAC(path = "C:/EdSurveyData/PIAAC/Cycle 1/", 
                     countries = "*", verbose = FALSE)
```

## PIRLS and ePIRLS: Progress in International Reading Literacy Study

### PIRLS

PIRLS study is a global study that focuses on a target population of Grade 4 students. The study began in 2001 and has release cycles every 5 years containing public-use datasets from 2001, 2006, 2011, and 2016, released in conjunction with the [Boston College Lynch School of Education](https://timssandpirls.bc.edu/) and the [IEA](https://www.iea.nl). In addition to the student assessments, the dataset includes teacher, school, and home questionnaires for Grade 4.

The `downloadPIRLS` function downloads and unzips the data hosted by the [Boston College TIMSS and PIRLS Database](https://timssandpirls.bc.edu/) for the following years: 2001, 2006, 2011, and 2016. The same data also can be found and manually downloaded from [IEA Data Repository](https://www.iea.nl/index.php/data-tools/repository/pirls).  The required data format used by the `readPIRLS` function is the SPSS (.sav) file format version.

Before beginning to analyze PIRLS data, be sure to read the published user guides and documentation provided by Boston College and IEA to familiarize yourself with the study, and apply their guidance for analysis. The user guides also identify the ISO three-digit country codes that will be used as arguments for the `readPIRLS` function to read in specific countries.  The three-digit ISO country codes also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3). PIRLS data include other jurisdictions and subgroups that are not countries, and the published PIRLS documentation will include the specific codes needed if you wish to analyze those as well.  The `readPIRLS` function also supports a wildcard character of `*` for the `countries` parameter, which will scan the specified `path` directories for all available countries.

When a `readPIRLS` call is first used to read in the data, it will process the data to prepare it for `EdSurvey` on the first read call. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer initially. The preparation involves parsing the SPSS (.sav) files to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a fixed-width (.txt) data file. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

An `edsurvey.data.frame` of PIRLS data will handle all the necessary merging/linking of the school- and teacher-level data behind the scenes for the user, based on the variables requested in a function.

In 2016, countries with less-developed education systems had the opportunity to participate in PIRLS Literacy, which included passages and items of lower difficulty.  PIRLS Literacy data are automatically included for `readPIRLS` when the 2016 dataset is specified.

#### Obtaining PIRLS Data

```r
#obtain the data to analyze for both 2011 and 2016 study years
downloadPIRLS(root = "C:/EdSurveyData", years = c(2011, 2016), 
              cache = FALSE, verbose = TRUE)

#if you wish to prepare to analyze all countries
#to have them ready for analysis,
#set the cache argument to TRUE (cache = TRUE).  
#Be prepared that this may take some time.
#setting the verbose argument to TRUE will keep you informed 
#of the progress in the console.
downloadPIRLS(root = "C:/EdSurveyData", years = c(2011, 2016), 
              cache = TRUE, verbose = TRUE)

#for silent output with no message output, set the verbose 
#argument to FALSE (verbose = FALSE).
#setting verbose to FALSE is not recommended if cache is set to TRUE, 
#because you won't see the progress.
downloadPIRLS(root = "C:/EdSurveyData", years = c(2011, 2016),
              cache = FALSE, verbose = FALSE)
```

#### Reading PIRLS Data

```r
#reading in a single country for a single year
pirls.1 <- readPIRLS(path = "C:/EdSurveyData/PIRLS/2016", countries = "usa")

#reading in multiple countries for a single year
#returns an edsurvey.data.frame.list
pirls.2 <- readPIRLS(path = "C:/EdSurveyData/PIRLS/2016",
                     countries = c("fin", "swe", "nor"))

#use the wildcard to search for all available countries in the path. 
#returns edsurvey.data.frame.list
pirls.3 <- readPIRLS(path = "C:/EdSurveyData/PIRLS/2016", 
                     countries = "*")

#specify multiple paths if wishing to read in multiple years.
#returns an edsurvey.data.frame.list
pirls.4 <- readPIRLS(path = c("C:/EdSurveyData/PIRLS/2016", 
                              "C:/EdSurveyData/PIRLS/2011"), 
                     countries = c("usa", "swe"))
```

### ePIRLS

ePIRLS is a computer-based extension of the PIRLS study designed to assess students’ comprehension of online information. The ePIRLS study release coincided with the 2016 PIRLS and has only one public-use dataset available for 2016. ePIRLS was released in conjunction with the [Boston College Lynch School of Education](https://timssandpirls.bc.edu/) and the [IEA](https://www.iea.nl). In addition to the student assessments, the dataset includes teacher, school, and home questionnaires for Grade 4.

The `download_ePIRLS` function downloads and unzips the data hosted by the [Boston College TIMSS and PIRLS Database](https://timssandpirls.bc.edu/) for 2016 only. The same data also can be found and manually downloaded from the [IEA Data Repository](https://www.iea.nl/index.php/data-tools/repository/pirls).  The required data format used by the `readPIRLS` function is the SPSS (.sav) file format version.

Before beginning to analyze ePIRLS data, be sure to read the published user guides and documentation provided by Boston College and IEA to familiarize yourself with the study and apply their guidance for analysis. The user guide identifies the ISO three-digit country codes that will be used as arguments for the `read_ePIRLS` function to read in specific countries.  The three-digit ISO country codes also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3). ePIRLS data includes other jurisdictions and subgroups that are not countries, and the published ePIRLS documentation will include the specific codes needed if you wish to analyze those as well.  The `read_ePIRLS` function also supports a wildcard character of `*` for the `countries` parameter, which will scan the specified `path` directories for all available countries.

When a `read_ePIRLS` call is first used to read in the data, it will process the data to prepare it for `EdSurvey` on the first read call. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer initially. The preparation involves parsing the SPSS (.sav) files to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a fixed-width (.txt) data file. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

An `edsurvey.data.frame` of ePIRLS data will handle all the necessary merging/linking of the school- and teacher-level data behind the scenes for the user, based on the variables requested in a function.

#### Obtaining ePIRLS Data

```r
#obtain the data to analyze 2016 study year
download_ePIRLS(root = "C:/EdSurveyData", years = 2016, cache = FALSE, verbose = TRUE)

#if you wish to prepare to analyze all countries to have them ready for analysis,
#set the cache argument to TRUE (cache = TRUE).  Be prepared that this may take some time.
#setting the verbose argument to TRUE will keep you informed of the progress in the console.
download_ePIRLS(root = "C:/EdSurveyData", years = 2016, cache = TRUE, verbose = TRUE)

#for silent output with no message output 
#set the verbose argument to FALSE (verbose = FALSE).
#setting verbose to FALSE is not recommended if cache is set to TRUE, 
#because you won't see the progress.
download_ePIRLS(root = "C:/EdSurveyData", years = 2016, cache = FALSE, verbose = FALSE)
```

#### Reading ePIRLS Data

```r
#reading in a single country for a single year
#returns a single edsurvey.data.frame
epirls.1 <- read_ePIRLS(path = "C:/EdSurveyData/ePIRLS/2016", countries = "irl")

#reading in multiple countries for a single year
#returns an edsurvey.data.frame.list
epirls.2 <- read_ePIRLS(path = "C:/EdSurveyData/ePIRLS/2016",
                        countries = c("twn", "sgp"))

#use the wildcard to search for all available countries in the path. 
#returns edsurvey.data.frame.list
epirls.3 <- read_ePIRLS(path = "C:/EdSurveyData/ePIRLS/2016", 
                        countries = "*")
```

## PISA: Programme for International Student Assessment

PISA is a global study that focuses on the progress of 15-year-old students in reading, mathematics, and science. The study currently has seven data collection years: 2000, 2003, 2006, 2009, 2012, 2015, and 2018. The study is conducted by the OECD, and further study information can be found on the [PISA website](https://www.oecd.org/pisa/).

The `readPISA` function has an argument of `database`, which has a default value of `int` to specify the international database.  For PISA 2012, there is also a `cba` (computer-based database) and a `fin` (financial literacy) database available for both 2012 and 2018. For PISA 2015, the financial literacy data are included within the `int` database.

The `readPISA` function also has a `cognitive` argument that accepts values of `none`, `score` (the default), and `response` that are applicable for the years 2006, 2009, and 2012. See the `?readPISA` documentation for additional details.

The `downloadPISA` function downloads the PISA international data files from the OECD data products. For the years 2000 through 2012, the data files consist of fixed-width (.txt) data files accompanied by SPSS script (.sps) syntax files used to parse the data files.  For the 2015 and 2018 datasets, the data format required is SPSS data (.sav) files.

Before beginning to analyze PISA data, be sure to read the studies published user guides and documentation provided by OECD to familiarize yourself with the study and apply their guidance for analysis. In the user guides, it also identifies the ISO three-digit country codes that will be used as arguments for the `readPISA` function to read in specific countries.  The three-digit ISO country codes also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3). The `readPISA` function also supports a wildcard character of `*` for the `countries` parameter, which will scan the specified `path` directories for all available countries.

For the PISA 2000 study, the study weights are subject specific. Each weight has different adjustment factors for reading, mathematics, and science based on the original subject source file.  For example, the `w_fstuwt_read` weight is associated with the reading subject data file.  Special case must be used to select the correct weight based on your specific analysis.  See the OECD documentation for further details.  Use the `showWeights` function to see all three student-level subject weights:

* w_fstuwt_read = Reading (default)
* w_fstuwt_scie = Science
* w_fstuwt_math = Mathematics

When a `readPISA` call is first used to read in the data, it will process the data to prepare it for the `EdSurvey` package on the first read call. This step generally takes a few minutes for one country. However, if you are analyzing all countries at once, the processing can take much longer initially.  The preparation involves parsing the SPSS data (.sav) (or fixed-width data files depending on year) and codebook to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a fixed-width (.txt) data file for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

### Obtaining PISA Data

```r
#download the PISA data for 2018
downloadPISA(root = "C:/EdSurveyData/", years = 2018)

#download both 2018 and 2015 data
downloadPISA(root = "C:/EdSurveyData/", years = c(2015, 2018))

#setting cache = TRUE will process all the PISA data and have it ready for EdSurvey
#this can take some time for all countries
downloadPISA(root = "C:/EdSurveyData/", years = 2018, cache = TRUE)
```

### Reading PISA Data

```r
#reading in a single country with default values specified
#returns a single edsurvey.data.frame
pisa.1 <- readPISA(path = "C:/EdSurveyData/PISA/2018", database = "INT", 
                   countries = "nzl", cognitive = "score")

#reading in a two countries
#returns edsurvey.data.frame.list
pisa.2 <- readPISA(path = "C:/EdSurveyData/PISA/2018", database = "INT",
                   countries = c("nzl", "aus"), cognitive = "score")

#use the wildcard to search for all available countries in the path. 
#returns edsurvey.data.frame.list
pisa.3 <- readPISA(path = "C:/EdSurveyData/PISA/2015", database = "INT",
                   countries = "*", cognitive = "score")

#reading in PISA 2012 CBA database specifying cognitive = "none"
#returns an edsurvey.data.frame.list
pisa.4 <- readPISA(path = "C:/EdSurveyData/PISA/2012", database = "CBA",
                   countries = c("bel", "bra"), cognitive = "none")

#can set multiple paths to read in many years of data
pisa.5 <- readPISA(path = c("C:/EdSurveyData/PISA/2009",
                            "C:/EdSurveyData/PISA/2012",
                            "C:/EdSurveyData/PISA/2015",
                            "C:/EdSurveyData/PISA/2018"),
                   database = "INT", countries = "usa", cognitive = "score")

#setting verbose = FALSE suppresses console message output
pisa.6 <- readPISA(path = "C:/EdSurveyData/PISA/2018", database = "INT", 
                   countries = "usa", cognitive = "score", verbose = FALSE)
```

## PISA YAFS: Programme for International Student Assessment Young Adult Follow-up Study

PISA YAFS is a U.S. study that concluded in 2016. Its purpose was to follow up with the participants of the PISA 2012 U.S. cohort to help reevaluate their skills in both mathematics and reading as they transition into college, workforce, and adulthood. The study used an online study instrument designed by OECD for the PIAAC study to gather additional information on computer and Internet usage.

`EdSurvey` supports analyzing the PISA YAFS data as a stand-alone dataset and provides the ability to link the U.S. PISA 2012 data with the PISA YAFS data for more advanced analysis. An example of how to do this merge is provided here and can be found in the `readPISA_YAFS` documentation.

The `downloadPISA_YAFS` function provides instructions of how to download the PISA YAFS data files and documentation.

The `readPISA_YAFS` function requires that the data file be a fixed-width (.dat) file and requires the SPSS script file (.sps) to parse the data file. The `esdf_PISA2012_USA` parameter also can be specified, pointing to the `edsurvey.data.frame` object for the U.S. PISA 2012 data to return a merged `edsurvey.data.frame`.

### Obtaining PISA YAFS Data

```r
#View instructions for obtaining PISA YAFS data
downloadPISA_YAFS(years = 2016)
```

### Reading PISA YAFS Data

```r
#Return an edsurvey.data.frame for only the PISA YAFS dataset.
#Either omit or set the esdf_PISA2012_USA to a NULL value.
yafs <- readPISA_YAFS(datPath = "C:/EdSurveyData/PISA YAFS/2016/PISA_YAFS2016_Data.dat",
                      spsPath = "C:/EdSurveyData/PISA YAFS/2016/PISA_YAFS2016_SPSS.sps",
                      esdf_PISA2012_USA = NULL)

```

### Link PISA YAFS Data to PISA 2012

```r
#If wanting to analyze the PISA YAFS dataset with the PISA 2012 
#U.S dataset, it should be read in first to an edsurvey.data.frame.
#Then pass the resulting edsurvey.data.frame as a parameter for the
#esdf_PISA2012_USA argument. No other edsurvey.data.frames are supported.
usa2012 <- readPISA("C:/EdSurveyData/PISA/2012", database = "INT", countries = "usa")

yafs <- readPISA_YAFS(datPath = "C:/EdSurveyData/PISA YAFS/2016/PISA_YAFS2016_Data.dat",
                      spsPath = "C:/EdSurveyData/PISA YAFS/2016/PISA_YAFS2016_SPSS.sps",
                      esdf_PISA2012_USA = usa2012)
```

## TALIS: Teaching and Learning International Survey

TALIS survey is a global study that focuses on school teachers and leaders about working conditions and learning environments at their schools. The study currently has three data collection years: 2008, 2013, and 2018. The study is conducted by OECD and further study information can be found on the [TALIS website](http://www.oecd.org/education/talis/). 

The TALIS datasets have three `isced` levels of `a`, `b`, and `c`.  The `a` level corresponds to the `Primary Level`.  The `b` level corresponds to the `Lower Secondary Level`, and the `c` level is for `Upper Secondary Level`.  Not all countries may have data at all `isced` levels. In addition, a `dataSet` argument allows you to specify `teacher` (the default) or `school` depending on what specific data you wish to analyze. The `teacher` level includes the `school` level data and handles it automatically, but the base unit of analysis is the `teacher`. Setting the `dataSet` argument to `school` causes it to ignore the `teacher` data and has the `school` data as the base unit for analysis.

The `downloadTALIS` function provides instructions for downloading the datasets from OECD. The same data also can be found and manually downloaded from the [TALIS website](https://www.oecd.org/skills/talis/) in their data section. The required data format used by the `readTALIS` function is the SPSS data (.sav) file format version.

Before beginning to analyze TALIS data, be sure to read the published user guides and documentation provided by OECD to familiarize yourself with the study and apply their guidance for analysis. In the user guides, it also identifies the ISO three-digit country codes that will be used as arguments for the `readTALIS` function to read in specific countries.  The three-digit ISO country codes also can be found using various online resources, including [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3). The `readTALIS` function also supports a wildcard character of `*` for the `countries` parameter, which will scan the specified `path` directories for all available countries.

When a `readTALIS` call is first used to read in the data, it will process the data to prepare it for `EdSurvey` on the first read call. This step generally takes a few minutes for one country. However, if you're analyzing all countries at once, the processing can take much longer initially.  The preparation involves parsing the SPSS data (.sav) files and codebook to gather all the relevant data and variable information, merging all necessary files, and then outputting it to a fixed-width (.txt) data file for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

### Obtaining TALIS Data

```r
#view instructions for obtaining TALIS 2008 data
downloadTALIS(years = 2008)

#view instructions for obtaining TALIS 2013 data
downloadTALIS(years = 2013)
```

### Reading TALIS Data

```r
#reading in a single country for isced='b' and dataLevel='teacher'
#returns a single edsurvey.data.frame
talis.1 <- readTALIS(path = "C:/EdSurveyData/TALIS/2008", 
                     countries = "bra", isced = "b", 
                     dataLevel = "teacher")

#reading in a two countries for isced='c' and dataLevel='school'
#returns edsurvey.data.frame.list
talis.2 <- readTALIS(path = "C:/EdSurveyData/TALIS/2013", 
                     countries = c("aus", "mex"), isced = "c", 
                     dataLevel = "school")

#use the wildcard to search for all available countries in the path. 
#returns edsurvey.data.frame.list
talis.3 <- readTALIS(path = "C:/EdSurveyData/TALIS/2013", 
                     countries = "*", isced = "a", 
                     dataLevel = "teacher")

#reading in countries from multiple file paths
#returns an edsurvey.data.frame.list
talis.4 <- readTALIS(path = c("C:/EdSurveyData/TALIS/2008", 
                              "C:/EdSurveyData/TALIS/2013"),
                     countries = c("esp", "ita"), isced = "b", 
                     dataLevel = "teacher")

#isced defaults to a value of 'b' and dataLevel defaults to 'teacher'.
#setting verbose = FALSE suppresses console message output.
talis.5 <- readTALIS(path = "C:/EdSurveyData/TALIS/2013", 
                     countries = "*", verbose = FALSE)
```

## NHES: National Household Education Surveys

The NHES program is a series of surveys conducted in the United States that focus on education topics for children and families. Topics include adult education, civic involvement, early childhood program participation, and parent and family involvement in education. The surveys are conducted every few years, and the topics covered vary by year. Detailed information about the NHES program can be found on the [NHES website](https://nces.ed.gov/nhes/). The NHES was conducted in 1991, 1993, 1995, 1996, 1999, 2001, 2003, 2005, 2007, 2012, 2016, and 2019.

The `downloadNHES` function provides instructions for downloading the datasets from the [NCES Online Codebook](https://nces.ed.gov/OnlineCodebook/). The required data format used by the `readNHES` function is the SPSS data (.sav) file format version.  The `readNHES` function is designed to work with the Online Codebook public-use files. Data obtained from other sources will require the SPSS format and will generally require setting the `surveyCode` parameter in the function. Users can use the `getNHES_SurveyInfo` function to retrieve the survey information/codes as a `data.frame` and the `viewNHES_SurveyCodes` function to print the survey codes and descriptions to the console.

Before beginning to analyze NHES data, be sure to read the published user guides and documentation provided by NCES to familiarize yourself with the study and apply their guidance for analysis found on the [NHES website](https://nces.ed.gov/nhes/).  

When a `readNHES` call is first run, it will process the data to prepare it for `EdSurvey` by preparing a cached version of the data. This step generally takes a few minutes for one survey. However, if you are analyzing all the survey data files at once, the processing can take much longer. The cache preparation involves parsing the SPSS data (.sav) files and codebook to gather all the relevant data and variable information, and then outputting it to a fixed-width (.txt) data file for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

### Obtaining NHES Data

```r
#view instructions for obtaining NHES data
downloadNHES()
```

### Reading NHES Data

```r
#reading in a single file for Early Childhood Program Participation
#file obtained from Online Codebook, so surveyCode = "auto" works (the default)
#returns a single edsurvey.data.frame
nhes.1 <- readNHES(savFiles = "C:/EdSurveyData/NHES/2019/nhes_19_ecpp_v1_0.sav", 
                   surveyCode = "auto")

#reading in a two files across two years (2019 and 2016 ECCP)
#returns edsurvey.data.frame.list
importFiles <- c("C:/EdSurveyData/NHES/2019/nhes_19_ecpp_v1_0.sav",
                 "C:/EdSurveyData/NHES/2016/nhes_16_ecpp_v1_0.sav")
nhes.2 <- readNHES(savFiles = importFiles, 
                   surveyCode = "auto")

#setting the 'surveyCode' parameter explicitly if 'auto' fails.
#returns edsurvey.data.frame
viewNHES_SurveyCodes() 
nhes.3 <- readNHES(savFiles = "C:/EdSurveyData/NHES/2019/nhes_19_ecpp_v1_0.sav", 
                   surveyCode = "ECPP_2019")

#reading multiple files with explicit 'surveyCode' parameter
#returns an edsurvey.data.frame.list
importFiles <- c("C:/EdSurveyData/NHES/2019/nhes_19_ecpp_v1_0.sav",
                 "C:/EdSurveyData/NHES/2016/nhes_16_ecpp_v1_0.sav")
nhes.4 <- readNHES(savFiles = importFiles,
                   surveyCode = c("ECPP_2019", "ECPP_2016"))

```

## SSOCS: School Survey on Crime and Safety

The SSOCS is a set of surveys conducted in the United States at the school level involving crime and safety topics. The surveys are conducted every few years.  Detailed information about the SSOCS program can be found on the [SSOCS website](https://nces.ed.gov/surveys/ssocs/index.asp). The SSOCS was conducted in 2000 (1999--2000), 2004 (2003--2004), 2006 (2005--2006), 2008 (2007--2008), 2010 (2009--2010), 2016 (2015--2016), and 2018 (2017--2018).

The `downloadSSOCS` function provides instructions for downloading the datasets from the [SSOCS Data Product webpage](https://nces.ed.gov/surveys/ssocs/data_products.asp). The required data format used by the `readSSOCS` function is the SAS data (.sas7bdat) file format version.  The `readSSOCS` function is designed to work with public-use files, and `EdSurvey` stores required meta data for the SSOCS data within the package based on the `year` parameter.

Before beginning to analyze using SSOCS data, be sure to read the published user guides and documentation provided by NCES to familiarize yourself with the study and apply their guidance for analysis found on the [SSOCS website](https://nces.ed.gov/surveys/ssocs/index.asp).  

When a `readSSOCS` call is first run, it will process the data to prepare it for `EdSurvey` by preparing a cached version of the data. This step generally takes a few minutes for one survey. However, if you are analyzing all the survey data files at once, the processing can take much longer.  The preparation involves parsing the SAS data (.sas7bdat) files to gather all the relevant data and variable information, and then outputting it to a fixed-width (.txt) data file for use with `EdSurvey`. By using this data caching technique, `EdSurvey` can load required data on demand, and keeps a minimal memory footprint.

### Obtaining SSOCS Data

```r
#view instructions for obtaining SSOCS data
downloadSSOCS()
```

### Reading SSOCS Data

```r
#reading in a single file for 2018 survey
#returns a single edsurvey.data.frame
ssocs.1 <- readSSOCS(sasDataFiles = "C:/EdSurveyData/SSOCS/2018/pu_ssocs18.sas7bdat", 
                     years = "2018")

#reading in a two files across two years (2018 and 2016)
#returns edsurvey.data.frame.list
importFiles <- c("C:/EdSurveyData/SSOCS/2018/pu_ssocs18.sas7bdat",
                 "C:/EdSurveyData/SSOCS/2016/pu_ssocs16.sas7bdat")
ssocs.2 <- readSSOCS(sasDataFiles = importFiles, 
                     years = c("2018", "2016"))

#setting the 'verbose = FALSE' parameter for silent output.
#returns edsurvey.data.frame
ssocs.3 <- readSSOCS(sasDataFiles = "C:/EdSurveyData/SSOCS/2018/pu_ssocs18.sas7bdat", 
                     years = "2018",
                     verbose = FALSE)
```
