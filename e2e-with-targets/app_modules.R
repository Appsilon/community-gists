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
