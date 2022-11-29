library(shiny)
library(shinyWidgets)
library(dplyr)
library(jsonlite)
library(purrr)

data <- data.frame(
  protein = c("Protein 1", "Protein 1", "Protein 2"),
  type = c("Type 1", "Type 2", "Type 1")
)

shinyApp(
  ui = fluidPage(
    column(
      width = 6,
      br(),
      p("Selecting Protein 1, regardless of Type, shows all Protein 1 options."),
      br(),
      virtualSelectInput(
        "normal",
        label = "Normal",
        choices = list(
          `Type 1` = c(
            `Protein 1` = "Protein 1",
            `Protein 2` = "Protein 2"
          ),
          `Type 2` = c(
            `Protein 1` = "Protein 1"
          )
        ),
        selected = "Protein 1",
        multiple = TRUE
      ),
      tableOutput("normal_output")
    ),
    column(
      width = 6,
      br(),
      p("Selecting Protein 1 for a specific Type only shows Protein 1 for that type."),
      br(),
      virtualSelectInput(
        "complex",
        label = "Complex",
        choices = list(
          `Type 1` = c(
            `Protein 1` = '{"protein":"Protein 1","type":"Type 1"}',
            `Protein 2` = '{"protein":"Protein 2","type":"Type 1"}'
          ),
          `Type 2` = c(
            `Protein 1` = '{"protein":"Protein 1","type":"Type 2"}'
          )
        ),
        selected = '{"protein":"Protein 1","type":"Type 1"}',
        multiple = TRUE
      ),
      tableOutput("complex_output")
    )
  ),
  server = function(input, output) {
    output$normal_output <- renderTable({
      req(input$normal)
      data %>%
        filter(protein %in% input$normal)
    })

    output$complex_output <- renderTable({
      req(input$complex)
      data %>%
        inner_join(map_dfr(input$complex, fromJSON))
    })
  }
)
