context("rTIG")

test_that("`rTIG()` will output a truncated observations",{
  expect_gt(rTIG(n=1, truncation = 10, shape =1, rate=1),expected = 10)
  expect_gt(rTIG(n=1, truncation = 3, shape =1, rate=1),expected = 3)
})
