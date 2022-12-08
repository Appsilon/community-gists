box::use(
    readxl[read_xlsx],
    dplyr[select, mutate, filter]
)

data <- lapply(seq(4), function(i) {
    read_xlsx("data-raw/CPI_Data_2022.xlsx", skip = 2, sheet = i, na = "N/A")
})
names(data) <- c("overall", "emission", "price", "revenue")
str(data)

library(tidyverse)
data$overall |>
  select(-"Year of abolishment") |>
  filter(Type == "ETS")

library(leaflet)
library(ggplot2)

world_sf <- sf::st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
subnationals <- df %>% filter(`Type of juridiction covered` == "Subnational") %>%
  mutate(`Jurisdiction covered` = recode(`Jurisdiction covered`,
                                         "RGGI" = "New York",
                                         "Guangdong (except Shenzhen)" = "Guandong",
                                         "TCI" = "Rhode Island"))
nationals <- df %>%
  filter(`Type of juridiction covered` == "National") %>%
  mutate(`Jurisdiction covered` = recode(`Jurisdiction covered`,
                                         "United Kingdom" = "UK",
                                         "Brunei Darussalam" = "Brunei",
                                         "Korea, Republic of" = "Korea",
                                         "Cote d'Ivoire" = "Ivory Coast"))
regionals <- df %>% filter(`Type of juridiction covered` == "Regional")

city_lat_lons <- readRDS(file = "data-raw/city_lat_lons.rds")
subnational_coords <- tibble(city = names(city_lat_lons),
                             lat = city_lat_lons %>% map_dbl(~.x[1]),
                             lon = city_lat_lons %>% map_dbl(~.x[2]))

nationals %>% left_join(world_sf,by=c("Jurisdiction covered"="ID")) %>% saveRDS("data-raw/nationals.rds")
subnationals %>% left_join(subnational_coords,
                           by=c("Jurisdiction covered"="city")) %>%
  saveRDS("data-raw/subnationals.rds")

c("Austria", "Belgium", "Bulgaria", "Croatia", "Republic of Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Spain", "Sweden") %in% world_sf$ID

bind_cols(tibble(`Jurisdiction covered` = c("Austria", "Belgium", "Bulgaria", "Croatia", "Republic of Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Spain", "Sweden"), (regionals %>% select(-`Jurisdiction covered`)))) %>% left_join(world_sf,by=c("Jurisdiction covered"="ID")) %>% saveRDS("data-raw/regionals.rds")

# city_lat_lons <- list()
# index <- 1
# subn <- subnationals$`Jurisdiction covered`[index]
# print(subn)
# api_call <-URLencode(glue::glue("https://api.geoapify.com/v1/geocode/search?text={subn}&apiKey=759b785f94d342dda4820b57c5f7f8ac"))
# print(api_call)
# subn_geo <- httr::GET(api_call)
# subn_geoj <- subn_geo$content |> rawToChar() |> jsonlite::fromJSON()
# print(subn_geoj$features$properties$country[1])
# print(subn_geoj$features$properties$state[1])
# lat_lon <- c(subn_geoj$features$properties$lat[1],subn_geoj$features$properties$lon[1])
# city_lat_lons[[subn]] <- lat_lon
# city_lat_lons
# index <- index+1
# saveRDS("data-raw/city_lat_lons.rds")
