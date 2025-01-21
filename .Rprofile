if(!exists("edsurveyHome")) {
  edsurveyHome <- "C:/EdSurveyData/"
  if("pbailey" %in% Sys.getenv("USER")) {
    edsurveyHome <- "~/Documents/EdSurveyData"
  } else if("syavuz" %in% Sys.getenv("USER")) {
    edsurveyHome <- "~/EdSurveyData/"
  } else if("bwebb" %in% Sys.getenv("USERNAME")) {
    edsurveyHome <- "P:/EdSurveyData/"
  }
}

options(repos=structure(c(CRAN="https://cloud.r-project.org/")))
