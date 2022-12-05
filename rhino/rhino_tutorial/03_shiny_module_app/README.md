## Workflow performed to create this shiny app

### 1. Creating `app.R` and `greet.R` files in a project directory

```bash
cd 03_shiny_module_app
touch app.R
touch greet.R
```

### 2. Creating the module ui and server functions in the `greet.R` file

```r
library(shiny)

module_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("greeting"))
}

module_server <- function(id, greet) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- renderUI(greet)
  })
}
```

### 3. Sourcing and calling the module functions in the `app.R` in both the UI and server functions

```r
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
```

### 4. Output of the Shiny App

![Shiny App Output Screenshot](app_screenshot.png "Shiny App Output Screenshot")
