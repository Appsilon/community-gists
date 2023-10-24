##
# DEMO APP TO RECORD USER DATA WITH SHINY TELEMETRY
library(shiny)
library(shinyjs)
library(shiny.telemetry)
library(magrittr)

if (!dir.exists('www/')) {
  dir.create('www')
}

download.file(
  url = 'https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js',
  destfile = 'www/js.cookie.js'
)

addResourcePath("js", "www")

jsCode <- '
shinyjs.getcookie = function(params) {
  var cookie = Cookies.get(params[0]);
  Shiny.onInputChange("jscookie", [params[0], cookie]);
}

shinyjs.setcookie = function(params) {
  Cookies.set(params[1], escape(params[0]), { expires: 0.5 });
}
'

data_storage <- DataStorageLogFile$new("app_analytics/logs.txt")
telemetry <- Telemetry$new("myApp", data_storage)

shinyApp(
  ui = fluidPage(
    shiny::tags$head(shiny::tags$script(src = "js/js.cookie.js")),
    useShinyjs(),
    extendShinyjs(text = jsCode, functions = c("getcookie", "setcookie")),
    
    use_telemetry(), # 2. Add necessary Javascript to Shiny
    # actionButton('set', 'set'),
    numericInput("n", "n", 1),
    plotOutput('plot'),
    verbatimTextOutput('output')
  ),
  server = function(input, output) {
    telemetry$start_session() # 3. Minimal setup to track events
    
    observe({
      js$getcookie("uid")
    })
    
    observeEvent(checkCookie(), {
      # Store user ID in shiny.telemetry logs
      telemetry$log_login(username = checkCookie())
    })
    
    checkCookie <- eventReactive(input$jscookie, {
      uid <- input$jscookie[2]

      if(is.null(uid) | is.na(uid)){
        uid <- sample(c(0:9, letters), 30, replace = TRUE) |> paste(collapse = "")
        js$setcookie(uid, "uid")
      }
      return(uid)
    })

    output$output <- renderText({
      checkCookie()
    })

    output$plot <- renderPlot({ hist(runif(input$n)) })
  }
)
