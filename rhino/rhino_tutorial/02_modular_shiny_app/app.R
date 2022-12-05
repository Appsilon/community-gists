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

ui <- div(
  module_ui("module_1"),
  module_ui("module_2")
)

server <- function(input, output, session) {
  module_server("module_1", "Hello")
  module_server("module_2", "Ahoy")
}

shinyApp(ui, server)
