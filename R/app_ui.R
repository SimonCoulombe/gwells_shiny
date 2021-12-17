#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  suppressPackageStartupMessages({
    library(DBI)
    library(RPostgres)
  })
  
  Sys.setenv(TZ="America/Vancouver")
  BCGOV_DB <- Sys.getenv("BCGOV_DB")
  BCGOV_HOST <- Sys.getenv("BCGOV_HOST")
  BCGOV_USR <- Sys.getenv("BCGOV_USR")
  BCGOV_PWD <- Sys.getenv("BCGOV_PWD")
  if (is.null(BCGOV_DB) || is.null(BCGOV_HOST)|| is.null(BCGOV_USR) || is.null(BCGOV_PWD)) stop("go away")
  
  con1 <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = BCGOV_DB,
    host = BCGOV_HOST,
    user = BCGOV_USR,
    password= BCGOV_PWD
  )
  
  
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
      verbatimTextOutput("summary"),
      tableOutput("table")
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'gwells_shiny'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

