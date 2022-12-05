## Workflow performed to create this shiny app

### 1. Creating `app.R` file in a project directory

```bash
cd 02_modular_shiny_app
touch app.R
```

### 2. Loading the required libraries

```r
library(shiny)
```

### 3. Creating the module UI function for the shiny app

```r
module_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("greeting"))
}
```

### 4. Creating the module server function for the shiny app

```r
module_server <- function(id, greet) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- renderUI(greet)
  })
}
```

### 5. Creating the shiny UI and Server function by calling the module UI and module server functions

```r
ui <- div(
  module_ui("module_1"),
  module_ui("module_2")
)

server <- function(input, output, session) {
  module_server("module_1", "Hello")
  module_server("module_2", "Ahoy")
}
```

### 6. Putting it all together by calling the `shinyApp` function

```r
shinyApp(ui, server)
```

### 7. Output of the Shiny App

![Shiny App Output Screenshot](app_screenshot.png "Shiny App Output Screenshot")
