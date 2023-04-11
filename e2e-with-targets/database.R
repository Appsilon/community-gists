## database.R

# loading libraries -------------------------------------------------------------------------------
box::use(
  dplyr[mutate, relocate, where, select],
  RSQLite[SQLite],
  DBI[dbConnect, dbWriteTable, dbDisconnect]
)


# preparing data sets for database ----------------------------------------------------------------
mtcars <- datasets::mtcars
iris <- datasets::iris

mtcars_df_proper <- mtcars |>
  mutate(name = rownames(mtcars)) |>
  `rownames<-`(NULL) |>
  mutate(id = 1:nrow(mtcars)) |>
  relocate(id, name, where(is.numeric))

mtcars_df_missing_cols <- mtcars_df_proper |>
  select(-cyl, -hp)

iris_df_proper <- iris |>
  mutate(id = 1:nrow(iris)) |>
  relocate(id, Species, where(is.numeric))

iris_df_missing_cols <- iris_df_proper |>
  select(-Sepal.Width)


# creating a database -----------------------------------------------------------------------------
con <- dbConnect(drv = SQLite(), "data_source.db") # we create a new DB

dbWriteTable(conn = con,  name = "mtcars_df_proper", value = mtcars_df_proper)
dbWriteTable(conn = con, name = "mtcars_df_missing_cols", value = mtcars_df_missing_cols)
dbWriteTable(conn = con, name = "iris_df_proper", value = iris_df_proper)
dbWriteTable(conn = con, name = "iris_df_missing_cols", value = iris_df_missing_cols)

dbDisconnect(conn = con)
