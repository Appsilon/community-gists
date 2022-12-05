# Make sure the working directory is the location of this app.R to source greet
source("greet.R")

ui <- div(
  module_ui("module_1"),
  module_ui("module_2")
)

server <- function(input, output, session) {
  module_server("module_1", "Hello")
  module_server("module_2", "Ahoy")
}

shinyApp(ui, server)
