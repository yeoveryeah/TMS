context("VR.test")

test_that("`VR.test()` will stop at not suitable input",{
  #as the function scratch the calculation
  # only error will be tested
  expect_error(VR.test(y = rep(1,2) , sigma = rep(3,4)),"non-equal length of y and sigma" )
  expect_error(VR.test(y = rnorm(10), sigma = sample(rep(rexp(2),5)), q=10), "Insufficient data length")
})
