ui <- fluidPage(
  
  # Include Shiny.js library
  shinyjs::useShinyjs(),
  
  # Detect the user's browser type
  shinybrowser::detect(),
  
  # Add a link to an external stylesheet
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  
  # Add a title to the app
  titlePanel("Shiny Remote Control"),
  
  # Set up a sidebar and main panel layout
  sidebarLayout(
    
    # Create a div element with id "slider" and class "hidden"
    div(
      id = "slider",
      class = "hidden",
      sidebarPanel(
        
        # Add a slider control for selecting the number of bins
        sliderInput(
          "bins",
          "Number of bins:",
          min = 1,
          max = 50,
          value = 30
        )
      )
    ),
    
    # Create a div element with id "plot"
    div(
      id = "plot",
      mainPanel(
        
        # Add a plotOutput control for displaying the histogram
        plotOutput("distPlot")
      )
    )
  )
)
