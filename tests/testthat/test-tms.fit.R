context("tms.fit")

test_that("tms.fit() gives same results",{
  set.seed(5)  
  sim.y <- c(rnorm(1e2, sd =0.3))
  sim.ans<-tms.fit(y=sim.y, q=5, burn = 1000, nsamples = 1000,
                   s.out = TRUE,par.out = TRUE)
  
  expect_equal(xor(sum(sim.ans$S==1)==100000, sum(sim.ans$S==2)==100000), TRUE)
  # Test out dimensions
  expect_equal(dim(sim.ans$S), c(1000,100))
  expect_equal(dim(sim.ans$VR), c(1000,2))
})
