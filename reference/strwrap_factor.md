# String wrapping for factor variables

String wrapping for factor variables

## Usage

``` r
strwrap_factor(x, width, ...)
```

## Arguments

- x:

  a factor vector

- width:

  Positive integer giving target line width (in number of characters). A
  width less than or equal to 1 will put each word on its own line.

- ...:

  arguments passed to
  [`stringr::str_wrap`](https://stringr.tidyverse.org/reference/str_wrap.html)

## Value

a factor vector the same length as `x` with factor levels wrapped

## Examples

``` r
nt_yorks <- factor(c("Beningbrough Hall (Historic House)",
                     "Braithwaite Hall (Historic Property)",
                     "Brimham Rocks (Countryside)",
                     "East Riddlesden Hall (Historic House)",
                     "Fountains Abbey (Abbey)",
                     "Gibson's Mill (Historic Property)",
                     "Goddards House & Garden (Historic House)",
                     "Hardcastle Crags (Countryside)",
                     "Hudswell Woods (Countryside)",
                     "Maister House (Historic Property)",
                     "Moulton Hall (Historic Property)",
                     "Nostell Priory (Historic House)",
                     "Nunnington Hall (Historic Property)",
                     "Rievaulx Terrace and Temples (Garden)",
                     "Roseberry Topping (Countryside)",
                     "Studley Royal Water Garden (Garden)",
                     "The Bridestones (Countryside)",
                     "Treasurers House (Historic Property)"))

strwrap_factor(nt_yorks, width = 10)
#>  [1] Beningbrough\nHall\n(Historic\nHouse)       
#>  [2] Braithwaite\nHall\n(Historic\nProperty)     
#>  [3] Brimham\nRocks\n(Countryside)               
#>  [4] East\nRiddlesden\nHall\n(Historic\nHouse)   
#>  [5] Fountains\nAbbey\n(Abbey)                   
#>  [6] Gibson's\nMill\n(Historic\nProperty)        
#>  [7] Goddards\nHouse &\nGarden\n(Historic\nHouse)
#>  [8] Hardcastle\nCrags\n(Countryside)            
#>  [9] Hudswell\nWoods\n(Countryside)              
#> [10] Maister\nHouse\n(Historic\nProperty)        
#> [11] Moulton\nHall\n(Historic\nProperty)         
#> [12] Nostell\nPriory\n(Historic\nHouse)          
#> [13] Nunnington\nHall\n(Historic\nProperty)      
#> [14] Rievaulx\nTerrace\nand\nTemples\n(Garden)   
#> [15] Roseberry\nTopping\n(Countryside)           
#> [16] Studley\nRoyal\nWater\nGarden\n(Garden)     
#> [17] The\nBridestones\n(Countryside)             
#> [18] Treasurers\nHouse\n(Historic\nProperty)     
#> 18 Levels: Beningbrough\nHall\n(Historic\nHouse) ...
```
