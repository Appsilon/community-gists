# Box - Write Reusable, Composable and Modular R Code

## Key Syntaxes with Example

### 1. You can import a package/module directly

In this example the `ggplot2` package is loaded, but to call the objects from ggplot2 you must use the `$` symbol.

```r
box::use(ggplot2)
ggplot2$ggplot
```

### 2. You can attach all the exported objects from the package/module using the ...

In this example the all the exported objects from the `ggplot2` package are attached, Essentially the same as calling `library(ggplot2)`.

```r
box::use(
  ggplot2[...]
)
ggplot
```

### 3. Attaching just the required functions from a package/module [Recommended]

In this example only the `ggplot()` function is attached from the `ggplot2` package, other packages will not be callable.

```r
box::use(
  ggplot2[ggplot]
)
ggplot
```

### 4. Importing a package/module using alias

In this example the `ggplot2` package is loaded as `plt`, so all the objects are now accessed by `plt$`.

```r
box::use(
  plt = ggplot2
)
plt$ggplot
```

### 5. Attach some objects while importing a package/module using alias

In this example the `ggplot2` package is loaded as `plt` while ggplot is attached from the package.

```r
box::use(
  plt = ggplot2[ggplot]
)
ggplot
```

### 6. Adding alias to attached functions

In this example the `ggplot` function is renamed as `init_plot` before being attached.

```r
box::use(
  ggplot2[init_plot = ggplot]
)
init_plot
```
