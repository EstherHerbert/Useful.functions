# Move the column names of a data frame to a row

Moving the column names of a data frame to a row is sometimes useful
when formatting a table for export. This function does that and the user
can specify which row they'd like the column names to be insterted
before.

## Usage

``` r
colnames_to_row(df, row = 1)
```

## Arguments

- df:

  the data frame

- row:

  the row number before which the column names will be inserted, default
  is (i.e., the names would become the first row of the data frame).

## Value

a data frame with column names in tact but added as a row

## Examples

``` r
colnames_to_row(iris)
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 1   Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 2            5.1         3.5          1.4         0.2     setosa
#> 3            4.9           3          1.4         0.2     setosa
#> 4            4.7         3.2          1.3         0.2     setosa
#> 5            4.6         3.1          1.5         0.2     setosa
#> 6              5         3.6          1.4         0.2     setosa
#> 7            5.4         3.9          1.7         0.4     setosa
#> 8            4.6         3.4          1.4         0.3     setosa
#> 9              5         3.4          1.5         0.2     setosa
#> 10           4.4         2.9          1.4         0.2     setosa
#> 11           4.9         3.1          1.5         0.1     setosa
#> 12           5.4         3.7          1.5         0.2     setosa
#> 13           4.8         3.4          1.6         0.2     setosa
#> 14           4.8           3          1.4         0.1     setosa
#> 15           4.3           3          1.1         0.1     setosa
#> 16           5.8           4          1.2         0.2     setosa
#> 17           5.7         4.4          1.5         0.4     setosa
#> 18           5.4         3.9          1.3         0.4     setosa
#> 19           5.1         3.5          1.4         0.3     setosa
#> 20           5.7         3.8          1.7         0.3     setosa
#> 21           5.1         3.8          1.5         0.3     setosa
#> 22           5.4         3.4          1.7         0.2     setosa
#> 23           5.1         3.7          1.5         0.4     setosa
#> 24           4.6         3.6            1         0.2     setosa
#> 25           5.1         3.3          1.7         0.5     setosa
#> 26           4.8         3.4          1.9         0.2     setosa
#> 27             5           3          1.6         0.2     setosa
#> 28             5         3.4          1.6         0.4     setosa
#> 29           5.2         3.5          1.5         0.2     setosa
#> 30           5.2         3.4          1.4         0.2     setosa
#> 31           4.7         3.2          1.6         0.2     setosa
#> 32           4.8         3.1          1.6         0.2     setosa
#> 33           5.4         3.4          1.5         0.4     setosa
#> 34           5.2         4.1          1.5         0.1     setosa
#> 35           5.5         4.2          1.4         0.2     setosa
#> 36           4.9         3.1          1.5         0.2     setosa
#> 37             5         3.2          1.2         0.2     setosa
#> 38           5.5         3.5          1.3         0.2     setosa
#> 39           4.9         3.6          1.4         0.1     setosa
#> 40           4.4           3          1.3         0.2     setosa
#> 41           5.1         3.4          1.5         0.2     setosa
#> 42             5         3.5          1.3         0.3     setosa
#> 43           4.5         2.3          1.3         0.3     setosa
#> 44           4.4         3.2          1.3         0.2     setosa
#> 45             5         3.5          1.6         0.6     setosa
#> 46           5.1         3.8          1.9         0.4     setosa
#> 47           4.8           3          1.4         0.3     setosa
#> 48           5.1         3.8          1.6         0.2     setosa
#> 49           4.6         3.2          1.4         0.2     setosa
#> 50           5.3         3.7          1.5         0.2     setosa
#> 51             5         3.3          1.4         0.2     setosa
#> 52             7         3.2          4.7         1.4 versicolor
#> 53           6.4         3.2          4.5         1.5 versicolor
#> 54           6.9         3.1          4.9         1.5 versicolor
#> 55           5.5         2.3            4         1.3 versicolor
#> 56           6.5         2.8          4.6         1.5 versicolor
#> 57           5.7         2.8          4.5         1.3 versicolor
#> 58           6.3         3.3          4.7         1.6 versicolor
#> 59           4.9         2.4          3.3           1 versicolor
#> 60           6.6         2.9          4.6         1.3 versicolor
#> 61           5.2         2.7          3.9         1.4 versicolor
#> 62             5           2          3.5           1 versicolor
#> 63           5.9           3          4.2         1.5 versicolor
#> 64             6         2.2            4           1 versicolor
#> 65           6.1         2.9          4.7         1.4 versicolor
#> 66           5.6         2.9          3.6         1.3 versicolor
#> 67           6.7         3.1          4.4         1.4 versicolor
#> 68           5.6           3          4.5         1.5 versicolor
#> 69           5.8         2.7          4.1           1 versicolor
#> 70           6.2         2.2          4.5         1.5 versicolor
#> 71           5.6         2.5          3.9         1.1 versicolor
#> 72           5.9         3.2          4.8         1.8 versicolor
#> 73           6.1         2.8            4         1.3 versicolor
#> 74           6.3         2.5          4.9         1.5 versicolor
#> 75           6.1         2.8          4.7         1.2 versicolor
#> 76           6.4         2.9          4.3         1.3 versicolor
#> 77           6.6           3          4.4         1.4 versicolor
#> 78           6.8         2.8          4.8         1.4 versicolor
#> 79           6.7           3            5         1.7 versicolor
#> 80             6         2.9          4.5         1.5 versicolor
#> 81           5.7         2.6          3.5           1 versicolor
#> 82           5.5         2.4          3.8         1.1 versicolor
#> 83           5.5         2.4          3.7           1 versicolor
#> 84           5.8         2.7          3.9         1.2 versicolor
#> 85             6         2.7          5.1         1.6 versicolor
#> 86           5.4           3          4.5         1.5 versicolor
#> 87             6         3.4          4.5         1.6 versicolor
#> 88           6.7         3.1          4.7         1.5 versicolor
#> 89           6.3         2.3          4.4         1.3 versicolor
#> 90           5.6           3          4.1         1.3 versicolor
#> 91           5.5         2.5            4         1.3 versicolor
#> 92           5.5         2.6          4.4         1.2 versicolor
#> 93           6.1           3          4.6         1.4 versicolor
#> 94           5.8         2.6            4         1.2 versicolor
#> 95             5         2.3          3.3           1 versicolor
#> 96           5.6         2.7          4.2         1.3 versicolor
#> 97           5.7           3          4.2         1.2 versicolor
#> 98           5.7         2.9          4.2         1.3 versicolor
#> 99           6.2         2.9          4.3         1.3 versicolor
#> 100          5.1         2.5            3         1.1 versicolor
#> 101          5.7         2.8          4.1         1.3 versicolor
#> 102          6.3         3.3            6         2.5  virginica
#> 103          5.8         2.7          5.1         1.9  virginica
#> 104          7.1           3          5.9         2.1  virginica
#> 105          6.3         2.9          5.6         1.8  virginica
#> 106          6.5           3          5.8         2.2  virginica
#> 107          7.6           3          6.6         2.1  virginica
#> 108          4.9         2.5          4.5         1.7  virginica
#> 109          7.3         2.9          6.3         1.8  virginica
#> 110          6.7         2.5          5.8         1.8  virginica
#> 111          7.2         3.6          6.1         2.5  virginica
#> 112          6.5         3.2          5.1           2  virginica
#> 113          6.4         2.7          5.3         1.9  virginica
#> 114          6.8           3          5.5         2.1  virginica
#> 115          5.7         2.5            5           2  virginica
#> 116          5.8         2.8          5.1         2.4  virginica
#> 117          6.4         3.2          5.3         2.3  virginica
#> 118          6.5           3          5.5         1.8  virginica
#> 119          7.7         3.8          6.7         2.2  virginica
#> 120          7.7         2.6          6.9         2.3  virginica
#> 121            6         2.2            5         1.5  virginica
#> 122          6.9         3.2          5.7         2.3  virginica
#> 123          5.6         2.8          4.9           2  virginica
#> 124          7.7         2.8          6.7           2  virginica
#> 125          6.3         2.7          4.9         1.8  virginica
#> 126          6.7         3.3          5.7         2.1  virginica
#> 127          7.2         3.2            6         1.8  virginica
#> 128          6.2         2.8          4.8         1.8  virginica
#> 129          6.1           3          4.9         1.8  virginica
#> 130          6.4         2.8          5.6         2.1  virginica
#> 131          7.2           3          5.8         1.6  virginica
#> 132          7.4         2.8          6.1         1.9  virginica
#> 133          7.9         3.8          6.4           2  virginica
#> 134          6.4         2.8          5.6         2.2  virginica
#> 135          6.3         2.8          5.1         1.5  virginica
#> 136          6.1         2.6          5.6         1.4  virginica
#> 137          7.7           3          6.1         2.3  virginica
#> 138          6.3         3.4          5.6         2.4  virginica
#> 139          6.4         3.1          5.5         1.8  virginica
#> 140            6           3          4.8         1.8  virginica
#> 141          6.9         3.1          5.4         2.1  virginica
#> 142          6.7         3.1          5.6         2.4  virginica
#> 143          6.9         3.1          5.1         2.3  virginica
#> 144          5.8         2.7          5.1         1.9  virginica
#> 145          6.8         3.2          5.9         2.3  virginica
#> 146          6.7         3.3          5.7         2.5  virginica
#> 147          6.7           3          5.2         2.3  virginica
#> 148          6.3         2.5            5         1.9  virginica
#> 149          6.5           3          5.2           2  virginica
#> 150          6.2         3.4          5.4         2.3  virginica
#> 151          5.9           3          5.1         1.8  virginica
colnames_to_row(iris, row = 5)
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 1            5.1         3.5          1.4         0.2     setosa
#> 2            4.9           3          1.4         0.2     setosa
#> 3            4.7         3.2          1.3         0.2     setosa
#> 4            4.6         3.1          1.5         0.2     setosa
#> 5   Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 6              5         3.6          1.4         0.2     setosa
#> 7            5.4         3.9          1.7         0.4     setosa
#> 8            4.6         3.4          1.4         0.3     setosa
#> 9              5         3.4          1.5         0.2     setosa
#> 10           4.4         2.9          1.4         0.2     setosa
#> 11           4.9         3.1          1.5         0.1     setosa
#> 12           5.4         3.7          1.5         0.2     setosa
#> 13           4.8         3.4          1.6         0.2     setosa
#> 14           4.8           3          1.4         0.1     setosa
#> 15           4.3           3          1.1         0.1     setosa
#> 16           5.8           4          1.2         0.2     setosa
#> 17           5.7         4.4          1.5         0.4     setosa
#> 18           5.4         3.9          1.3         0.4     setosa
#> 19           5.1         3.5          1.4         0.3     setosa
#> 20           5.7         3.8          1.7         0.3     setosa
#> 21           5.1         3.8          1.5         0.3     setosa
#> 22           5.4         3.4          1.7         0.2     setosa
#> 23           5.1         3.7          1.5         0.4     setosa
#> 24           4.6         3.6            1         0.2     setosa
#> 25           5.1         3.3          1.7         0.5     setosa
#> 26           4.8         3.4          1.9         0.2     setosa
#> 27             5           3          1.6         0.2     setosa
#> 28             5         3.4          1.6         0.4     setosa
#> 29           5.2         3.5          1.5         0.2     setosa
#> 30           5.2         3.4          1.4         0.2     setosa
#> 31           4.7         3.2          1.6         0.2     setosa
#> 32           4.8         3.1          1.6         0.2     setosa
#> 33           5.4         3.4          1.5         0.4     setosa
#> 34           5.2         4.1          1.5         0.1     setosa
#> 35           5.5         4.2          1.4         0.2     setosa
#> 36           4.9         3.1          1.5         0.2     setosa
#> 37             5         3.2          1.2         0.2     setosa
#> 38           5.5         3.5          1.3         0.2     setosa
#> 39           4.9         3.6          1.4         0.1     setosa
#> 40           4.4           3          1.3         0.2     setosa
#> 41           5.1         3.4          1.5         0.2     setosa
#> 42             5         3.5          1.3         0.3     setosa
#> 43           4.5         2.3          1.3         0.3     setosa
#> 44           4.4         3.2          1.3         0.2     setosa
#> 45             5         3.5          1.6         0.6     setosa
#> 46           5.1         3.8          1.9         0.4     setosa
#> 47           4.8           3          1.4         0.3     setosa
#> 48           5.1         3.8          1.6         0.2     setosa
#> 49           4.6         3.2          1.4         0.2     setosa
#> 50           5.3         3.7          1.5         0.2     setosa
#> 51             5         3.3          1.4         0.2     setosa
#> 52             7         3.2          4.7         1.4 versicolor
#> 53           6.4         3.2          4.5         1.5 versicolor
#> 54           6.9         3.1          4.9         1.5 versicolor
#> 55           5.5         2.3            4         1.3 versicolor
#> 56           6.5         2.8          4.6         1.5 versicolor
#> 57           5.7         2.8          4.5         1.3 versicolor
#> 58           6.3         3.3          4.7         1.6 versicolor
#> 59           4.9         2.4          3.3           1 versicolor
#> 60           6.6         2.9          4.6         1.3 versicolor
#> 61           5.2         2.7          3.9         1.4 versicolor
#> 62             5           2          3.5           1 versicolor
#> 63           5.9           3          4.2         1.5 versicolor
#> 64             6         2.2            4           1 versicolor
#> 65           6.1         2.9          4.7         1.4 versicolor
#> 66           5.6         2.9          3.6         1.3 versicolor
#> 67           6.7         3.1          4.4         1.4 versicolor
#> 68           5.6           3          4.5         1.5 versicolor
#> 69           5.8         2.7          4.1           1 versicolor
#> 70           6.2         2.2          4.5         1.5 versicolor
#> 71           5.6         2.5          3.9         1.1 versicolor
#> 72           5.9         3.2          4.8         1.8 versicolor
#> 73           6.1         2.8            4         1.3 versicolor
#> 74           6.3         2.5          4.9         1.5 versicolor
#> 75           6.1         2.8          4.7         1.2 versicolor
#> 76           6.4         2.9          4.3         1.3 versicolor
#> 77           6.6           3          4.4         1.4 versicolor
#> 78           6.8         2.8          4.8         1.4 versicolor
#> 79           6.7           3            5         1.7 versicolor
#> 80             6         2.9          4.5         1.5 versicolor
#> 81           5.7         2.6          3.5           1 versicolor
#> 82           5.5         2.4          3.8         1.1 versicolor
#> 83           5.5         2.4          3.7           1 versicolor
#> 84           5.8         2.7          3.9         1.2 versicolor
#> 85             6         2.7          5.1         1.6 versicolor
#> 86           5.4           3          4.5         1.5 versicolor
#> 87             6         3.4          4.5         1.6 versicolor
#> 88           6.7         3.1          4.7         1.5 versicolor
#> 89           6.3         2.3          4.4         1.3 versicolor
#> 90           5.6           3          4.1         1.3 versicolor
#> 91           5.5         2.5            4         1.3 versicolor
#> 92           5.5         2.6          4.4         1.2 versicolor
#> 93           6.1           3          4.6         1.4 versicolor
#> 94           5.8         2.6            4         1.2 versicolor
#> 95             5         2.3          3.3           1 versicolor
#> 96           5.6         2.7          4.2         1.3 versicolor
#> 97           5.7           3          4.2         1.2 versicolor
#> 98           5.7         2.9          4.2         1.3 versicolor
#> 99           6.2         2.9          4.3         1.3 versicolor
#> 100          5.1         2.5            3         1.1 versicolor
#> 101          5.7         2.8          4.1         1.3 versicolor
#> 102          6.3         3.3            6         2.5  virginica
#> 103          5.8         2.7          5.1         1.9  virginica
#> 104          7.1           3          5.9         2.1  virginica
#> 105          6.3         2.9          5.6         1.8  virginica
#> 106          6.5           3          5.8         2.2  virginica
#> 107          7.6           3          6.6         2.1  virginica
#> 108          4.9         2.5          4.5         1.7  virginica
#> 109          7.3         2.9          6.3         1.8  virginica
#> 110          6.7         2.5          5.8         1.8  virginica
#> 111          7.2         3.6          6.1         2.5  virginica
#> 112          6.5         3.2          5.1           2  virginica
#> 113          6.4         2.7          5.3         1.9  virginica
#> 114          6.8           3          5.5         2.1  virginica
#> 115          5.7         2.5            5           2  virginica
#> 116          5.8         2.8          5.1         2.4  virginica
#> 117          6.4         3.2          5.3         2.3  virginica
#> 118          6.5           3          5.5         1.8  virginica
#> 119          7.7         3.8          6.7         2.2  virginica
#> 120          7.7         2.6          6.9         2.3  virginica
#> 121            6         2.2            5         1.5  virginica
#> 122          6.9         3.2          5.7         2.3  virginica
#> 123          5.6         2.8          4.9           2  virginica
#> 124          7.7         2.8          6.7           2  virginica
#> 125          6.3         2.7          4.9         1.8  virginica
#> 126          6.7         3.3          5.7         2.1  virginica
#> 127          7.2         3.2            6         1.8  virginica
#> 128          6.2         2.8          4.8         1.8  virginica
#> 129          6.1           3          4.9         1.8  virginica
#> 130          6.4         2.8          5.6         2.1  virginica
#> 131          7.2           3          5.8         1.6  virginica
#> 132          7.4         2.8          6.1         1.9  virginica
#> 133          7.9         3.8          6.4           2  virginica
#> 134          6.4         2.8          5.6         2.2  virginica
#> 135          6.3         2.8          5.1         1.5  virginica
#> 136          6.1         2.6          5.6         1.4  virginica
#> 137          7.7           3          6.1         2.3  virginica
#> 138          6.3         3.4          5.6         2.4  virginica
#> 139          6.4         3.1          5.5         1.8  virginica
#> 140            6           3          4.8         1.8  virginica
#> 141          6.9         3.1          5.4         2.1  virginica
#> 142          6.7         3.1          5.6         2.4  virginica
#> 143          6.9         3.1          5.1         2.3  virginica
#> 144          5.8         2.7          5.1         1.9  virginica
#> 145          6.8         3.2          5.9         2.3  virginica
#> 146          6.7         3.3          5.7         2.5  virginica
#> 147          6.7           3          5.2         2.3  virginica
#> 148          6.3         2.5            5         1.9  virginica
#> 149          6.5           3          5.2           2  virginica
#> 150          6.2         3.4          5.4         2.3  virginica
#> 151          5.9           3          5.1         1.8  virginica
```
