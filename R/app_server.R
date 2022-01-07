#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  waiter_show( # show the waiter
    html = spin_fading_circles() # use a spinner
  )
  
  suppressPackageStartupMessages({
    library(DBI)
    library(RPostgres)
    library(dplyr)
    library(stringr)
  })
  
  Sys.setenv(TZ="America/Vancouver")
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
  
  waiter_hide() # hide the waiter
  
  x1 <- eventReactive(input$generate,{
    z %>%
      dplyr::filter(date_added >= input$date_range[1] & 
                      date_added <= input$date_range[2] &
                      well_tag_number >= input$well_tag_number_range[1] &
                      well_tag_number <= input$well_tag_number_range[2])
  })
  
  output$table1 <- DT::renderDataTable({
    table1 <- x1() %>% 
      dplyr::filter(table1_flag >0 ) %>%
      dplyr::arrange(dplyr::desc(table1_flag), dplyr::desc(well_tag_number)) %>%
      dplyr::select(
        well_tag_number,table1_flag,  my_well_type, table1_missing_lat_long_flag, 
        table1_table1_missing__wdip_flag, table1_missing_finished_well_depth_flag, 
        table1_missing_person_responsible_flag, company_of_person_responsible) 
    
    table1 %>%  
      head(100) %>% 
      dplyr::select(
        well_tag_number,
        problem_count = table1_flag, 
        my_well_type,
        missing_lat_lon = table1_missing_lat_long_flag,
        missing_finished_well_depth = table1_missing_finished_well_depth_flag,
        missing_person_responsible =  table1_missing_person_responsible_flag,
        company_of_person_responsible) %>% 
      DT::datatable(caption =glue::glue("table 1, from {input$daterange3[1]} to {input$daterange3[2]}"))
  })
  
  
}

