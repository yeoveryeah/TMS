context("VR.stat")

test_that("VR.stat() will stop at unsuitable input",{
  #as the function scratch the calculation
  # only error will be tested
  expect_error(VR.stat(y_sd = rep(7, 3), q=4), "Insufficient data length")
  expect_error(VR.stat(y_sd = rep(5,100), q=2), "Zero variance on denominator")
})