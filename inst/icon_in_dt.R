library(shiny)
library(DT)
library(dplyr)

ui <- basicPage(
  tags$style(".glyphicon-ok-sign {color:#2b8ee5}
              .glyphicon-question-sign {color:#f4e107}
              .glyphicon-exclamation-sign {color:#e5413b}
              .glyphicon-flag, .glyphicon-trash {color:#28b728}"),
  
  DT::dataTableOutput("table")
)

server <- function(input, output, session) {
  output$table <- DT::renderDataTable({
    data <- mtcars %>% 
      mutate(icon = as.character(icon("exclamation-sign", lib = "glyphicon")))
    datatable(data, escape = FALSE) 
  })
}

shinyApp(ui, server)

# colored icons encore par cecilia lee
#https://gist.github.com/cecilialee/8df9afe984f6040d7e427d5da4a5bbf2
