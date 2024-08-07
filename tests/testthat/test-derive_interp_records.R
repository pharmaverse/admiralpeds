# derive_interp_records ----

## Test 1: derive_interp_records parameter is not `NULL` ----
test_that("derive_interp_records Test 1 : parameter must be not NULL", {
  expect_error(derive_interp_records(parameter = NA_character_))
  expect_error(derive_interp_records(parameter = ""))
  expect_error(derive_interp_records(parameter = NULL))
})

## Test 2: derive_interp_records AGE is not `NULL` ----
test_that("derive_interp_records Test 2 : AGE must be not NULL", {
  expect_error(derive_interp_records(AGE = NA))
})

## Test 3: derive_interp_records SEX is not `NULL` ----
test_that("derive_interp_records Test 3 : SEX must be not NULL", {
  expect_error(derive_interp_records(SEX = NA_character_))
  expect_error(derive_interp_records(SEX = ""))
})

## Test 4: derive_interp_records records are properly interpolated for WEIGHT ----
test_that("derive_interp_records Test 4 : WEIGHT data properly interpolated", {
  wt_interp_expected <- tibble::tribble(
    ~SEX, ~AGE, ~L, ~M, ~S, ~AGEU,
    "M", 731, -0.206799248, 12.67518709, 0.108128323, "DAYS",
    "M", 732, -0.207446045, 12.67961088, 0.108130835, "DAYS",
    "M", 733, -0.208092843, 12.68403467, 0.108133348, "DAYS",
    "M", 734, -0.208739641, 12.68845847, 0.10813586, "DAYS",
    "M", 735, -0.209386438, 12.69288226, 0.108138372, "DAYS",
    "M", 736, -0.210033236, 12.69730605, 0.108140884, "DAYS",
    "M", 737, -0.210680034, 12.70172984, 0.108143396, "DAYS",
    "M", 738, -0.211326832, 12.70615363, 0.108145909, "DAYS",
    "M", 739, -0.211973629, 12.71057742, 0.108148421, "DAYS",
    "M", 740, -0.212620427, 12.71500121, 0.108150933, "DAYS",
    "M", 741, -0.213267225, 12.719425, 0.108153445, "DAYS",
    "M", 742, -0.213914022, 12.7238488, 0.108155957, "DAYS",
    "M", 743, -0.21456082, 12.72827259, 0.108158469, "DAYS",
    "M", 744, -0.215207618, 12.73269638, 0.108160982, "DAYS",
    "M", 745, -0.215854415, 12.73712017, 0.108163494, "DAYS",
    "M", 746, -0.216501213, 12.74154396, 0.108166006, "DAYS",
    "M", 747, -0.217277522, 12.74619325, 0.108169629, "DAYS",
    "M", 748, -0.218053831, 12.75084255, 0.108173253, "DAYS",
    "M", 749, -0.218830141, 12.75549184, 0.108176876, "DAYS",
    "M", 750, -0.21960645, 12.76014113, 0.108180499, "DAYS",
    "M", 751, -0.220382759, 12.76479043, 0.108184123, "DAYS",
    "M", 752, -0.221159068, 12.76943972, 0.108187746, "DAYS",
    "M", 753, -0.221935377, 12.77408901, 0.108191369, "DAYS",
    "M", 754, -0.222711686, 12.77873831, 0.108194993, "DAYS",
    "M", 755, -0.223487996, 12.7833876, 0.108198616, "DAYS",
    "M", 756, -0.224264305, 12.78803689, 0.108202239, "DAYS",
    "M", 757, -0.225040614, 12.79268619, 0.108205863, "DAYS",
    "M", 758, -0.225816923, 12.79733548, 0.108209486, "DAYS",
    "M", 759, -0.226593232, 12.80198477, 0.108213109, "DAYS",
    "M", 760, -0.227369541, 12.80663407, 0.108216733, "DAYS",
    "M", 761, -0.228145851, 12.81128336, 0.108220356, "DAYS",
    "F", 731, -0.736393701, 12.06000954, 0.107420798, "DAYS",
    "F", 732, -0.737447893, 12.06497926, 0.107442101, "DAYS",
    "F", 733, -0.738502084, 12.06994897, 0.107463404, "DAYS",
    "F", 734, -0.739556275, 12.07491868, 0.107484708, "DAYS",
    "F", 735, -0.740610466, 12.07988839, 0.107506011, "DAYS",
    "F", 736, -0.741664658, 12.08485811, 0.107527314, "DAYS",
    "F", 737, -0.742718849, 12.08982782, 0.107548617, "DAYS",
    "F", 738, -0.74377304, 12.09479753, 0.10756992, "DAYS",
    "F", 739, -0.744827231, 12.09976724, 0.107591223, "DAYS",
    "F", 740, -0.745881423, 12.10473696, 0.107612526, "DAYS",
    "F", 741, -0.746935614, 12.10970667, 0.107633829, "DAYS",
    "F", 742, -0.747989805, 12.11467638, 0.107655133, "DAYS",
    "F", 743, -0.749043996, 12.11964609, 0.107676436, "DAYS",
    "F", 744, -0.750098188, 12.12461581, 0.107697739, "DAYS",
    "F", 745, -0.751152379, 12.12958552, 0.107719042, "DAYS",
    "F", 746, -0.75220657, 12.13455523, 0.107740345, "DAYS",
    "F", 747, -0.75327414, 12.13977089, 0.107764901, "DAYS",
    "F", 748, -0.754341709, 12.14498654, 0.107789456, "DAYS",
    "F", 749, -0.755409279, 12.1502022, 0.107814012, "DAYS",
    "F", 750, -0.756476849, 12.15541785, 0.107838567, "DAYS",
    "F", 751, -0.757544418, 12.16063351, 0.107863123, "DAYS",
    "F", 752, -0.758611988, 12.16584916, 0.107887678, "DAYS",
    "F", 753, -0.759679558, 12.17106482, 0.107912234, "DAYS",
    "F", 754, -0.760747127, 12.17628048, 0.107936789, "DAYS",
    "F", 755, -0.761814697, 12.18149613, 0.107961345, "DAYS",
    "F", 756, -0.762882267, 12.18671179, 0.1079859, "DAYS",
    "F", 757, -0.763949836, 12.19192744, 0.108010456, "DAYS",
    "F", 758, -0.765017406, 12.1971431, 0.108035011, "DAYS",
    "F", 759, -0.766084976, 12.20235875, 0.108059567, "DAYS",
    "F", 760, -0.767152545, 12.20757441, 0.108084122, "DAYS",
    "F", 761, -0.768220115, 12.21279007, 0.108108678, "DAYS"
  ) %>% arrange(SEX, AGE)

  wt_interp_actual <- admiralpeds::cdc_wtage %>%
    mutate(
      SEX = dplyr::case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = exprs(SEX),
      parameter = "WEIGHT"
    ) %>%
    filter(AGE >= 730.5 & AGE <= 761) %>%
    arrange(SEX, AGE)

  expect_equal(wt_interp_actual, wt_interp_expected)
})


