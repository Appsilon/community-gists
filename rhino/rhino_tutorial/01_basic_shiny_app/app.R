library(shiny)

ui <- div(
  uiOutput("greeting_1"),
  uiOutput("greeting_2")
)

server <- function(input, output, session) {
  output$greeting_1 <- renderUI("Hello")
  output$greeting_2 <- renderUI("Ahoy")
}

shinyApp(ui, server)
