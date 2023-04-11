box::use(
  shiny[...],
  DT[DTOutput, renderDT, datatable]
)



# DT module ---------------------------------------------------------------------------------------
# DT module UI declaration
dt_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    DTOutput(ns("out"))
  )
}

# DT module server declaration
dt_module_server <- function(id, dataset, show_row_names){
  moduleServer(
    id,
    function(input, output, session) {

      output$out <- renderDT({
        datatable(
          data = dataset(),
          rownames = show_row_names()
        )
      })
    }
  )
}

# table module ------------------------------------------------------------------------------------
# table module UI declaration
table_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tableOutput(ns("out"))
  )
}

# table module server declaration
table_module_server <- function(id, dataset, show_row_names){
  moduleServer(
    id,
    function(input, output, session) {
      output$out <- renderTable(dataset(), rownames = show_row_names)
    }
  )
}

# main app ----------------------------------------------------------------------------------------
# UI
ui <- fluidPage(
  titlePanel("Application Title"),

  sidebarLayout(
    sidebarPanel(

      radioButtons(
        inputId = "dataset_name",
        label = h3("Choose dataset"),
        choices = list(
          "mtcars" = "mtcars",
          "iris" = "iris")
      ),

      checkboxInput("show_row_names", label = "Show row name?", value = TRUE),
    ),

    mainPanel(
      tabsetPanel(
        tabPanel(
          "DT Table",
          # Use the module to create a table for mtcars
          dt_module_ui("first_table")
        ),

        tabPanel(
          "Classic Table",
          # Use the module to create a table for iris
          table_module_ui("second_table")
        )
      )
    )
  )
)

# server
server <- function(input, output, session) {
  observe({
    print(input$dataset_name)
  })

  dataset_reactive <- reactive({
    req(input$dataset_name)
    switch(
      input$dataset_name,
      "mtcars" = mtcars,
      "iris" = iris
    )
  })

  show_row_names_reactive <- reactive({
    input$show_row_names
  })

  dt_module_server(
    id = "first_table",
    dataset = dataset_reactive,
    show_row_names = show_row_names_reactive
  )

  table_module_server(
    id = "second_table",
    dataset = dataset_reactive,
    show_row_names = show_row_names_reactive
  )
}

shinyApp(ui, server)
