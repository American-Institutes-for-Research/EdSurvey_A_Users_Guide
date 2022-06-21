# EdSurvey Book

The GitHub repository for EdSurvey: A User's Guide

![EdSurvey: A User's Guide](https://github.com/American-Institutes-for-Research/EdSurvey_A_Users_Guide/blob/main/images/cover.png?raw=true)

## Initialization

1. Install Packages

```
install.packages(c("blogdown", "servr", "bookdown", "kableExtra", "downlit"))
```

2. Add `.Rprofile` to your local repository to bring in the `edsurveyHome` variable pointing to the data directory, as used in development of the `EdSurvey` package. This book includes `TIMSS` and `ECLS-K:2011` data in chapters 8 and 10, respectively, so contributions to those chapters require local data to reproduce. If you are unable to access this data locally, you can still contribute to other chapters by running `bookdown:::preview_chapter("chapter-name.Rmd")`. See the *Locally hosting/compiling the _just one_ chapter* section of the readme.

## Contribution

To get started, open up the `EdSurvey_A_Users_Guide.Rproj` file or set the `EdSurvey_A_Users_Guide` pathway as your R working directory. Ensure your R sesssion includes the `edsurveyHome` object that points to the data directory in your local environment (they should display in the top right _Environments_ panel.) Load the necessary libraries:

```
library(servr)
library(blogdown)
library(bookdown)
library(kableExtra)
```

### Locally hosting/compiling the _full_ book

`bookdown::serve_book()`

Note that this will update all `.Rmd` files in your local directory and should be used only if an update of the full book is desired. This will also track any changes to the `Rmd` files and knitr them to html.

<blockquote>The server will listen to changes in the book root directory: whenever you modify any files in the book directory, serve_book() can detect the changes, recompile the Rmd files, and refresh the web browser automatically.</blockquote>

### Locally hosting/compiling the _just one_ chapter

```
servr::httw(dir = "_book") # locally host the book location
bookdown:::preview_chapter("02-installation.Rmd") # Knit HTML of selected chapter - be sure to replace the name of the `Rmd` with your chapter

```

This will start a local server of the full book but that updates only as changes are made to a single `Rmd` file. Note that other supplmentary files that any changes may affect, such as the References page, won't be updated by building a single chapter. More information about these functions are here: https://bookdown.org/yihui/bookdown/editing.html

### Creating the epub

1. Comment out the code block referencing the cover [here](https://github.com/American-Institutes-for-Research/EdSurvey_A_Users_Guide/blob/main/index.Rmd#L26-L28)

2. `bookdown::render_book("index.Rmd", bookdown::epub_book())`

#### Diagnosing issues with the epub

I has success dianosing issues with the epub compilation using the [epubcheck](https://github.com/w3c/epubcheck) command line validator. Once initialized on your system run:

`epubcheck EdSurvey_A_Users_Guide.epub`

There are also GUIs available; see [the epubcheck GUI wiki](https://github.com/w3c/epubcheck/wiki/GUI). 

As a final check I ensured the epubs were functioning correctly by uploading to my Google Play Books account, but once it returns no errors (warnings are okay) using `epubcheck` it should be good to go.

### Bookdown Resources

- https://github.com/rstudio/bookdown
- https://bookdown.org/yihui/bookdown/get-started.html