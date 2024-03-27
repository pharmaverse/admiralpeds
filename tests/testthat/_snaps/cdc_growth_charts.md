# get_cdc_data Test 1: CDC weight-for-age chart

    Code
      admiralpeds::cdc_wtage
    Output
      # A tibble: 436 x 5
           SEX   AGE      L     M     S
         <dbl> <dbl>  <dbl> <dbl> <dbl>
       1     1  24   -0.206  12.7 0.108
       2     1  24.5 -0.217  12.7 0.108
       3     1  25.5 -0.240  12.9 0.108
       4     1  26.5 -0.266  13.0 0.108
       5     1  27.5 -0.296  13.2 0.109
       6     1  28.5 -0.328  13.3 0.109
       7     1  29.5 -0.362  13.4 0.109
       8     1  30.5 -0.398  13.6 0.109
       9     1  31.5 -0.435  13.7 0.110
      10     1  32.5 -0.472  13.8 0.110
      # i 426 more rows

# get_cdc_data Test 2: CDC weight-for-age chart

    Code
      admiralpeds::cdc_htage
    Output
      # A tibble: 436 x 5
           SEX   AGE       L     M      S
         <dbl> <dbl>   <dbl> <dbl>  <dbl>
       1     1  24    0.942   86.5 0.0403
       2     1  24.5  1.01    86.9 0.0404
       3     1  25.5  0.837   87.7 0.0406
       4     1  26.5  0.681   88.4 0.0407
       5     1  27.5  0.539   89.2 0.0408
       6     1  28.5  0.408   89.9 0.0409
       7     1  29.5  0.287   90.6 0.0410
       8     1  30.5  0.174   91.3 0.0410
       9     1  31.5  0.0694  92.0 0.0409
      10     1  32.5 -0.0297  92.7 0.0409
      # i 426 more rows

# get_cdc_data Test 3: CDC weight-for-age chart

    Code
      admiralpeds::cdc_bmiage
    Output
      # A tibble: 438 x 5
           SEX   AGE     L     M      S
         <dbl> <dbl> <dbl> <dbl>  <dbl>
       1     1  24   -2.01  16.6 0.0806
       2     1  24.5 -1.98  16.5 0.0801
       3     1  25.5 -1.92  16.5 0.0792
       4     1  26.5 -1.87  16.4 0.0784
       5     1  27.5 -1.81  16.4 0.0776
       6     1  28.5 -1.75  16.3 0.0768
       7     1  29.5 -1.69  16.3 0.0761
       8     1  30.5 -1.64  16.2 0.0755
       9     1  31.5 -1.59  16.2 0.0749
      10     1  32.5 -1.55  16.2 0.0743
      # i 428 more rows