## Test 5: derive_interp_records records are properly interpolated for HEIGHT ----
test_that("derive_interp_records Test 5 : HEIGHT data properly interpolated", {
  ht_interp_expected <- tibble::tribble(
    ~SEX, ~AGE, ~L, ~M, ~S, ~AGEU,
    "M", 731, 0.945629223, 86.47778903, 0.040326159, "DAYS",
    "M", 732, 0.94973448, 86.50337705, 0.04033079, "DAYS",
    "M", 733, 0.953839736, 86.52896507, 0.040335421, "DAYS",
    "M", 734, 0.957944993, 86.55455309, 0.040340053, "DAYS",
    "M", 735, 0.962050249, 86.58014111, 0.040344684, "DAYS",
    "M", 736, 0.966155506, 86.60572913, 0.040349315, "DAYS",
    "M", 737, 0.970260762, 86.63131715, 0.040353946, "DAYS",
    "M", 738, 0.974366019, 86.65690518, 0.040358577, "DAYS",
    "M", 739, 0.978471275, 86.6824932, 0.040363208, "DAYS",
    "M", 740, 0.982576531, 86.70808122, 0.040367839, "DAYS",
    "M", 741, 0.986681788, 86.73366924, 0.04037247, "DAYS",
    "M", 742, 0.990787044, 86.75925726, 0.040377102, "DAYS",
    "M", 743, 0.994892301, 86.78484528, 0.040381733, "DAYS",
    "M", 744, 0.998997557, 86.8104333, 0.040386364, "DAYS",
    "M", 745, 1.003102814, 86.83602132, 0.040390995, "DAYS",
    "M", 746, 1.00720807, 86.86160934, 0.040395626, "DAYS",
    "M", 747, 1.001542846, 86.88797146, 0.040401689, "DAYS",
    "M", 748, 0.995877622, 86.91433357, 0.040407753, "DAYS",
    "M", 749, 0.990212398, 86.94069569, 0.040413816, "DAYS",
    "M", 750, 0.984547174, 86.9670578, 0.040419879, "DAYS",
    "M", 751, 0.97888195, 86.99341992, 0.040425943, "DAYS",
    "M", 752, 0.973216726, 87.01978204, 0.040432006, "DAYS",
    "M", 753, 0.967551502, 87.04614415, 0.040438069, "DAYS",
    "M", 754, 0.961886278, 87.07250627, 0.040444132, "DAYS",
    "M", 755, 0.956221054, 87.09886838, 0.040450196, "DAYS",
    "M", 756, 0.95055583, 87.1252305, 0.040456259, "DAYS",
    "M", 757, 0.944890606, 87.15159262, 0.040462322, "DAYS",
    "M", 758, 0.939225382, 87.17795473, 0.040468386, "DAYS",
    "M", 759, 0.933560158, 87.20431685, 0.040474449, "DAYS",
    "M", 760, 0.927894934, 87.23067896, 0.040480512, "DAYS",
    "M", 761, 0.922229711, 87.25704108, 0.040486576, "DAYS",
    "F", 731, 1.071125457, 85.00191523, 0.040795665, "DAYS",
    "F", 732, 1.069801954, 85.02827534, 0.040799936, "DAYS",
    "F", 733, 1.068478451, 85.05463545, 0.040804206, "DAYS",
    "F", 734, 1.067154948, 85.08099557, 0.040808477, "DAYS",
    "F", 735, 1.065831445, 85.10735568, 0.040812748, "DAYS",
    "F", 736, 1.064507942, 85.13371579, 0.040817019, "DAYS",
    "F", 737, 1.063184439, 85.1600759, 0.04082129, "DAYS",
    "F", 738, 1.061860936, 85.18643601, 0.040825561, "DAYS",
    "F", 739, 1.060537433, 85.21279612, 0.040829831, "DAYS",
    "F", 740, 1.05921393, 85.23915623, 0.040834102, "DAYS",
    "F", 741, 1.057890427, 85.26551634, 0.040838373, "DAYS",
    "F", 742, 1.056566924, 85.29187646, 0.040842644, "DAYS",
    "F", 743, 1.055243421, 85.31823657, 0.040846915, "DAYS",
    "F", 744, 1.053919918, 85.34459668, 0.040851185, "DAYS",
    "F", 745, 1.052596415, 85.37095679, 0.040855456, "DAYS",
    "F", 746, 1.051272912, 85.3973169, 0.040859727, "DAYS",
    "F", 747, 1.050962187, 85.42708178, 0.040869141, "DAYS",
    "F", 748, 1.050651463, 85.45684665, 0.040878556, "DAYS",
    "F", 749, 1.050340738, 85.48661153, 0.04088797, "DAYS",
    "F", 750, 1.050030014, 85.5163764, 0.040897385, "DAYS",
    "F", 751, 1.049719289, 85.54614128, 0.040906799, "DAYS",
    "F", 752, 1.049408565, 85.57590616, 0.040916214, "DAYS",
    "F", 753, 1.04909784, 85.60567103, 0.040925628, "DAYS",
    "F", 754, 1.048787115, 85.63543591, 0.040935043, "DAYS",
    "F", 755, 1.048476391, 85.66520078, 0.040944457, "DAYS",
    "F", 756, 1.048165666, 85.69496566, 0.040953872, "DAYS",
    "F", 757, 1.047854942, 85.72473054, 0.040963286, "DAYS",
    "F", 758, 1.047544217, 85.75449541, 0.040972701, "DAYS",
    "F", 759, 1.047233493, 85.78426029, 0.040982115, "DAYS",
    "F", 760, 1.046922768, 85.81402516, 0.04099153, "DAYS",
    "F", 761, 1.046612044, 85.84379004, 0.041000944, "DAYS"
  ) %>% arrange(SEX, AGE)

  ht_interp_actual <- admiralpeds::cdc_htage %>%
    mutate(
      SEX = dplyr::case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = exprs(SEX),
      parameter = "HEIGHT"
    ) %>%
    filter(AGE >= 730.5 & AGE <= 761) %>%
    arrange(SEX, AGE)

  expect_equal(ht_interp_actual, ht_interp_expected)
})


