# grouping works

    Code
      discrete_table(outcome, sex, group = group, total = T)
    Output
      # A tibble: 5 x 5
        variable scoring               A           B           Total      
        <chr>    <chr>                 <chr>       <chr>       <chr>      
      1 <NA>     <NA>                  N = 276     N = 324     N = 600    
      2 sex      Female                144 (52.2%) 159 (49.1%) 303 (50.5%)
      3 sex      Male                  129 (46.7%) 162 (50.0%) 291 (48.5%)
      4 sex      Prefer not to specify 0 (0.0%)    0 (0.0%)    0 (0.0%)   
      5 sex      Missing               3 (1.1%)    3 (0.9%)    6 (1.0%)   

---

    Code
      discrete_table(outcome, sex, group = group, total = F)
    Output
      # A tibble: 5 x 4
        variable scoring               A           B          
        <chr>    <chr>                 <chr>       <chr>      
      1 <NA>     <NA>                  N = 276     N = 324    
      2 sex      Female                144 (52.2%) 159 (49.1%)
      3 sex      Male                  129 (46.7%) 162 (50.0%)
      4 sex      Prefer not to specify 0 (0.0%)    0 (0.0%)   
      5 sex      Missing               3 (1.1%)    3 (0.9%)   

# accuracy works

    Code
      discrete_table(outcome, sex, accuracy = 1)
    Output
      # A tibble: 5 x 3
        variable scoring               value    
        <chr>    <chr>                 <chr>    
      1 <NA>     <NA>                  N = 600  
      2 sex      Female                303 (50%)
      3 sex      Male                  291 (48%)
      4 sex      Prefer not to specify 0 (0%)   
      5 sex      Missing               6 (1%)   

---

    Code
      discrete_table(outcome, sex)
    Output
      # A tibble: 5 x 3
        variable scoring               value      
        <chr>    <chr>                 <chr>      
      1 <NA>     <NA>                  N = 600    
      2 sex      Female                303 (50.5%)
      3 sex      Male                  291 (48.5%)
      4 sex      Prefer not to specify 0 (0.0%)   
      5 sex      Missing               6 (1.0%)   

---

    Code
      discrete_table(outcome, sex, accuracy = 0.01)
    Output
      # A tibble: 5 x 3
        variable scoring               value       
        <chr>    <chr>                 <chr>       
      1 <NA>     <NA>                  N = 600     
      2 sex      Female                303 (50.50%)
      3 sex      Male                  291 (48.50%)
      4 sex      Prefer not to specify 0 (0.00%)   
      5 sex      Missing               6 (1.00%)   

# n works

    Code
      discrete_table(outcome, sex, n = T)
    Output
      # A tibble: 5 x 3
        variable scoring               value      
        <chr>    <chr>                 <chr>      
      1 <NA>     <NA>                  N = 600    
      2 sex      n                     594        
      3 sex      Female                303 (51.0%)
      4 sex      Male                  291 (49.0%)
      5 sex      Prefer not to specify 0 (0.0%)   

---

    Code
      discrete_table(outcome, sex, group = group, n = T)
    Output
      # A tibble: 5 x 5
        variable scoring               A           B           Total      
        <chr>    <chr>                 <chr>       <chr>       <chr>      
      1 <NA>     <NA>                  N = 276     N = 324     N = 600    
      2 sex      n                     273         321         594        
      3 sex      Female                144 (52.7%) 159 (49.5%) 303 (51.0%)
      4 sex      Male                  129 (47.3%) 162 (50.5%) 291 (49.0%)
      5 sex      Prefer not to specify 0 (0.0%)    0 (0.0%)    0 (0.0%)   

---

    Code
      discrete_table(outcome, sex, group = group, n = F)
    Output
      # A tibble: 5 x 5
        variable scoring               A           B           Total      
        <chr>    <chr>                 <chr>       <chr>       <chr>      
      1 <NA>     <NA>                  N = 276     N = 324     N = 600    
      2 sex      Female                144 (52.2%) 159 (49.1%) 303 (50.5%)
      3 sex      Male                  129 (46.7%) 162 (50.0%) 291 (48.5%)
      4 sex      Prefer not to specify 0 (0.0%)    0 (0.0%)    0 (0.0%)   
      5 sex      Missing               3 (1.1%)    3 (0.9%)    6 (1.0%)   

# drop.levels works

    Code
      discrete_table(outcome, sex, drop.levels = F)
    Output
      # A tibble: 5 x 3
        variable scoring               value      
        <chr>    <chr>                 <chr>      
      1 <NA>     <NA>                  N = 600    
      2 sex      Female                303 (50.5%)
      3 sex      Male                  291 (48.5%)
      4 sex      Prefer not to specify 0 (0.0%)   
      5 sex      Missing               6 (1.0%)   

---

    Code
      discrete_table(outcome, sex, drop.levels = T)
    Output
      # A tibble: 4 x 3
        variable scoring value      
        <chr>    <chr>   <chr>      
      1 <NA>     <NA>    N = 600    
      2 sex      Female  303 (50.5%)
      3 sex      Male    291 (48.5%)
      4 sex      Missing 6 (1.0%)   

