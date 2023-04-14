## app.R

# loading libraries -------------------------------------------------------------------------------
# if you don't have {box} package yet, install it with:
# install.packages("box")

# loading packages
box::use(
  shiny[...],
  RSQLite[SQLite],
  DBI[dbConnect, dbDisconnect, dbGetQuery],
  glue[glue_sql]
)

# loading Shiny modules ---------------------------------------------------------------------------
# box returns crazy error about {rstudioapi} which isn't directly used anywhere
source("R/app_modules.R", local = TRUE)$value

# main app ----------------------------------------------------------------------------------------
# UI
ui <- fluidPage(
  titlePanel("Application Title"),

  sidebarLayout(

    # sidebar panel with controls
    sidebarPanel(

      # a button for choosing a data set
      radioButtons(
        inputId = "dataset_name",
        label = h3("Choose dataset"),
        choices = list(
          "mtcars" = "mtcars",
          "iris" = "iris")
      ),

      # a button for displaying or hiding row names (row indexes)
      checkboxInput("show_row_names", label = "Show row name?", value = TRUE),
    ),

    # main panel with contents
    mainPanel(
      tabsetPanel(
        tabPanel(
          "DT Table",
          # using a module to display an interactive DT table
          dt_module_ui("first_table")
        ),

        tabPanel(
          "Classic Table",
          # using a module to display an classic R Shiny table
          table_module_ui("second_table")
        )
      )
    )
  )
)

# server
server <- function(input, output, session) {

  # downloading a dataset
  dataset_reactive <- reactive({
    req(input$dataset_name)

    # connecting to example DB
    con <- dbConnect(drv = SQLite(), "data_source.db")

    # assigning proper option to DB table name
    table_name <- switch( # switch is a nicer solution for nested if/else clauses
      input$dataset_name,
      "mtcars" = "mtcars_df_proper",
      "iris" = "iris_df_proper"
    )

    # downloading proper table to data frame
    dataset <- dbGetQuery(
      conn = con,
      statement = glue_sql("SELECT * FROM {table_name}", .con = con) # nicer pasting for DBs
    )

    # disconnecting since we won't need this connection for now
    dbDisconnect(conn = con)

    return(dataset) # this is here so we won't return disconnection status instead of data frame
  })

  # keeping button input in a reactive so it's safe to send to modules
  show_row_names_reactive <- reactive({
    input$show_row_names
  })

  # executing server part of DT module
  dt_module_server(
    id = "first_table",
    dataset = dataset_reactive,
    show_row_names = show_row_names_reactive
  )

  # executing server part of classic table module
  table_module_server(
    id = "second_table",
    dataset = dataset_reactive,
    show_row_names = show_row_names_reactive
  )
}

shinyApp(ui, server)