## Test 6: derive_interp_records records are properly interpolated for BMI ----
test_that("derive_interp_records Test 6 : BMI data properly interpolated", {
  bmi_interp_expected <- tibble::tribble(
    ~SEX, ~AGE, ~L, ~M, ~S, ~P95, ~Sigma, ~AGEU,
    "M", 731, -2.009380603, 16.57332438, 0.0805634, 19.33430625, 1.376857375, "DAYS",
    "M", 732, -2.007580136, 16.57162108, 0.080534336, 19.3306125, 1.37811475, "DAYS",
    "M", 733, -2.005779668, 16.56991778, 0.080505271, 19.32691875, 1.379372125, "DAYS",
    "M", 734, -2.003979201, 16.56821448, 0.080476206, 19.323225, 1.3806295, "DAYS",
    "M", 735, -2.002178734, 16.56651118, 0.080447141, 19.31953125, 1.381886875, "DAYS",
    "M", 736, -2.000378267, 16.56480788, 0.080418077, 19.3158375, 1.38314425, "DAYS",
    "M", 737, -1.9985778, 16.56310458, 0.080389012, 19.31214375, 1.384401625, "DAYS",
    "M", 738, -1.996777333, 16.56140128, 0.080359947, 19.30845, 1.385659, "DAYS",
    "M", 739, -1.994976865, 16.55969797, 0.080330882, 19.30475625, 1.386916375, "DAYS",
    "M", 740, -1.993176398, 16.55799467, 0.080301818, 19.3010625, 1.38817375, "DAYS",
    "M", 741, -1.991375931, 16.55629137, 0.080272753, 19.29736875, 1.389431125, "DAYS",
    "M", 742, -1.989575464, 16.55458807, 0.080243688, 19.293675, 1.3906885, "DAYS",
    "M", 743, -1.987774997, 16.55288477, 0.080214623, 19.28998125, 1.391945875, "DAYS",
    "M", 744, -1.985974529, 16.55118147, 0.080185559, 19.2862875, 1.39320325, "DAYS",
    "M", 745, -1.984174062, 16.54947817, 0.080156494, 19.28259375, 1.394460625, "DAYS",
    "M", 746, -1.982373595, 16.54777487, 0.080127429, 19.2789, 1.395718, "DAYS",
    "M", 747, -1.980431147, 16.54599663, 0.080097648, 19.27509333, 1.397056, "DAYS",
    "M", 748, -1.9784887, 16.54421839, 0.080067867, 19.27128667, 1.398394, "DAYS",
    "M", 749, -1.976546252, 16.54244015, 0.080038086, 19.26748, 1.399732, "DAYS",
    "M", 750, -1.974603805, 16.5406619, 0.080008304, 19.26367333, 1.40107, "DAYS",
    "M", 751, -1.972661357, 16.53888366, 0.079978523, 19.25986667, 1.402408, "DAYS",
    "M", 752, -1.97071891, 16.53710542, 0.079948742, 19.25606, 1.403746, "DAYS",
    "M", 753, -1.968776462, 16.53532718, 0.079918961, 19.25225333, 1.405084, "DAYS",
    "M", 754, -1.966834015, 16.53354894, 0.07988918, 19.24844667, 1.406422, "DAYS",
    "M", 755, -1.964891567, 16.5317707, 0.079859399, 19.24464, 1.40776, "DAYS",
    "M", 756, -1.96294912, 16.52999246, 0.079829617, 19.24083333, 1.409098, "DAYS",
    "M", 757, -1.961006672, 16.52821422, 0.079799836, 19.23702667, 1.410436, "DAYS",
    "M", 758, -1.959064225, 16.52643597, 0.079770055, 19.23322, 1.411774, "DAYS",
    "M", 759, -1.957121777, 16.52465773, 0.079740274, 19.22941333, 1.413112, "DAYS",
    "M", 760, -1.95517933, 16.52287949, 0.079710493, 19.22560667, 1.41445, "DAYS",
    "M", 761, -1.953236882, 16.52110125, 0.079680712, 19.2218, 1.415788, "DAYS",
    "F", 731, -0.988976549, 16.42118689, 0.085425163, 19.1032, 1.572355063, "DAYS",
    "F", 732, -0.991344567, 16.41897713, 0.085398542, 19.1002, 1.573310125, "DAYS",
    "F", 733, -0.993712586, 16.41676738, 0.08537192, 19.0972, 1.574265188, "DAYS",
    "F", 734, -0.996080604, 16.41455762, 0.085345298, 19.0942, 1.57522025, "DAYS",
    "F", 735, -0.998448623, 16.41234787, 0.085318677, 19.0912, 1.576175313, "DAYS",
    "F", 736, -1.000816641, 16.41013811, 0.085292055, 19.0882, 1.577130375, "DAYS",
    "F", 737, -1.00318466, 16.40792836, 0.085265433, 19.0852, 1.578085438, "DAYS",
    "F", 738, -1.005552679, 16.4057186, 0.085238812, 19.0822, 1.5790405, "DAYS",
    "F", 739, -1.007920697, 16.40350885, 0.08521219, 19.0792, 1.579995563, "DAYS",
    "F", 740, -1.010288716, 16.40129909, 0.085185568, 19.0762, 1.580950625, "DAYS",
    "F", 741, -1.012656734, 16.39908934, 0.085158946, 19.0732, 1.581905688, "DAYS",
    "F", 742, -1.015024753, 16.39687958, 0.085132325, 19.0702, 1.58286075, "DAYS",
    "F", 743, -1.017392771, 16.39466983, 0.085105703, 19.0672, 1.583815813, "DAYS",
    "F", 744, -1.01976079, 16.39246007, 0.085079081, 19.0642, 1.584770875, "DAYS",
    "F", 745, -1.022128808, 16.39025032, 0.08505246, 19.0612, 1.585725938, "DAYS",
    "F", 746, -1.024496827, 16.38804056, 0.085025838, 19.0582, 1.586681, "DAYS",
    "F", 747, -1.027103545, 16.38573827, 0.084998778, 19.05512333, 1.5876994, "DAYS",
    "F", 748, -1.029710262, 16.38343598, 0.084971719, 19.05204667, 1.5887178, "DAYS",
    "F", 749, -1.03231698, 16.38113369, 0.084944659, 19.04897, 1.5897362, "DAYS",
    "F", 750, -1.034923697, 16.37883141, 0.0849176, 19.04589333, 1.5907546, "DAYS",
    "F", 751, -1.037530415, 16.37652912, 0.08489054, 19.04281667, 1.591773, "DAYS",
    "F", 752, -1.040137132, 16.37422683, 0.084863481, 19.03974, 1.5927914, "DAYS",
    "F", 753, -1.04274385, 16.37192454, 0.084836421, 19.03666333, 1.5938098, "DAYS",
    "F", 754, -1.045350567, 16.36962225, 0.084809362, 19.03358667, 1.5948282, "DAYS",
    "F", 755, -1.047957285, 16.36731996, 0.084782302, 19.03051, 1.5958466, "DAYS",
    "F", 756, -1.050564002, 16.36501767, 0.084755243, 19.02743333, 1.596865, "DAYS",
    "F", 757, -1.05317072, 16.36271538, 0.084728183, 19.02435667, 1.5978834, "DAYS",
    "F", 758, -1.055777437, 16.3604131, 0.084701124, 19.02128, 1.5989018, "DAYS",
    "F", 759, -1.058384155, 16.35811081, 0.084674064, 19.01820333, 1.5999202, "DAYS",
    "F", 760, -1.060990872, 16.35580852, 0.084647005, 19.01512667, 1.6009386, "DAYS",
    "F", 761, -1.06359759, 16.35350623, 0.084619945, 19.01205, 1.601957, "DAYS"
  ) %>% arrange(SEX, AGE)


  bmi_interp_actual <- admiralpeds::cdc_bmiage %>%
    mutate(
      SEX = dplyr::case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = exprs(SEX),
      parameter = "BMI"
    ) %>%
    filter(AGE >= 730.5 & AGE <= 761) %>%
    arrange(SEX, AGE)

  expect_equal(bmi_interp_actual, bmi_interp_expected, tolerance = 1e-5)
})

