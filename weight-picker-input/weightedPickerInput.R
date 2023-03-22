#' @description
#' Picker input with possibility to specify the weight of each option
weightedPickerInput <- function(
    id,
    choices,
    label = NULL,
    selected = NULL,
    min_weight = 1,
    max_weight = 5,
    default_weight = 3,
    step = 1
  ) {

  constants <- glue(
    "{
      minWeight: {{ min_weight }},
      maxWeight: {{ max_weight }},
      defaultWeight: {{ default_weight }},
      step: {{ step }},
    }",
    .open = "{{",
    .close = "}}"
  )

  # 1 dimension vector should be wrapped into the list
  if (is.null(names(choices))) {
    choices = list(` ` = choices)
  }

  div(
    class = "weighted-stats-selector",
    pickerInput(
      inputId = id,
      label = label,
      choices = choices,
      multiple = TRUE,
      selected = selected
    ),
    tags$script(
      glue("initStatsWeightModifier('{id}', {constants})")
    )
  )
}
