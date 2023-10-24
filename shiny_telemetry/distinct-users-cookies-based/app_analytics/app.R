##
# APP ANALYTICS FROM SHINY TELEMETRY

library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(shinyjs)
library(tidyr)
library(dplyr)
library(purrr)
library(plotly)
library(timevis)
library(ggplot2)
library(mgcv)
library(config)
library(DT)

# Please install shiny.telemetry with all dependencies
# remotes::install_github("Appsilon/shiny.telemetry", dependencies = TRUE)
library(shiny.telemetry)

# data_storage <- DataStorageSQLite$new("telemetry.sqlite")
data_storage <- DataStorageLogFile$new("logs.txt")

# This sample application includes a configuration for RSConnect deployments,
# that uses parameters in `config.yml` file to define Data Storage backend
if (Sys.getenv("R_CONFIG_ACTIVE") == "rsconnect") {
  data_storage <- do.call(
    config::get("data_storage")$class$new,
    config::get("data_storage")$params
  )
}

analytics_app(data_storage = data_storage)

# shiny::shinyAppDir(file.path("inst", "examples", "app", "analytics"))