## Test 7: derive_interp_records - by_vars=NULL with no unique combination within metadata vars ----
test_that("derive_interp_records Test 7 : by_vars argument set to NULL with no unique combination
          within metadata variables", {
  expect_error(
    bmi_interp_actual <- admiralpeds::cdc_bmiage %>%
      mutate(
        SEX = dplyr::case_when(
          SEX == 1 ~ "M",
          SEX == 2 ~ "F",
          TRUE ~ NA_character_
        ),
        # Ensure first that Age unit is "DAYS"
        AGE = round(AGE * 30.4375),
        AGEU = "DAYS"
      ) %>%
      # Interpolate the AGE by SEX
      derive_interp_records(
        by_vars = NULL,
        parameter = "BMI"
      ) %>%
      filter(AGE >= 730.5 & AGE <= 761) %>%
      arrange(SEX, AGE)
  )
})

## Test 8: derive_interp_records - by_vars=NULL with unique combination within metadata vars ----
test_that("derive_interp_records Test 8 : by_vars argument set to NULL with unique combination
          within metadata variables", {
  bmi_interp_expected_female <- tibble::tribble(
    ~AGE, ~L, ~M, ~S, ~P95, ~Sigma, ~SEX, ~AGEU,
    731, -0.988976549, 16.42118689, 0.085425163, 19.1032, 1.572355063, "F", "DAYS",
    732, -0.991344567, 16.41897713, 0.085398542, 19.1002, 1.573310125, "F", "DAYS",
    733, -0.993712586, 16.41676738, 0.08537192, 19.0972, 1.574265188, "F", "DAYS",
    734, -0.996080604, 16.41455762, 0.085345298, 19.0942, 1.57522025, "F", "DAYS",
    735, -0.998448623, 16.41234787, 0.085318677, 19.0912, 1.576175313, "F", "DAYS",
    736, -1.000816641, 16.41013811, 0.085292055, 19.0882, 1.577130375, "F", "DAYS",
    737, -1.00318466, 16.40792836, 0.085265433, 19.0852, 1.578085438, "F", "DAYS",
    738, -1.005552679, 16.4057186, 0.085238812, 19.0822, 1.5790405, "F", "DAYS",
    739, -1.007920697, 16.40350885, 0.08521219, 19.0792, 1.579995563, "F", "DAYS",
    740, -1.010288716, 16.40129909, 0.085185568, 19.0762, 1.580950625, "F", "DAYS",
    741, -1.012656734, 16.39908934, 0.085158946, 19.0732, 1.581905688, "F", "DAYS",
    742, -1.015024753, 16.39687958, 0.085132325, 19.0702, 1.58286075, "F", "DAYS",
    743, -1.017392771, 16.39466983, 0.085105703, 19.0672, 1.583815813, "F", "DAYS",
    744, -1.01976079, 16.39246007, 0.085079081, 19.0642, 1.584770875, "F", "DAYS",
    745, -1.022128808, 16.39025032, 0.08505246, 19.0612, 1.585725938, "F", "DAYS",
    746, -1.024496827, 16.38804056, 0.085025838, 19.0582, 1.586681, "F", "DAYS",
    747, -1.027103545, 16.38573827, 0.084998778, 19.05512333, 1.5876994, "F", "DAYS",
    748, -1.029710262, 16.38343598, 0.084971719, 19.05204667, 1.5887178, "F", "DAYS",
    749, -1.03231698, 16.38113369, 0.084944659, 19.04897, 1.5897362, "F", "DAYS",
    750, -1.034923697, 16.37883141, 0.0849176, 19.04589333, 1.5907546, "F", "DAYS",
    751, -1.037530415, 16.37652912, 0.08489054, 19.04281667, 1.591773, "F", "DAYS",
    752, -1.040137132, 16.37422683, 0.084863481, 19.03974, 1.5927914, "F", "DAYS",
    753, -1.04274385, 16.37192454, 0.084836421, 19.03666333, 1.5938098, "F", "DAYS",
    754, -1.045350567, 16.36962225, 0.084809362, 19.03358667, 1.5948282, "F", "DAYS",
    755, -1.047957285, 16.36731996, 0.084782302, 19.03051, 1.5958466, "F", "DAYS",
    756, -1.050564002, 16.36501767, 0.084755243, 19.02743333, 1.596865, "F", "DAYS",
    757, -1.05317072, 16.36271538, 0.084728183, 19.02435667, 1.5978834, "F", "DAYS",
    758, -1.055777437, 16.3604131, 0.084701124, 19.02128, 1.5989018, "F", "DAYS",
    759, -1.058384155, 16.35811081, 0.084674064, 19.01820333, 1.5999202, "F", "DAYS",
    760, -1.060990872, 16.35580852, 0.084647005, 19.01512667, 1.6009386, "F", "DAYS",
    761, -1.06359759, 16.35350623, 0.084619945, 19.01205, 1.601957, "F", "DAYS"
  ) %>% arrange(AGE)

  bmi_interp_expected_male <- tibble::tribble(
    ~AGE, ~L, ~M, ~S, ~P95, ~Sigma, ~SEX, ~AGEU,
    731, -2.009380603, 16.57332438, 0.0805634, 19.33430625, 1.376857375, "M", "DAYS",
    732, -2.007580136, 16.57162108, 0.080534336, 19.3306125, 1.37811475, "M", "DAYS",
    733, -2.005779668, 16.56991778, 0.080505271, 19.32691875, 1.379372125, "M", "DAYS",
    734, -2.003979201, 16.56821448, 0.080476206, 19.323225, 1.3806295, "M", "DAYS",
    735, -2.002178734, 16.56651118, 0.080447141, 19.31953125, 1.381886875, "M", "DAYS",
    736, -2.000378267, 16.56480788, 0.080418077, 19.3158375, 1.38314425, "M", "DAYS",
    737, -1.9985778, 16.56310458, 0.080389012, 19.31214375, 1.384401625, "M", "DAYS",
    738, -1.996777333, 16.56140128, 0.080359947, 19.30845, 1.385659, "M", "DAYS",
    739, -1.994976865, 16.55969797, 0.080330882, 19.30475625, 1.386916375, "M", "DAYS",
    740, -1.993176398, 16.55799467, 0.080301818, 19.3010625, 1.38817375, "M", "DAYS",
    741, -1.991375931, 16.55629137, 0.080272753, 19.29736875, 1.389431125, "M", "DAYS",
    742, -1.989575464, 16.55458807, 0.080243688, 19.293675, 1.3906885, "M", "DAYS",
    743, -1.987774997, 16.55288477, 0.080214623, 19.28998125, 1.391945875, "M", "DAYS",
    744, -1.985974529, 16.55118147, 0.080185559, 19.2862875, 1.39320325, "M", "DAYS",
    745, -1.984174062, 16.54947817, 0.080156494, 19.28259375, 1.394460625, "M", "DAYS",
    746, -1.982373595, 16.54777487, 0.080127429, 19.2789, 1.395718, "M", "DAYS",
    747, -1.980431147, 16.54599663, 0.080097648, 19.27509333, 1.397056, "M", "DAYS",
    748, -1.9784887, 16.54421839, 0.080067867, 19.27128667, 1.398394, "M", "DAYS",
    749, -1.976546252, 16.54244015, 0.080038086, 19.26748, 1.399732, "M", "DAYS",
    750, -1.974603805, 16.5406619, 0.080008304, 19.26367333, 1.40107, "M", "DAYS",
    751, -1.972661357, 16.53888366, 0.079978523, 19.25986667, 1.402408, "M", "DAYS",
    752, -1.97071891, 16.53710542, 0.079948742, 19.25606, 1.403746, "M", "DAYS",
    753, -1.968776462, 16.53532718, 0.079918961, 19.25225333, 1.405084, "M", "DAYS",
    754, -1.966834015, 16.53354894, 0.07988918, 19.24844667, 1.406422, "M", "DAYS",
    755, -1.964891567, 16.5317707, 0.079859399, 19.24464, 1.40776, "M", "DAYS",
    756, -1.96294912, 16.52999246, 0.079829617, 19.24083333, 1.409098, "M", "DAYS",
    757, -1.961006672, 16.52821422, 0.079799836, 19.23702667, 1.410436, "M", "DAYS",
    758, -1.959064225, 16.52643597, 0.079770055, 19.23322, 1.411774, "M", "DAYS",
    759, -1.957121777, 16.52465773, 0.079740274, 19.22941333, 1.413112, "M", "DAYS",
    760, -1.95517933, 16.52287949, 0.079710493, 19.22560667, 1.41445, "M", "DAYS",
    761, -1.953236882, 16.52110125, 0.079680712, 19.2218, 1.415788, "M", "DAYS"
  ) %>% arrange(AGE)

  bmi_interp_actual_female <- admiralpeds::cdc_bmiage %>%
    filter(SEX == 2) %>%
    mutate(
      SEX = dplyr::case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = NULL,
      parameter = "BMI"
    ) %>%
    filter(AGE >= 730.5 & AGE <= 761) %>%
    arrange(AGE)

  bmi_interp_actual_male <- admiralpeds::cdc_bmiage %>%
    filter(SEX == 1) %>%
    mutate(
      SEX = dplyr::case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = NULL,
      parameter = "BMI"
    ) %>%
    filter(AGE >= 730.5 & AGE <= 761) %>%
    arrange(AGE)

  expect_equal(bmi_interp_actual_female, bmi_interp_expected_female, tolerance = 1e-5)
  expect_equal(bmi_interp_actual_male, bmi_interp_expected_male, tolerance = 1e-5)
})


