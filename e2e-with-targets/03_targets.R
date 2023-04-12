# loading packages --------------------------------------------------------------------------------
box::use(
  shiny[testServer, reactive],
  RSQLite[SQLite],
  DBI[dbConnect, dbDisconnect, dbGetQuery, dbListTables],
  glue[glue_sql],
  jsonlite[fromJSON, validate],
  testthat[expect_is, expect],
  htmltools[tagQuery],
  rvest[html_table, read_html],
  targets[],
  tarchetypes[],
)



# target that moves on multiple datasets ----------------------------------------------------------


# main function that loops with purrr::safely(?) on multiple datasets -----------------------------
purrr::safely(

)
