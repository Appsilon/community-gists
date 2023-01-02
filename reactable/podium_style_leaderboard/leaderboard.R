library(shiny)
library(reactable)
library(sass)

#' @description simple function to get country emoji
#' @param country_codes vector of alpha-2 country codes
#' @return vector with country flag emoji
#'
get_flag <- function(country_codes) {
  sapply(country_codes, function(country_code) {
    if (is.null(country_code) || is.na(country_code)) {
      return(NULL)
    }
    intToUtf8(127397 + strtoi(charToRaw(toupper(country_code)), 16L))
  }) |>
    as.vector()
}

css <- sass(sass_file("style.scss"))

ui <- fluidPage(
  tags$head(tags$style(css)),
  div(id = "leaderboard_box",
      div(id = "leaderboard",
        uiOutput("podium"),
        reactableOutput("leaderboard")
        ),
      div(id = "footer_block",
        HTML("<strong id='footer_head'>FIFA 2022 Leaderboard</strong>"),
        br(),
        HTML("<p id='footer_text'><strong>Based on: </strong>
             Total Points from the <a href=
             'http://bit.ly/3WBYCo1'>FIFA Worldcup 2022 Results (Kaggle)
             dataset</a><br>
             kaggle.com/datasets/sayanroy729/fifa-worldcup-2022-results
             </p>")
      )
  )
)

server <- function(input, output, session) {

  leaderboard_data <- reactive({

    data <- read.csv("data/total_points.csv")
    data <- data[order(data$total_points, decreasing = TRUE), ]
    data$rank <- seq(1:nrow(data))
    data$total_points <- NULL
    data$alpha.2 <- get_flag(data$alpha.2)
    data$country <- paste(data$country, data$alpha.2, sep = "_")
    data$alpha.2 <- NULL
    data

    })

    output$podium <- renderUI({

      top_three <- head(leaderboard_data(), 3)$country
      top_three <- data.frame(t(data.frame(strsplit(top_three, "_"))))
      colnames(top_three) <- c("Country", "Flag")
      rownames(top_three) <- NULL

      countries <- top_three$Country
      flags <- top_three$Flag

      div(id = "podium",
          div(id = "second_place",
              class = "podium_box",
              div(class = "podium_country",
                  p(class = "country_flag",
                    flags[2]),
                  p(class = "country_label",
                    countries[2])
              )
          ),
          div(id = "first_place",
              class = "podium_box",
              div(class = "podium_country",
                  p(class = "country_flag",
                    flags[1]),
                  p(class = "country_label",
                    countries[1])
              )
          ),
          div(id = "third_place",
              class = "podium_box",
              div(class = "podium_country",
                  p(class = "country_flag",
                    flags[3]),
                  p(class = "country_label",
                    countries[3])
              )
          ),
      )
    })

    output$leaderboard <- renderReactable({
      reactable(data = leaderboard_data()[4:10, ],
                style = list(backgroundColor = "rgba(255, 255, 255, 0.4)"),
                borderless = TRUE,
                outlined = FALSE,
                striped = TRUE,
                pagination = FALSE,
                width = "100%",
                columns = list(
                  country = colDef(
                    cell = function(value) {
                      value <- strsplit(value, "_")[[1]]
                      div(class = "leaderboard_row",
                          p(class = "country_flag_row",
                            value[2]),
                          p(class = "country_label_row",
                            value[1])
                      )
                    }
                  ),
                  rank = colDef(
                    html = TRUE,
                    cell = function(value) {
                      value <- paste0("<p class = 'country_rank_row'>",
                                      value, "<sup>th</sup></p>"
                      )
                      value
                    }
                  ))
      )
    })

}

shinyApp(ui, server)