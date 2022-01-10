library(shiny)
library(shinyWidgets)
library(dplyr)
mod_filterDataInputMPG_ui <- function(id){
  ns <- NS(id)
  shinyWidgets::numericRangeInput(
    inputId = ns("mpg_range"), 
    label = "mpg_range",
    value = c(0, 99)
  )
}

mod_filterDataInputGo_ui <- function(id){
  ns <- NS(id)
  actionButton(
    inputId = ns("go"), 
    label = "Go")
}

mod_filterDataInput_server <- function(id,df){
  stopifnot(!is.reactive(df)) # df shouldnt be reactive here .. it is mtcars
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    eventReactive(input$go,{
      list(
        df = #reactive( 
          df %>%
            dplyr::filter(
              mpg >= input$mpg_range[1] &
                mpg <= input$mpg_range[2]
            ),
        mpg_min = input$mpg_range[1],
        mpg_max = input$mpg_range[2]
      )
    })
  })
}

mod_table1Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("table1"))
  )
}

mod_table1Output_server <- function(id,d){#f, mpg_min, mpg_max){
  # stopifnot(is.reactive(df)) # df here should be reactive.. it is mtcars after being filtered by the user-selectable inputs
  # stopifnot(is.reactive(mpg_min))
  # stopifnot(is.reactive(mpg_max))
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$table1 <- DT::renderDataTable({
      data <- d()
      df <- data$df
      mpg_min <- data$mpg_min
      mpg_max <- data$mpg_max
      df %>% 
        select(mpg, cyl, disp) %>% 
        DT::datatable(
          caption = paste0("list of cars with mpg between ", mpg_min, " and ", mpg_max),
          rownames = FALSE,
          escape = FALSE
        )
    })
  })
}



myApp <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        mod_filterDataInputMPG_ui("filterDataInput_ui_1"),
        mod_filterDataInputGo_ui("filterDataInput_ui_1")
      ),
      mainPanel(
        mod_table1Output_ui("table1Output_ui_1")
      )
    )
  )
  
  server <- function(input, output, session) {
    data <- mod_filterDataInput_server("filterDataInput_ui_1", mtcars)
    mod_table1Output_server("table1Output_ui_1", data)#df= data$df, mpg_min =data$mpg_min, mpg_max = data$mpg_max)
  }
  shinyApp(ui, server)
} 
myApp()q