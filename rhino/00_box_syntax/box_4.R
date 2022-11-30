# Import module/package with alias
box::use(plt = ggplot2)

plt$ggplot(
  data.frame(x = rnorm(10), y = rnorm(10)),
  plt$aes(x, y)
) + plt$geom_point()
