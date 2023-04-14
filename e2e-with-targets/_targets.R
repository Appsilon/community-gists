# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c(
    "tibble",
    "shiny",
    "RSQLite",
    "DBI",
    "glue",
    "jsonlite",
    "testthat",
    "htmltools",
    "rvest"
  ), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.
future::plan(future.callr::callr)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:

# list(
#   tar_target(db_name, "data_source.db", format = "file"),
#   tarchetypes::tar_map(
#     list(db_name = "data_source.db"),
#     tar_target(table_names, find_table_names_in_db(db_name)),
#     tar_target(download_df, download_table_from_db(db_name, table_names), pattern = map(table_names)),
#     tar_target(test_modules, test_module(db_name, table_name = download_df))
#   )
# )

list(
  tar_target(db_name, "data_source.db", format = "file"),
  tar_target(table_names, find_table_names_in_db(db_name)),
  tar_target(mtcars_proper, download_table_from_db(db_name, table_names[1])),
  tar_target(iris_proper, download_table_from_db(db_name, table_names[3])),
  tar_target(test_modules_1, test_module(mtcars_proper)),
  tar_target(test_modules_2, test_module(iris_proper))
)

# use case - data validation, saving time thanks to skipping already done stuff
# additionally: use tarchetypes::tar_map() to dynamic branching (creating it on the fly)
# orginal reason: many tables, many inputs
# tar_read()
