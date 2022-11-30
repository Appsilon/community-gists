library(shiny)

module_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("greeting"))
}

module_server <- function(id, greet) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- renderUI(greet)
  })
}
