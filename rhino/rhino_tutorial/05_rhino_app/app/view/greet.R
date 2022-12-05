box::use(
  shiny[NS, moduleServer, uiOutput, renderUI]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("greeting"))
}

#' @export
server <- function(id, greet) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- renderUI(greet)
  })
}
