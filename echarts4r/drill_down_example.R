library(shiny)
library(echarts4r)
library(dplyr)

mock_data <- tibble::tribble(
  ~level1  ,   ~level2     , ~level3           , ~sales,
  "Asia"   ,    "China"    ,   "Shanghai"      ,  32L,
  "Asia"   ,    "China"    ,   "Beijing"       ,  86L,
  "Asia"   ,    "China"    ,   "Chongqing"     ,  30L,
  "Asia"   ,    "India"    ,   "Mumbai"        ,  92L,
  "Asia"   ,    "India"    ,   "Kolkata"       ,  75L,
  "Asia"   ,    "India"    ,   "Chennai"       ,  99L,
  "America",    "USA"      ,   "New York"      ,   6L,
  "America",    "USA"      ,   "Chicago"       ,  12L,
  "America",    "Argentina",   "Buenos Aires"  ,  54L,
  "America",    "Argentina",   "Rosario"       ,  36L,
  "America",    "Brasil"   ,   "Sao Paulo"     ,   2L,
  "America",    "Brasil"   ,   "Rio de Janeiro",  64L,
  "Europe" ,    "Spain"    ,   "Madrid"        ,  54L,
  "Europe" ,    "Spain"    ,   "Barcelona"     ,  46L,
  "Europe" ,    "Spain"    ,   "Sevilla"       ,  67L,
  "Europe" ,    "Italy"    ,   "Rome"          ,  22L,
  "Europe" ,    "France"   ,   "Paris"         ,  42L,
  "Europe" ,    "France"   ,   "Marseille"     ,  91L
)

ui <- fluidPage(
  echarts4rOutput("chart")
)

server <- function(input, output) {
  
  output$chart <- renderEcharts4r({
    if (is.null(input$drill_elements$level) || input$drill_elements$level == "level1") {
      chart_data <- mock_data |>
        group_by(level1) |>
        summarise(total = sum(sales))
      
      chart_data |> 
        e_chart(x = level1) |>
        e_bar(total, name = "Sales by Continent") |>
        e_on(
          query = "series.bar",
          handler = "function(params){
           Shiny.setInputValue('drill_elements', {level: 'level2', drill1: params.name}, {priority: 'event'});
         }",
         event = "click"
        )
    } else if (input$drill_elements$level == "level2") {
      chart_data <- mock_data |>
        filter(level1 == input$drill_elements$drill1) |>
        group_by(level1, level2) |>
        summarise(total = sum(sales))
      
      chart_data |> 
        e_chart(x = level2) |>
        e_bar(total, name = "Sales by Country") |>
        e_title("Back", triggerEvent = TRUE) |>
        e_on(
          query = "series.bar",
          handler = "function(params){
           Shiny.setInputValue('drill_elements', {level: 'level3', drill2: params.name}, {priority: 'event'});
         }",
         event = "click"
        ) |>
        e_on(
          query = "title",
          handler = paste0("function(params){
               Shiny.setInputValue('drill_elements', {level: 'level1', drill1: '", unique(chart_data$level1), "'}, {priority: 'event'});
             }"),
          event = "click"
        )
    } else if (input$drill_elements$level == "level3") {
      chart_data <- mock_data |>
        filter(level2 == input$drill_elements$drill2) |>
        group_by(level1, level2, level3) |>
        summarise(total = sum(sales))
      
      chart_data |> 
        e_chart(x = level3) |>
        e_bar(total, name = "Sales by City") |>
        e_title("Back", triggerEvent = TRUE) |>
        e_on(
          query = "title",
          handler = paste0("function(params){
               Shiny.setInputValue('drill_elements', {level: 'level2',
                                                      drill1: '", unique(chart_data$level1), "',
                                                      drill2: '", unique(chart_data$level2), "'}, {priority: 'event'});
             }"),
          event = "click"
        )
    }
  })
}

shinyApp(ui, server)
