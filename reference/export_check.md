# Checks imported form lengths against the export note produced by prospect.

For use with CTRU studies using prospect. This function checks the read
in csv file lengths against he export note produced by prospect.

## Usage

``` r
export_check(export_notes, data, file = "")
```

## Arguments

- export_notes:

  file path to the export note (usually in the same folder as the
  exported csv files and called export_note.txt)

- data:

  a list containing the read in data

- file:

  file path to which the log should be saved (e.g. "export-check.log").
  If left as `file = ""` (the default) then the log will not be saved.

## Value

nothing is returned but a message is printed to the console (or saved to
a log) stating whether the check was successful.
