box::use(
  shiny[div, shinyApp]
)
# Make sure the working directory is the location of this app.R to load greet
box::use(
  . / greet
)

ui <- div(
  greet$module_ui("module_1"),
  greet$module_ui("module_2")
)

server <- function(input, output, session) {
  greet$module_server("module_1", "Hello")
  greet$module_server("module_2", "Ahoy")
}

shinyApp(ui, server)
