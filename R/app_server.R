#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  Sys.setenv(TZ="America/Vancouver")
  
  waiter_show( # show the waiter
    html = spin_fading_circles() # use a spinner
  )
  
  suppressPackageStartupMessages({
    library(DBI)
    library(RPostgres)
    library(dplyr)
    library(stringr)
  })
  
  BCGOV_DB <- Sys.getenv("BCGOV_DB")
  BCGOV_HOST <- Sys.getenv("BCGOV_HOST")
  BCGOV_USR <- Sys.getenv("BCGOV_USR")
  BCGOV_PWD <- Sys.getenv("BCGOV_PWD")
  if (is.null(BCGOV_DB) || is.null(BCGOV_HOST)|| is.null(BCGOV_USR) || is.null(BCGOV_PWD)) stop("go away")
  
  con1 <- DBI::dbConnect(
    #RPostgreSQL::PostgreSQL(),
    RPostgres::Postgres(),
    dbname = Sys.getenv("BCGOV_DB"),
    host = Sys.getenv("BCGOV_HOST"),
    user = Sys.getenv("BCGOV_USR"),
    password=Sys.getenv("BCGOV_PWD")
  )
  
  prepared_gwells <- prepare_all_data(con1)
  
  message("unhiding waiter")
  
  waiter_hide() # hide the waiter
  
  data <- mod_filterDataInput_server("filterDataInput_ui_1",prepared_gwells)
  mod_table1Output_server(
    "table1Output_ui_1",
    d = data
  )
}

