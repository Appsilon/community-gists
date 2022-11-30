# Import package/module
box::use(ggplot2)

ggplot2$ggplot(
  data.frame(x = rnorm(10), y = rnorm(10)),
  ggplot2$aes(x, y)
) + ggplot2$geom_point()
