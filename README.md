# EdSurvey Book

## Initialization

1. Install Packages

```
install.packages(c("blogdown", "servr", "bookdown", "kableExtra"))
```

2. Add `.Rprofile` to `\EdSurveyVignettes\EdSurvey_A_Users_Guide` directory to bring in the `edsurveyHome` variable that points to data directory, as used in development of the `EdSurvey` package. Restart your R sesssion to load in these values into local environment (they should display in the top right _Environments_ panel.)

## Contribution

To get started, open up the `EdSurvey_A_Users_Guide.Rproj` file or set the EdSurvey_A_Users_Guide pathway as your R working directory. Load the necessary libraries:

```
library(servr)
library(blogdown)
library(bookdown)
library(kableExtra)
```

To locally host and compile the _full book_

`bookdown::serve_book()`

Note that this will update all `.Rmd` files in your local directory and should be used only if an update of the full book is desired. This will also track any changes to the `Rmd` files and knitr them to html.

<blockquote>The server will listen to changes in the book root directory: whenever you modify any files in the book directory, serve_book() can detect the changes, recompile the Rmd files, and refresh the web browser automatically.</blockquote>

To locally host and make edits to just one chapter, run:

```
servr::httw(dir = "_book") # locally host the book location
bookdown:::preview_chapter("02-installion.Rmd") # Knit HTML of selected chapter - be sure to replace the name of the `Rmd` with your chapter

```

This will start a local server of the full book but that updates only as changes are made to respective `Rmd` files. Note that other supplmentary files that any changes may affect, such as the References page, won't be updated by building a single chapter. More information about these functions are here: https://bookdown.org/yihui/bookdown/editing.html

### Bookdown Resources

- https://github.com/rstudio/bookdown
- https://bookdown.org/yihui/bookdown/get-started.html

### Creating the epub

1. Comment out the code block referencing the cover [here](https://github.com/American-Institutes-for-Research/EdSurveyVignettes/blob/master/EdSurvey_A_Users_Guide/index.Rmd#L26-L28)

2. `bookdown::render_book("index.Rmd", bookdown::epub_book())`

