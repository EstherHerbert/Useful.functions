# works with summary tables

    Code
      condense(discrete_table(outcome, sex, pain, group = group))
    Output
      # A tibble: 11 x 4
         variable                       A           B           Total      
         <chr>                          <chr>       <chr>       <chr>      
       1  <NA>                          N = 276     N = 324     N = 600    
       2 "\\hline\n sex"                <NA>        <NA>        <NA>       
       3 "\\quad Female"                144 (52.2%) 159 (49.1%) 303 (50.5%)
       4 "\\quad Male"                  129 (46.7%) 162 (50.0%) 291 (48.5%)
       5 "\\quad Prefer not to specify" 0 (0.0%)    0 (0.0%)    0 (0.0%)   
       6 "\\quad Missing"               3 (1.1%)    3 (0.9%)    6 (1.0%)   
       7 "\\hline\n pain"               <NA>        <NA>        <NA>       
       8 "\\quad Low"                   124 (44.9%) 107 (33.0%) 231 (38.5%)
       9 "\\quad Medium"                147 (53.3%) 101 (31.2%) 248 (41.3%)
      10 "\\quad High"                  0 (0.0%)    109 (33.6%) 109 (18.2%)
      11 "\\quad Missing"               5 (1.8%)    7 (2.2%)    12 (2.0%)  

---

    Code
      condense(continuous_table(outcome, score, group = group))
    Output
      # A tibble: 5 x 4
        variable              A                 B                 Total            
        <chr>                 <chr>             <chr>             <chr>            
      1  <NA>                 N = 276           N = 324           N = 600          
      2 "\\hline\n score"     247               280               527              
      3 "\\quad Mean (SD)"    4.12 (2.23)       6.46 (3.04)       5.36 (2.93)      
      4 "\\quad Median (IQR)" 4.27 (2.59, 5.54) 6.20 (4.45, 8.74) 5.11 (3.24, 7.22)
      5 "\\quad Min, Max"     -2.24, 9.89       -1.01, 14.58      -2.24, 14.58     

---

    Code
      condense(continuous_table(outcome, score, group = group, time = event_name),
      first_col = event_name, second_col = variable, third_col = scoring)
    Output
      # A tibble: 16 x 4
         event_name                   A                 B                  Total      
         <chr>                        <chr>             <chr>              <chr>      
       1  <NA>                        N = 92            N = 108            N = 200    
       2 "\\hline\n Baseline"         <NA>              <NA>               <NA>       
       3 "\\quad score"               83                93                 176        
       4 "\\qquad\\quad Mean (SD)"    4.12 (2.06)       3.83 (1.93)        3.97 (1.99)
       5 "\\qquad\\quad Median (IQR)" 4.11 (2.69, 5.30) 4.22 (2.14, 5.26)  4.18 (2.49~
       6 "\\qquad\\quad Min, Max"     -0.39, 9.26       -1.01, 8.14        -1.01, 9.26
       7 "\\hline\n 6 Weeks"          <NA>              <NA>               <NA>       
       8 "\\quad score"               82                92                 174        
       9 "\\qquad\\quad Mean (SD)"    4.09 (2.16)       6.77 (2.27)        5.51 (2.58)
      10 "\\qquad\\quad Median (IQR)" 4.28 (2.70, 5.66) 7.06 (5.03, 8.63)  5.42 (3.73~
      11 "\\qquad\\quad Min, Max"     -2.17, 9.85       0.53, 11.03        -2.17, 11.~
      12 "\\hline\n 12 Weeks"         <NA>              <NA>               <NA>       
      13 "\\quad score"               82                95                 177        
      14 "\\qquad\\quad Mean (SD)"    4.14 (2.48)       8.74 (2.58)        6.61 (3.41)
      15 "\\qquad\\quad Median (IQR)" 4.45 (2.26, 5.59) 9.10 (6.76, 10.79) 6.52 (4.53~
      16 "\\qquad\\quad Min, Max"     -2.24, 9.89       2.86, 14.58        -2.24, 14.~

# hline works

    Code
      condense(discrete_table(outcome, sex, group = group), hline = F)
    Output
      # A tibble: 6 x 4
        variable                       A           B           Total      
        <chr>                          <chr>       <chr>       <chr>      
      1  <NA>                          N = 276     N = 324     N = 600    
      2 " sex"                         <NA>        <NA>        <NA>       
      3 "\\quad Female"                144 (52.2%) 159 (49.1%) 303 (50.5%)
      4 "\\quad Male"                  129 (46.7%) 162 (50.0%) 291 (48.5%)
      5 "\\quad Prefer not to specify" 0 (0.0%)    0 (0.0%)    0 (0.0%)   
      6 "\\quad Missing"               3 (1.1%)    3 (0.9%)    6 (1.0%)   

# different indent options

    Code
      condense(discrete_table(outcome, sex, group = group), indent = "hang")
    Output
      # A tibble: 6 x 4
        variable                                            A           B        Total
        <chr>                                               <chr>       <chr>    <chr>
      1  <NA>                                               N = 276     N = 324  N = ~
      2 "\\hline\n sex"                                     <NA>        <NA>     <NA> 
      3 "\\hangindent2em\\hangafter0 Female"                144 (52.2%) 159 (49~ 303 ~
      4 "\\hangindent2em\\hangafter0 Male"                  129 (46.7%) 162 (50~ 291 ~
      5 "\\hangindent2em\\hangafter0 Prefer not to specify" 0 (0.0%)    0 (0.0%) 0 (0~
      6 "\\hangindent2em\\hangafter0 Missing"               3 (1.1%)    3 (0.9%) 6 (1~

---

    Code
      condense(discrete_table(outcome, sex, group = group), indent = "space")
    Output
      # A tibble: 6 x 4
        variable                     A           B           Total      
        <chr>                        <chr>       <chr>       <chr>      
      1  <NA>                        N = 276     N = 324     N = 600    
      2 "\\hline\n sex"              <NA>        <NA>        <NA>       
      3 "     Female"                144 (52.2%) 159 (49.1%) 303 (50.5%)
      4 "     Male"                  129 (46.7%) 162 (50.0%) 291 (48.5%)
      5 "     Prefer not to specify" 0 (0.0%)    0 (0.0%)    0 (0.0%)   
      6 "     Missing"               3 (1.1%)    3 (0.9%)    6 (1.0%)   

