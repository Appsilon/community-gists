# loading Shiny modules ---------------------------------------------------------------------------
load_modules <- function(file_path) {
  source(file_path, local = TRUE)
}
# source("R/app_modules.R", local = TRUE)

# helper function for testing DT module -----------------------------------------------------------
test_module_dt <- function(server = dt_module_server, dataset, show_row_names) {
  testServer(
    app = server,
    args = list(
      dataset = reactive(dataset),
      show_row_names = reactive(show_row_names)
    ),
    {
      # methods from Kuba, not working properly
      # expect_is(fromJSON(output$out), "shiny.tag")
      # tagQuery(output$out)$hasClass("shiny-table")

      expect(!is.null(output$out), "Error: module output is NULL")
      expect(jsonlite::validate(output$out), "Error: module output is not a valid JSON")
      expect(nchar(output$out) > 0, "Error: module output is an empty string")
      expect(
        all(c("jquery", "dt-core") %in% fromJSON(output$out)$deps$name),
        "Error: module output is not a DT object"
      )
    }
  )
}

# helper function for testing table module --------------------------------------------------------
test_module_table <- function(server = table_module_server, dataset, show_row_names) {
  testServer(
    app = server,
    args = list(
      dataset = reactive(dataset),
      show_row_names = reactive(show_row_names)
    ),
    {
      # methods from Kuba, not working properly
      # expect_is(output$out, "shiny.tag")
      # tagQuery(output$out)$hasClass("shiny-table")

      # is it a proper character vector?
      expect(!is.null(output$out), "Error: output is NULL")
      expect(nchar(output$out) >= 1, "Error: output character length is too short")
      expect(length(output$out) == 1, "Error: output is not a vector of length == 1")

      # does it look like shiny table?
      expect(
        grepl("<table  class = 'table shiny-table table-", output$out),
        "Error: output is not of class 'shiny-table'"
      )

      # let's create a data frame back from it
      output_df <- as.data.frame(html_table(read_html(output$out), fill = TRUE))

      # is it a proper data frame?
      expect(is.data.frame(output_df), "Error: parsed output isn't a data frame")
    }
  )
}

# helper function for downloading datasets --------------------------------------------------------
download_dataset_for_test <- function(db_name, table_name) {
  con <- dbConnect(drv = SQLite(), db_name)

  # downloading proper table to data frame
  dataset <- dbGetQuery(
    conn = con,
    statement = glue_sql("SELECT * FROM {table_name}", .con = con)
  )

  dbDisconnect(conn = con)

  return(dataset)
}

# helper function to download all the table names in DB -------------------------------------------
find_table_names_in_db <- function(db_name) {
  con <- dbConnect(drv = SQLite(), db_name)

  # downloading proper table to data frame
  table_names <- DBI::dbListTables(conn = con)

  dbDisconnect(conn = con)

  return(table_names)
}

# helper function for downloading and testing a module --------------------------------------------
test_module <- function(db_name, table_name) {
  dataset_df <- download_dataset_for_test(db_name, table_name)
  test_module_dt(dataset = dataset_df, show_row_names = FALSE)
  test_module_table(dataset = dataset_df, show_row_names = FALSE)
}
