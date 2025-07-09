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

# correct when level missing in one grouping

    Code
      discrete_table(outcome, pain, group = group, drop.levels = T)
    Output
      # A tibble: 5 x 5
        variable scoring A           B           Total      
        <chr>    <chr>   <chr>       <chr>       <chr>      
      1 <NA>     <NA>    N = 276     N = 324     N = 600    
      2 pain     Low     124 (44.9%) 107 (33.0%) 231 (38.5%)
      3 pain     Medium  147 (53.3%) 101 (31.2%) 248 (41.3%)
      4 pain     High    0 (0.0%)    109 (33.6%) 109 (18.2%)
      5 pain     Missing 5 (1.8%)    7 (2.2%)    12 (2.0%)  

---

    Code
      discrete_table(outcome, pain, group = group, time = event_name, drop.levels = T)
    Output
      # A tibble: 13 x 6
         event_name variable scoring A          B          Total     
         <chr>      <chr>    <chr>   <chr>      <chr>      <chr>     
       1 <NA>       <NA>     <NA>    N = 92     N = 108    N = 200   
       2 Baseline   pain     Low     40 (43.5%) 32 (29.6%) 72 (36.0%)
       3 Baseline   pain     Medium  51 (55.4%) 36 (33.3%) 87 (43.5%)
       4 Baseline   pain     High    0 (0.0%)   37 (34.3%) 37 (18.5%)
       5 Baseline   pain     Missing 1 (1.1%)   3 (2.8%)   4 (2.0%)  
       6 6 Weeks    pain     Low     42 (45.7%) 41 (38.0%) 83 (41.5%)
       7 6 Weeks    pain     Medium  48 (52.2%) 35 (32.4%) 83 (41.5%)
       8 6 Weeks    pain     High    0 (0.0%)   31 (28.7%) 31 (15.5%)
       9 6 Weeks    pain     Missing 2 (2.2%)   1 (0.9%)   3 (1.5%)  
      10 12 Weeks   pain     Low     42 (45.7%) 34 (31.5%) 76 (38.0%)
      11 12 Weeks   pain     Medium  48 (52.2%) 30 (27.8%) 78 (39.0%)
      12 12 Weeks   pain     High    0 (0.0%)   41 (38.0%) 41 (20.5%)
      13 12 Weeks   pain     Missing 2 (2.2%)   3 (2.8%)   5 (2.5%)  

