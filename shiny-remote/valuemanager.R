library(shiny) # load the shiny package
library(R6)    # load the R6 package

# Define a new R6Class called ValueManager to manage reactive values
ValueManager <- R6Class(
  classname = "ValueManager", # class name
  public = list(             # public methods accessible outside the class
    initialize = function() { 
      private$reactive_inner_counter <- reactiveVal(1) # initialize a private reactive value to 1
    },
    set_value = function(value) { 
      private$reactive_inner_counter(value) # set the private reactive value to a new value
    },
    get_value = function() {
      private$reactive_inner_counter() # get the current value of the private reactive value
    }
  ),
  private = list(           # private properties and methods only accessible within the class
    reactive_inner_counter = NULL # initialize the private reactive value to NULL
  )
)

# Instantiate the ValueManager class outside the server function
value_manager <- ValueManager$new() # create a new instance of ValueManager
