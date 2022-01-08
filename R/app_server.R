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
  
  
  selected <- mod_filterData_server("filterData_ui_1",z)
  
  output$table2 <- DT::renderDataTable({selected() %>% head() })
  
  selected_data_and_ranges <- mod_filterData_server("filterData_ui_1",z)
  

  
  table1_title <- eventReactive(selected(),
  {
    paste0("table 1, from ", 
           input$date_range[1], 
           " to ", input$date_range[2], 
           " and well tag number from 
                        ",input$well_tag_number_range[1], 
           " to ", input$well_tag_number_range[2])
  })
  
  table1_data <- eventReactive(selected(),
    {
    message("generate table 1")
    selected() %>% 
      dplyr::filter(table1_flag >0 ) %>%
      dplyr::arrange(dplyr::desc(table1_flag), dplyr::desc(well_tag_number)) %>%
      dplyr::select(
        well_tag_number,table1_flag,  my_well_type, table1_missing_lat_long_flag, 
        table1_table1_missing__wdip_flag, table1_missing_finished_well_depth_flag, 
        table1_missing_person_responsible_flag, company_of_person_responsible) %>%
      #head(100) %>% 
      dplyr::select(
        well_tag_number,
        table1_flag, 
        my_well_type,
        table1_missing_lat_long_flag,
        table1_table1_missing__wdip_flag,
        table1_missing_finished_well_depth_flag,
        table1_missing_person_responsible_flag,
        company_of_person_responsible) %>%
      mutate(
        across(.cols = c("table1_missing_lat_long_flag", 
                         "table1_table1_missing__wdip_flag", 
                         "table1_missing_finished_well_depth_flag", 
                         "table1_missing_person_responsible_flag"),
               .fns = ~logical_to_character_icon(!as.logical(.x))
        )
      )
  })
  
  output$table1 <- DT::renderDataTable({
    message("render table 1")
    table1_data() %>% 
      DT::datatable(
        colnames = c("well tag number",
                     "problem count",
                     "well type",
                     "lat long",
                     "wdip",
                     "well depth",
                     "person responsible",
                     "company of person responsible"
        ),
        caption = table1_title(),
        #caption = "TABLE 1 CAPTION",
        rownames = FALSE, 
        escape = FALSE)
  })
}

