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
    
    
    # Your application UI logic 
    # fluidPage(
    #   selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
    #   verbatimTextOutput("summary"),
    #   tableOutput("table")
    # )
    
    #fluidpage de exemple
    fluidPage(
      #selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
      useWaiter(),
      
      tags$style(".glyphicon-ok-sign {color:#2b8ee5}
              .glyphicon-question-sign {color:#f4e107}
              .glyphicon-exclamation-sign {color:#e5413b}
              .glyphicon-flag, .glyphicon-trash {color:#28b728}"),
      
      fluidRow(
        column(4,
               shinyWidgets::numericRangeInput(
                 inputId = "well_tag_number_range", 
                 label = "Well tag number range:",
                 value = c(1, 999999)
               )
        ),
        column(4,
               dateRangeInput("date_range", "Date range:",
                              start  =  Sys.Date()-13,
                              end    =  Sys.Date(),
                              min    = "2021-12-13",
                              max    = Sys.Date()
               )
        ),
        column(4, actionButton("generate", "Generate tables and figures"))
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
              DT::dataTableOutput("table1")
            )
          ),
          bc_template_footer
        ),
        tabPanel(
          "2 image", 
          sidebarLayout(
            sidebarPanel(
              width = 2,
              helpText("help text2"),
              img(src = "www/Ecoprovinces_Title.png", height = 1861*1/5, width = 1993*1/5),
            ),    
            mainPanel(
              width = 10,
              #verbatimTextOutput("summary"),
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

