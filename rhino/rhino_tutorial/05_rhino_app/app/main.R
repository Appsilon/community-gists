box::use(
  shiny[div, NS, moduleServer],
)
box::use(
  app / view / greet
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    greet$ui(ns("module_1")),
    greet$ui(ns("module_2"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    greet$server("module_1", "Hello")
    greet$server("module_2", "Ahoy")
  })
}