## Test 9: derive_interp_records records are properly interpolated for BMI
##         and non-interpolated variables well merged back
test_that("derive_interp_records Test 9 : BMI data properly interpolated and
          non-interpolated variables well included", {
  bmi_interp_expected <- tibble::tribble(
    ~SEX, ~AGE, ~L, ~M, ~S, ~P95, ~Sigma, ~AGEU, ~non_interp1, ~non_interp2, ~non_interp3,
    "M", 731, -2.009380603, 16.57332438, 0.0805634, 19.33430625, 1.376857375,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 732, -2.007580136, 16.57162108, 0.080534336, 19.3306125, 1.37811475,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 733, -2.005779668, 16.56991778, 0.080505271, 19.32691875, 1.379372125,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 734, -2.003979201, 16.56821448, 0.080476206, 19.323225, 1.3806295,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 735, -2.002178734, 16.56651118, 0.080447141, 19.31953125, 1.381886875,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 736, -2.000378267, 16.56480788, 0.080418077, 19.3158375, 1.38314425,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 737, -1.9985778, 16.56310458, 0.080389012, 19.31214375, 1.384401625,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 738, -1.996777333, 16.56140128, 0.080359947, 19.30845, 1.385659,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 739, -1.994976865, 16.55969797, 0.080330882, 19.30475625, 1.386916375,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 740, -1.993176398, 16.55799467, 0.080301818, 19.3010625, 1.38817375,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 741, -1.991375931, 16.55629137, 0.080272753, 19.29736875, 1.389431125,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 742, -1.989575464, 16.55458807, 0.080243688, 19.293675, 1.3906885,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 743, -1.987774997, 16.55288477, 0.080214623, 19.28998125, 1.391945875,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 744, -1.985974529, 16.55118147, 0.080185559, 19.2862875, 1.39320325,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 745, -1.984174062, 16.54947817, 0.080156494, 19.28259375, 1.394460625,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "M", 746, -1.982373595, 16.54777487, 0.080127429, 19.2789, 1.395718,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 747, -1.980431147, 16.54599663, 0.080097648, 19.27509333, 1.397056,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 748, -1.9784887, 16.54421839, 0.080067867, 19.27128667, 1.398394,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 749, -1.976546252, 16.54244015, 0.080038086, 19.26748, 1.399732,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 750, -1.974603805, 16.5406619, 0.080008304, 19.26367333, 1.40107,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 751, -1.972661357, 16.53888366, 0.079978523, 19.25986667, 1.402408,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 752, -1.97071891, 16.53710542, 0.079948742, 19.25606, 1.403746,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 753, -1.968776462, 16.53532718, 0.079918961, 19.25225333, 1.405084,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 754, -1.966834015, 16.53354894, 0.07988918, 19.24844667, 1.406422,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 755, -1.964891567, 16.5317707, 0.079859399, 19.24464, 1.40776,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 756, -1.96294912, 16.52999246, 0.079829617, 19.24083333, 1.409098,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 757, -1.961006672, 16.52821422, 0.079799836, 19.23702667, 1.410436,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 758, -1.959064225, 16.52643597, 0.079770055, 19.23322, 1.411774,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 759, -1.957121777, 16.52465773, 0.079740274, 19.22941333, 1.413112,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 760, -1.95517933, 16.52287949, 0.079710493, 19.22560667, 1.41445,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "M", 761, -1.953236882, 16.52110125, 0.079680712, 19.2218, 1.415788,
    "DAYS", "N-I-1", "N-I-2", "FAKE",
    "F", 731, -0.988976549, 16.42118689, 0.085425163, 19.1032, 1.572355063,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 732, -0.991344567, 16.41897713, 0.085398542, 19.1002, 1.573310125,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 733, -0.993712586, 16.41676738, 0.08537192, 19.0972, 1.574265188,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 734, -0.996080604, 16.41455762, 0.085345298, 19.0942, 1.57522025,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 735, -0.998448623, 16.41234787, 0.085318677, 19.0912, 1.576175313,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 736, -1.000816641, 16.41013811, 0.085292055, 19.0882, 1.577130375,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 737, -1.00318466, 16.40792836, 0.085265433, 19.0852, 1.578085438,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 738, -1.005552679, 16.4057186, 0.085238812, 19.0822, 1.5790405,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 739, -1.007920697, 16.40350885, 0.08521219, 19.0792, 1.579995563,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 740, -1.010288716, 16.40129909, 0.085185568, 19.0762, 1.580950625,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 741, -1.012656734, 16.39908934, 0.085158946, 19.0732, 1.581905688,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 742, -1.015024753, 16.39687958, 0.085132325, 19.0702, 1.58286075,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 743, -1.017392771, 16.39466983, 0.085105703, 19.0672, 1.583815813,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 744, -1.01976079, 16.39246007, 0.085079081, 19.0642, 1.584770875,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 745, -1.022128808, 16.39025032, 0.08505246, 19.0612, 1.585725938,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 746, -1.024496827, 16.38804056, 0.085025838, 19.0582, 1.586681,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 747, -1.027103545, 16.38573827, 0.084998778, 19.05512333, 1.5876994,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 748, -1.029710262, 16.38343598, 0.084971719, 19.05204667, 1.5887178,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 749, -1.03231698, 16.38113369, 0.084944659, 19.04897, 1.5897362,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 750, -1.034923697, 16.37883141, 0.0849176, 19.04589333, 1.5907546,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 751, -1.037530415, 16.37652912, 0.08489054, 19.04281667, 1.591773,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 752, -1.040137132, 16.37422683, 0.084863481, 19.03974, 1.5927914,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 753, -1.04274385, 16.37192454, 0.084836421, 19.03666333, 1.5938098,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 754, -1.045350567, 16.36962225, 0.084809362, 19.03358667, 1.5948282,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 755, -1.047957285, 16.36731996, 0.084782302, 19.03051, 1.5958466,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 756, -1.050564002, 16.36501767, 0.084755243, 19.02743333, 1.596865,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 757, -1.05317072, 16.36271538, 0.084728183, 19.02435667, 1.5978834,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 758, -1.055777437, 16.3604131, 0.084701124, 19.02128, 1.5989018,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 759, -1.058384155, 16.35811081, 0.084674064, 19.01820333, 1.5999202,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 760, -1.060990872, 16.35580852, 0.084647005, 19.01512667, 1.6009386,
    "DAYS", "N-I-1", "N-I-2", "N-I-3",
    "F", 761, -1.06359759, 16.35350623, 0.084619945, 19.01205, 1.601957,
    "DAYS", "N-I-1", "N-I-2", "N-I-3"
  ) %>% arrange(SEX, AGE)


  bmi_interp_actual <- admiralpeds::cdc_bmiage %>%
    mutate(
      SEX = dplyr::case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS",
      # Add fake variables which are not interpolated
      non_interp1 = "N-I-1",
      non_interp2 = "N-I-2",
      non_interp3 = ifelse(row_number() == 2, "FAKE", "N-I-3")
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = exprs(SEX),
      parameter = "BMI"
    ) %>%
    filter(AGE >= 730.5 & AGE <= 761) %>%
    arrange(SEX, AGE)

  expect_equal(bmi_interp_actual, bmi_interp_expected, tolerance = 1e-5)
})
