# WHO_growth_charts Test 1: WHO length/height-for-age for girls

    Code
      who_lgth_ht_for_age_girls
    Output
      # A tibble: 1,857 x 4
           Day     L     M      S
         <int> <int> <dbl>  <dbl>
       1     0     1  49.1 0.0379
       2     1     1  49.3 0.0378
       3     2     1  49.5 0.0378
       4     3     1  49.7 0.0377
       5     4     1  49.8 0.0376
       6     5     1  50.0 0.0376
       7     6     1  50.2 0.0375
       8     7     1  50.3 0.0374
       9     8     1  50.5 0.0374
      10     9     1  50.7 0.0373
      # i 1,847 more rows

# WHO_growth_charts Test 2: WHO length/height-for-age for boys

    Code
      who_lgth_ht_for_age_boys
    Output
      # A tibble: 1,857 x 4
           Day     L     M      S
         <int> <int> <dbl>  <dbl>
       1     0     1  49.9 0.0380
       2     1     1  50.1 0.0378
       3     2     1  50.2 0.0378
       4     3     1  50.4 0.0376
       5     4     1  50.6 0.0375
       6     5     1  50.8 0.0374
       7     6     1  50.9 0.0373
       8     7     1  51.1 0.0372
       9     8     1  51.3 0.0371
      10     9     1  51.5 0.0370
      # i 1,847 more rows

# WHO_growth_charts Test 3: WHO weight-for-age for girls

    Code
      who_wt_for_age_girls
    Output
      # A tibble: 1,857 x 4
           Day     L     M     S
         <int> <dbl> <dbl> <dbl>
       1     0 0.381  3.23 0.142
       2     1 0.326  3.20 0.146
       3     2 0.310  3.21 0.146
       4     3 0.299  3.23 0.147
       5     4 0.289  3.26 0.147
       6     5 0.281  3.28 0.146
       7     6 0.274  3.31 0.146
       8     7 0.267  3.34 0.146
       9     8 0.261  3.37 0.146
      10     9 0.255  3.40 0.145
      # i 1,847 more rows

# WHO_growth_charts Test 4: WHO weight-for-age for boys

    Code
      who_wt_for_age_boys
    Output
      # A tibble: 1,857 x 4
           Day     L     M     S
         <int> <dbl> <dbl> <dbl>
       1     0 0.349  3.35 0.146
       2     1 0.313  3.32 0.147
       3     2 0.303  3.34 0.147
       4     3 0.296  3.36 0.146
       5     4 0.290  3.39 0.146
       6     5 0.286  3.42 0.146
       7     6 0.281  3.45 0.145
       8     7 0.278  3.49 0.145
       9     8 0.274  3.52 0.144
      10     9 0.271  3.56 0.144
      # i 1,847 more rows

# WHO_growth_charts Test 5: WHO weight-for-length for girls

    Code
      who_wt_for_lgth_girls
    Output
      # A tibble: 651 x 4
         Length      L     M      S
          <dbl>  <dbl> <dbl>  <dbl>
       1   45   -0.383  2.46 0.0903
       2   45.1 -0.383  2.48 0.0903
       3   45.2 -0.383  2.49 0.0903
       4   45.3 -0.383  2.51 0.0903
       5   45.4 -0.383  2.53 0.0903
       6   45.5 -0.383  2.55 0.0903
       7   45.6 -0.383  2.56 0.0903
       8   45.7 -0.383  2.58 0.0903
       9   45.8 -0.383  2.60 0.0904
      10   45.9 -0.383  2.61 0.0904
      # i 641 more rows

# WHO_growth_charts Test 6: WHO weight-for-length for boys

    Code
      who_wt_for_lgth_boys
    Output
      # A tibble: 651 x 4
         Length      L     M      S
          <dbl>  <dbl> <dbl>  <dbl>
       1   45   -0.352  2.44 0.0918
       2   45.1 -0.352  2.46 0.0918
       3   45.2 -0.352  2.47 0.0917
       4   45.3 -0.352  2.49 0.0916
       5   45.4 -0.352  2.51 0.0916
       6   45.5 -0.352  2.52 0.0915
       7   45.6 -0.352  2.54 0.0915
       8   45.7 -0.352  2.56 0.0914
       9   45.8 -0.352  2.57 0.0914
      10   45.9 -0.352  2.59 0.0913
      # i 641 more rows

# WHO_growth_charts Test 9: WHO BMI-for-age for girls

    Code
      who_bmi_for_age_girls
    Output
      # A tibble: 1,857 x 4
           Day       L     M      S
         <int>   <dbl> <dbl>  <dbl>
       1     0 -0.0631  13.3 0.0927
       2     1  0.0362  13.3 0.0936
       3     2  0.136   13.3 0.0945
       4     3  0.235   13.3 0.0954
       5     4  0.334   13.3 0.0962
       6     5  0.433   13.2 0.0971
       7     6  0.533   13.2 0.0980
       8     7  0.632   13.2 0.0989
       9     8  0.614   13.2 0.0987
      10     9  0.596   13.3 0.0984
      # i 1,847 more rows

# WHO_growth_charts Test 10: WHO BMI-for-age for boys

    Code
      who_bmi_for_age_boys
    Output
      # A tibble: 1,857 x 4
           Day       L     M      S
         <int>   <dbl> <dbl>  <dbl>
       1     0 -0.305   13.4 0.0956
       2     1 -0.187   13.4 0.0960
       3     2 -0.0681  13.4 0.0963
       4     3  0.0505  13.4 0.0967
       5     4  0.169   13.4 0.0971
       6     5  0.288   13.4 0.0975
       7     6  0.406   13.4 0.0978
       8     7  0.525   13.3 0.0982
       9     8  0.509   13.4 0.0977
      10     9  0.494   13.4 0.0972
      # i 1,847 more rows

# WHO_growth_charts Test 11: WHO Head circumference-for-age for girls

    Code
      who_hc_for_age_girls
    Output
      # A tibble: 1,857 x 4
           Day     L     M      S
         <int> <int> <dbl>  <dbl>
       1     0     1  33.9 0.0350
       2     1     1  34.0 0.0348
       3     2     1  34.1 0.0346
       4     3     1  34.2 0.0344
       5     4     1  34.3 0.0343
       6     5     1  34.4 0.0341
       7     6     1  34.5 0.0339
       8     7     1  34.6 0.0337
       9     8     1  34.6 0.0336
      10     9     1  34.7 0.0334
      # i 1,847 more rows

# WHO_growth_charts Test 12: WHO Head circumference-for-age for boys

    Code
      who_hc_for_age_boys
    Output
      # A tibble: 1,857 x 4
           Day     L     M      S
         <int> <int> <dbl>  <dbl>
       1     0     1  34.5 0.0369
       2     1     1  34.6 0.0366
       3     2     1  34.7 0.0362
       4     3     1  34.8 0.0360
       5     4     1  34.9 0.0356
       6     5     1  35.0 0.0353
       7     6     1  35.1 0.0350
       8     7     1  35.2 0.0347
       9     8     1  35.3 0.0344
      10     9     1  35.4 0.0341
      # i 1,847 more rows

