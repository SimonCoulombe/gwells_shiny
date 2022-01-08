#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    
    #fluidpage de exemple
    fluidPage(
      useWaiter(),
      
      tags$style(".glyphicon-ok-sign {color:#2b8ee5}
              .glyphicon-question-sign {color:#f4e107}
              .glyphicon-exclamation-sign {color:#e5413b}
              .glyphicon-flag, .glyphicon-trash {color:#28b728}"),
      
      fluidRow(
        column(12,mod_filterData_ui("filterData_ui_1"))

        
        #         column(4,
        #        shinyWidgets::numericRangeInput(
        #          inputId = "well_tag_number_range", 
        #          label = "Well tag number range:",
        #          value = c(1, 999999)
        #        )
        # ),
        # column(4,
        #        dateRangeInput(
        #          "date_range", "Date range:",
        #          start  =  Sys.Date()-13,
        #          end    =  Sys.Date(),
        #          min    = "2021-12-13",
        #          max    = Sys.Date()
        #        )
        # ),
        # column(4, actionButton("generate", "Generate tables and figures"))
      ),
      navbarPage(
        title = "text as wide as the logo", theme = "bcgov.css", 
        tabPanel(
          "Table 1", 
          sidebarLayout(
            sidebarPanel(
              width=2,
              helpText("helptext1"),
            ),    
            mainPanel(
              width=10,
              mod_table1Output_ui("table1Output_ui_1")
            )
          ),
          bc_template_footer
        )  
      )
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

