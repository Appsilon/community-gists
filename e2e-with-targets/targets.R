# loading packages --------------------------------------------------------------------------------
box::use(
  shiny[...],
  RSQLite[SQLite],
  DBI[dbConnect, dbDisconnect, dbGetQuery],
  glue[glue_sql],
  jsonlite[fromJSON]
)

# loading Shiny modules ---------------------------------------------------------------------------
source("app_modules.R", local = TRUE)

# test DT module ----------------------------------------------------------------------------------
dataset <- c(1:3)
# dataset <- mtcars
# dataset <- NULL
# dataset <- ""

testServer(
  app = dt_module_server,
  args = list(
    dataset = reactive(dataset),
    show_row_names = reactive(FALSE)
  ),
  {
    # stopifnot(shiny::is.shiny.appobj(output$out))

    # print(str(fromJSON(output$out)))
    # print(str(fromJSON(output$out)$x))

    if (is.null(fromJSON(output$out)$x)) stop("output is NULL!", call. = FALSE)
    if (is.null(output$out)) stop("output is NULL!", call. = FALSE)
    stopifnot(jsonlite::validate(output$out))
    stopifnot(nchar(output$out) > 0)

    stopifnot(c("jquery", "dt-core") %in% fromJSON(output$out)$deps$name)
  }
)

# test table module -------------------------------------------------------------------------------
dataset <- c(1:3)
# dataset <- mtcars
# dataset <- NULL
# dataset <- ""

testServer(
  app = table_module_server,
  args = list(
    # dataset = reactive(datasets::mtcars),
    dataset = reactive(dataset),
    show_row_names = reactive(FALSE)
  ),
  {
    # how does the output look like?
    # print(output$out)

    # is it a proper character vector?
    stopifnot(
      nchar(output$out) > 0,
      length(output$out) != 1
    )

    # does it look like shiny table?
    stopifnot(
      grepl("<table  class = 'table shiny-table table-", output$out)
    )

    # let's create a data frame back from it
    output_df <- as.data.frame(rvest::html_table(rvest::read_html(output$out), fill = TRUE))

    # is it a proper data frame?
    stopifnot(
      is.data.frame(output_df)
    )

    # do number of columns look good?
    stopifnot(
      ncol(output_df) >= ncol(dataset),
      ncol(output_df) > 1
    )
  }
)

test_module_dt <- function(server = dt_module_server, dataset, show_row_names) {
  testServer(
    app = server,
    args = list(
      dataset = reactive(dataset),
      show_row_names = reactive(show_row_names)
    ),
    {
      if (is.null(output$out)) stop("output is NULL!", call. = FALSE)
      stopifnot(c("jquery", "dt-core") %in% fromJSON(output$out)$deps$name)
    }
  )
}

test_module_table <- function(server = table_module_server, dataset, show_row_names) {
  testServer(
    app = server,
    args = list(
      dataset = reactive(dataset),
      show_row_names = reactive(show_row_names)
    ),
    {
      if (is.null(output$out)) stop("output is NULL!", call. = FALSE)
      stopifnot(grepl("<table  class = 'table shiny-table table-", output$out))
    }
  )
}

test_module_dt(dataset = NULL, show_row_names = FALSE)
test_module_table(dataset = NULL, show_row_names = FALSE)

test_module_dt(dataset = mtcars, show_row_names = FALSE)
test_module_table(dataset = mtcars, show_row_names = FALSE)


testServer(
  app = table_module_server,
  args = list(
    # dataset = reactive(datasets::mtcars),
    dataset = reactive(NULL),
    show_row_names = reactive(FALSE)
  ),
  {
    # session$setInputs(x = 1)
    # stopifnot(myreactive() == 2)
    print(output$out)
    if (is.null(output$out)) stop("output is NULL!", call. = FALSE)
    stopifnot(grepl("<table  class = 'table shiny-table table-", output$out))

  }
)

# przepisz na 2 testujace funkcje
# zrob funkcje pobierajaca datasety
# napisz wyzsza funkcje pobierajaca i testujaca moduly na kazdym datasecie
