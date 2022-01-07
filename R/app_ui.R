#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  
  bc_template_footer <- column(
    width = 12,
    style = "background-color:#003366; border-top:2px solid #fcba19;",
    tags$footer(
      class="footer",
      tags$div(
        class="container", style="display:flex; justify-content:center; flex-direction:column; text-align:center; height:46px;",
        tags$ul(
          style="display:flex; flex-direction:row; flex-wrap:wrap; margin:0; list-style:none; align-items:center; height:100%;",
          tags$li(a(href="https://www2.gov.bc.ca/gov/content/home", "Home", style="font-size:1em; font-weight:normal; color:white; padding-left:5px; padding-right:5px; border-right:1px solid #4b5e7e;")),
          tags$li(a(href="https://www2.gov.bc.ca/gov/content/home/disclaimer", "Disclaimer", style="font-size:1em; font-weight:normal; color:white; padding-left:5px; padding-right:5px; border-right:1px solid #4b5e7e;")),
          tags$li(a(href="https://www2.gov.bc.ca/gov/content/home/privacy", "Privacy", style="font-size:1em; font-weight:normal; color:white; padding-left:5px; padding-right:5px; border-right:1px solid #4b5e7e;")),
          tags$li(a(href="https://www2.gov.bc.ca/gov/content/home/accessibility", "Accessibility", style="font-size:1em; font-weight:normal; color:white; padding-left:5px; padding-right:5px; border-right:1px solid #4b5e7e;")),
          tags$li(a(href="https://www2.gov.bc.ca/gov/content/home/copyright", "Copyright", style="font-size:1em; font-weight:normal; color:white; padding-left:5px; padding-right:5px; border-right:1px solid #4b5e7e;")),
          tags$li(a(href="https://www2.gov.bc.ca/StaticWebResources/static/gov3/html/contact-us.html", "Contact", style="font-size:1em; font-weight:normal; color:white; padding-left:5px; padding-right:5px; border-right:1px solid #4b5e7e;"))
        )
      )
    )
  )
  
  suppressPackageStartupMessages({
    library(DBI)
    library(RPostgres)
  })
  
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
      
      fluidRow(
        column(5,
               shinyWidgets::numericRangeInput(
                 inputId = "well_tag_number_range", 
                 label = "Well tag number range:",
                 value = c(1, 999999)
               )
        ),
        column(5,
               dateRangeInput("date_range", "Date range:",
                              start  =  Sys.Date()-13,
                              end    =  Sys.Date(),
                              min    = "2021-12-13",
                              max    = Sys.Date(),
                              #format = "mm/dd/yy",
                              #separator = " - "
               )
        ),
        column(2,
               actionButton("recalc", "Get me home!", 
                            icon("circle-check"),
                            
                            style="color: #101010; background-color: #4b5e7e; border-color: #101010")
        )
      ),
      navbarPage(
        title = "text wide as the bc logo", theme = "bcgov.css", 
        tabPanel(
          "1 summary", 
          sidebarLayout(
            sidebarPanel(
              helpText("help text1"),
              img(src = "www/Ecoprovinces_Title.png", height = 1861*1/5, width = 1993*1/5),
            ),    
            mainPanel(
              #verbatimTextOutput("summary"),
            )
          ),
          bc_template_footer
        ),        
        tabPanel(
          "2 table", 
          sidebarLayout(
            sidebarPanel(
              helpText("helptext2"),
              #img(src = "www/Ecoprovinces_Title.png", height = 1861*1/5, width = 1993*1/5),
            ),    
            mainPanel(

                #tableOutput("table")
                DT::dataTableOutput("table1")

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

