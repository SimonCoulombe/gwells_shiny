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
  
  z <- prepare_all_data(con1)
  
  message("unhiding waiter")
  
  waiter_hide() # hide the waiter
  
  selected_data_and_ranges <- mod_filterDataInput_server("filterDataInput_ui_1",z)
  
  message("class selected_data_and_ranges:",class(selected_data_and_ranges))
  mod_table1Output_server("table1Output_ui_1",
                          df = selected_data_and_ranges$df,
                           date_added_min = selected_data_and_ranges$date_added_min,
                           date_added_max = selected_data_and_ranges$date_added_max,
                           wtn_min = selected_data_and_ranges$wtn_min,
                           wtn_max = selected_data_and_ranges$wtn_max
                          )
}

