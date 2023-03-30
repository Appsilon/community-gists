server <- function(input, output, session) {
  
  # Create a reactive value for storing the device type
  device_type <- reactiveVal()
  
  # Set up an observer to detect changes in the device type
  observe({
    
    # Update the device type using the shinybrowser::get_device() function
    device_type(shinybrowser::get_device())
    
    # If the device is a mobile device, hide the plot and show the slider control
    if (device_type() == "Mobile") {
      shinyjs::addClass("plot", "hidden")
      shinyjs::removeClass("slider", "hidden")
    }
  })
  
  # Set up an observer to detect changes in the slider input and update the value manager object
  observeEvent(input$bins, {
    value_manager$set_value(input$bins)
  }, ignoreInit = TRUE)
  
  # Generate the histogram plot output based on the device type and current slider value
  output$distPlot <- renderPlot({
    
    # Make sure the device type is available before generating the plot
    req(device_type())
    
    # Get the current slider value from the value manager object
    current_slider_value <- value_manager$get_value()
    
    # Generate a histogram plot using rnorm() with 1000 random numbers and the current slider value as the number of bins
    hist(rnorm(1000), current_slider_value)
  })
}
