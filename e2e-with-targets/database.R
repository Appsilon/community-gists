## database.R

# loading -----------------------------------------------------------------------------------------
box::use(
  dplyr[
    mutate, relocate, where, select
  ],
  DBI[
    dbConnect, dbCreateTable, dbDisconnect
  ],
  RSQLite[SQLite]
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
dbCreateTable(conn = con, name = "mtcars_proper", fields = mtcars_df_proper)
dbCreateTable(conn = con, name = "mtcars_missing_cols", fields = mtcars_df_missing_cols)
dbCreateTable(conn = con, name = "iris_df_proper", fields = iris_df_proper)
dbCreateTable(conn = con, name = "iris_df_missing_cols", fields = iris_df_missing_cols)
dbDisconnect(conn = con)
