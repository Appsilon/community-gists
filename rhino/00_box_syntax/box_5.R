# Import with alias and attach some functions
box::use(
  plt = ggplot2[ggplot, aes]
)

ggplot(
  data.frame(x = rnorm(10), y = rnorm(10)),
  aes(x, y)
) + plt$geom_point()
