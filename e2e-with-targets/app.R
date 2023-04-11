box::use(
  shiny[...],
  DT[DTOutput, renderDT, datatable]
)

# module UI declaration
table_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    DTOutput(ns("out"))
  )
}

# module server declaration
table_module_server <- function(id, dataset){
  moduleServer(
    id,
    function(input, output, session) {

      output$out <- renderDT({
        datatable(data = dataset())
      })
    }
  )
}

# UI
ui <- fluidPage(
  headerPanel("App title"),

  sidebarPanel(
    radioButtons(
      inputId = "dataset",
      label = h3("Choose dataset"),
      choices = list(
        "mtcars" = "mtcars",
        "iris" = "iris")
    )
  ),

  mainPanel(
    table_module_ui(id = "first_table")
  )
)

# server
server <- function(input, output, session) {
  observe({
    print(input$dataset)
  })

  dataset_reactive <- reactive({
    req(input$dataset)
    switch(
      input$dataset,
      "mtcars" = mtcars,
      "iris" = iris
    )
  })
  table_module_server(id = "first_table", dataset = dataset_reactive)
}

shinyApp(ui, server)
