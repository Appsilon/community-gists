# Attach functions with local alias e.g filter is renamed as dplyr_filter
box::use(
  ggplot2[...],
  dplyr[dplyr_filter = filter, `%>%`],
)

ggplot(
  data.frame(x = rnorm(10), y = rnorm(10)) %>%
    dplyr_filter(x > 0),
  aes(x, y)
) +
  geom_point()
