#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  # output$table <- renderTable({
  #   dataset <- get(input$dataset, "package:datasets")
  #   dataset
  
  output$table <- renderTable({
    old_qa <- dbGetQuery(con1, "select * from wells_qa limit 10")
    old_qa
  })
  
}

