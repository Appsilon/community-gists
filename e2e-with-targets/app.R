box::use(
  shiny[...],
  DT[DTOutput, renderDT, datatable]
)

# table_module_ui <- function(id, label = "Show rownames?") {
#   ns <- NS(id)
#   tagList(
#     checkboxInput("rownames_button", label = "Show rownames?", value = TRUE),
#     DTOutput(ns("out"))
#   )
# }
#
# table_module_server <- function(id, data, rownames){
#   moduleServer(
#     id,
#     function(input, output, session) {
#       output$out <- renderDT({
#         datatable(
#           data,
#           options = list(lengthChange = FALSE),
#           rownames = rownames
#         )
#       })
#     }
#   )
# }

ui <- fluidPage(
  headerPanel("App title"),
  sidebarPanel(
    radioButtons(
      inputId = "dataset",
      label = h3("Choose dataset"),
      choices = list("mtcars" = "mtcars", "iris" = "iris"),
      selected = NULL)
  ),
  mainPanel(
    # table_module_ui(id = "first_table")
    tagList(
      checkboxInput("rownames_button", label = "Show rownames?", value = TRUE),
      # DTOutput(ns("out"))
      DTOutput("out")
    )
  )
)

server <- function(input, output) {
  dataset_reactive <- reactive({
    if (input$dataset == "mtcars") {
      mtcars
    } else {
      iris
    }
  })

  output$out <- renderDT({
    datatable(
      dataset_reactive(),
      options = list(lengthChange = FALSE),
      rownames = rownames
    )
  })
}

shinyApp(ui, server)
