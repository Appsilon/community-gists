## Workflow performed to create this shiny app

### 1. Creating `app.R` and `greet.R` files in a project directory

```bash
cd 04_shiny_module_box_app
touch app.R
touch greet.R
```

### 2. Creating the module ui and server functions in the `greet.R` file using box imports

```r
box::use(
  shiny[NS, moduleServer, uiOutput, renderUI]
)

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

### 3. Using box imports to load the module functions in the `app.R` in both the UI and server functions

```r
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
```

### 4. Output of the Shiny App

![Shiny App Output Screenshot](app_screenshot.png "Shiny App Output Screenshot")