---

    Code
      discrete_table(outcome, sex, drop.levels = T, group = group)
    Output
      # A tibble: 4 x 5
        variable scoring A           B           Total      
        <chr>    <chr>   <chr>       <chr>       <chr>      
      1 <NA>     <NA>    N = 276     N = 324     N = 600    
      2 sex      Female  144 (52.2%) 159 (49.1%) 303 (50.5%)
      3 sex      Male    129 (46.7%) 162 (50.0%) 291 (48.5%)
      4 sex      Missing 3 (1.1%)    3 (0.9%)    6 (1.0%)   

---

    Code
      discrete_table(outcome, sex, drop.levels = T, n = T)
    Output
      # A tibble: 4 x 3
        variable scoring value      
        <chr>    <chr>   <chr>      
      1 <NA>     <NA>    N = 600    
      2 sex      n       594        
      3 sex      Female  303 (51.0%)
      4 sex      Male    291 (49.0%)

# missing works

    Code
      discrete_table(outcome, sex, missing = "Unknown")
    Output
      # A tibble: 5 x 3
        variable scoring               value      
        <chr>    <chr>                 <chr>      
      1 <NA>     <NA>                  N = 600    
      2 sex      Female                303 (50.5%)
      3 sex      Male                  291 (48.5%)
      4 sex      Prefer not to specify 0 (0.0%)   
      5 sex      Unknown               6 (1.0%)   

---

    Code
      discrete_table(outcome, sex, missing = "Unknown", n = T)
    Condition
      Warning in `discrete_table()`:
      You have specified a string for `missing` when `n = TRUE`, `missing` will be ignored
    Output
      # A tibble: 5 x 3
        variable scoring               value      
        <chr>    <chr>                 <chr>      
      1 <NA>     <NA>                  N = 600    
      2 sex      n                     594        
      3 sex      Female                303 (51.0%)
      4 sex      Male                  291 (49.0%)
      5 sex      Prefer not to specify 0 (0.0%)   

# total works

    Code
      discrete_table(outcome, sex, total = F)
    Condition
      Warning in `discrete_table()`:
      You have specified `total=FALSE` without `group`, `total` will be ignored
    Output
      # A tibble: 5 x 3
        variable scoring               value      
        <chr>    <chr>                 <chr>      
      1 <NA>     <NA>                  N = 600    
      2 sex      Female                303 (50.5%)
      3 sex      Male                  291 (48.5%)
      4 sex      Prefer not to specify 0 (0.0%)   
      5 sex      Missing               6 (1.0%)   

---

    Code
      discrete_table(outcome, sex, group = group, total = F)
    Output
      # A tibble: 5 x 4
        variable scoring               A           B          
        <chr>    <chr>                 <chr>       <chr>      
      1 <NA>     <NA>                  N = 276     N = 324    
      2 sex      Female                144 (52.2%) 159 (49.1%)
      3 sex      Male                  129 (46.7%) 162 (50.0%)
      4 sex      Prefer not to specify 0 (0.0%)    0 (0.0%)   
      5 sex      Missing               3 (1.1%)    3 (0.9%)   

---

    Code
      discrete_table(outcome, sex, group = group, total = T)
    Output
      # A tibble: 5 x 5
        variable scoring               A           B           Total      
        <chr>    <chr>                 <chr>       <chr>       <chr>      
      1 <NA>     <NA>                  N = 276     N = 324     N = 600    
      2 sex      Female                144 (52.2%) 159 (49.1%) 303 (50.5%)
      3 sex      Male                  129 (46.7%) 162 (50.0%) 291 (48.5%)
      4 sex      Prefer not to specify 0 (0.0%)    0 (0.0%)    0 (0.0%)   
      5 sex      Missing               3 (1.1%)    3 (0.9%)    6 (1.0%)   

# time works

    Code
      discrete_table(outcome, sex, group = group, time = event_name)
    Output
      # A tibble: 13 x 6
         event_name variable scoring               A          B          Total      
         <chr>      <chr>    <chr>                 <chr>      <chr>      <chr>      
       1 <NA>       <NA>     <NA>                  N = 92     N = 108    N = 200    
       2 Baseline   sex      Female                48 (52.2%) 53 (49.1%) 101 (50.5%)
       3 Baseline   sex      Male                  43 (46.7%) 54 (50.0%) 97 (48.5%) 
       4 Baseline   sex      Prefer not to specify 0 (0.0%)   0 (0.0%)   0 (0.0%)   
       5 Baseline   sex      Missing               1 (1.1%)   1 (0.9%)   2 (1.0%)   
       6 6 Weeks    sex      Female                48 (52.2%) 53 (49.1%) 101 (50.5%)
       7 6 Weeks    sex      Male                  43 (46.7%) 54 (50.0%) 97 (48.5%) 
       8 6 Weeks    sex      Prefer not to specify 0 (0.0%)   0 (0.0%)   0 (0.0%)   
       9 6 Weeks    sex      Missing               1 (1.1%)   1 (0.9%)   2 (1.0%)   
      10 12 Weeks   sex      Female                48 (52.2%) 53 (49.1%) 101 (50.5%)
      11 12 Weeks   sex      Male                  43 (46.7%) 54 (50.0%) 97 (48.5%) 
      12 12 Weeks   sex      Prefer not to specify 0 (0.0%)   0 (0.0%)   0 (0.0%)   
      13 12 Weeks   sex      Missing               1 (1.1%)   1 (0.9%)   2 (1.0%)   

