## Workflow performed to create this shiny app

### 1. Navigate to a new project directory

```bash
cd 05_rhino_app
```

### 2. Use `rhino::init()` in the project directory to initialize a rhino template

Just after running the `rhino::init()` you should have a backbone for your shiny app, but we are only interested in the `main.R` file at the moment. The contents of the `main.R` file after the initialization will be as below.

```r
# Contents of the app/main.R file after rhino::init()
box::use(
  shiny[bootstrapPage, moduleServer, NS, renderText, tags, textOutput],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    tags$h3(
      textOutput(ns("message"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$message <- renderText("Hello!")
  })
}
```

### 3. Creating our module ui and server functions in `app/view/greet.R`

```r
box::use(
  shiny[NS, moduleServer, uiOutput, renderUI]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("greeting"))
}

#' @export
server <- function(id, greet) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- renderUI(greet)
  })
}
```

### 4. Modifying the `main.R` file to import our `app/view/gree.R` and use it in the shiny UI and server functions

```r
box::use(
  shiny[div, NS, moduleServer],
)
box::use(
  app / view / greet
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    greet$ui(ns("module_1")),
    greet$ui(ns("module_2"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    greet$server("module_1", "Hello")
    greet$server("module_2", "Ahoy")
  })
}
```

### 5. Output of the Shiny App

![Shiny App Output Screenshot](app_screenshot.png "Shiny App Output Screenshot")
