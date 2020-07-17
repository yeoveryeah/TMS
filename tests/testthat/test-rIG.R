context("rIG")

test_that("`rIG()` will produce a named list of two",{
  y <- sample(rnorm(20, sd = c(0.5,5)))
  S <- sample(1:2,size = 20, replace = TRUE)
  expect_named(rIG(n=1, y=y, S=S), c("v1", "v2"))
  expect_type(rIG(n=1, y=y, S=S),"list")
})
