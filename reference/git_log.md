# Generates a log of git commits

This function uses a call to git on the command line to generate a csv
file which logs all git commits within the working directory.

## Usage

``` r
git_log(filename = file_stamp("git_log", ".csv"))
```

## Arguments

- filename:

  a character string with the file name to be used, must end in ".csv".
  The default is "git_log_DATESTAMP.csv".
