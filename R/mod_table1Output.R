#' table1Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_table1Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("table1"))
  )
}

#' table1Output Server Functions
#'
#' @noRd 
#mod_table1Output_server <- function(id,df, date_added_min, date_added_max, wtn_min, wtn_max){
mod_table1Output_server <- function(id,df){
  stopifnot(is.reactive(df))
  # stopifnot(is.reactive(date_added_min))
  # stopifnot(is.reactive(date_added_max))
  # stopifnot(is.reactive(wtn_min))
  # stopifnot(is.reactive(wtn_max))
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$table1 <- DT::renderDataTable({
      req(is.data.frame(df()))
      df() %>% 
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
        ) %>% 
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
          caption = "TABLE 1 CAPTION",
          rownames = FALSE,
          escape = FALSE
        )
    })
  })
}

## To be copied in the UI
# mod_table1Output_ui("table1Output_ui_1")

## To be copied in the server
# mod_table1Output_server("table1Output_ui_1")
