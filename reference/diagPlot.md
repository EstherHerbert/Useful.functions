# Diagnostic plots

`diagPlot` is a generic function used to produce diagnostic plots for
the results of various model fitting functions. The function invokes
particular [`methods()`](https://rdrr.io/r/utils/methods.html) which
depend on the [`class()`](https://rdrr.io/r/base/class.html) of the
model.

## Usage

``` r
diagPlot(model, ...)
```

## Arguments

- model:

  a model object for which diagnostic plots are required

- ...:

  arguments to pass to methods

## Value

returns a `gtable`
