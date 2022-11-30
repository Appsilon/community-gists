# Attach all exported functions/objects
box::use(
  ggplot2[...],
)

ggplot(
  data.frame(x = rnorm(10), y = rnorm(10)),
  aes(x, y)
) +
  geom_point()
