## Workflow performed to create this shiny app

### 1. Creating `app.R` file in a project directory

```bash
cd 01_basic_shiny_app
touch app.R
```

### 2. Loading the required libraries

```r
library(shiny)
```

### 3. Creating the UI generator for the shiny app

```r
ui <- div(
  uiOutput("greeting_1"),
  uiOutput("greeting_2")
)
```

### 4. Creating the server logic function for the shiny app

```r
server <- function(input, output, session) {
  output$greeting_1 <- renderUI("Hello")
  output$greeting_2 <- renderUI("Ahoy")
}
```

### 5. Putting it all together by calling the `shinyApp` function

```r
shinyApp(ui, server)
```

### 6. Output of the Shiny App

![Shiny App Output Screenshot](app_screenshot.png "Shiny App Output Screenshot")
