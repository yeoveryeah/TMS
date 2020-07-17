context("viterbi")
test_that("viterbi() gives same results",{
  set.seed(5)
  
  sim.ans<-viterbi(c(0.5,0.6,3,4,5,6,0),c(0.5,2),matrix(0.5,2,2))
  
  expect_equal(sim.ans, c(1,1,2,2,2,2,1))
})

test_that("viterbi() gives same results",{
  set.seed(5)
  sim.y <- rnorm(1e4, sd =c(0.5, 6))
  sim.y.first_half <- sim.y[1:1e3]
  sim.ans_first<-viterbi(sim.y, c(0.5,6), matrix(0.5,2,2))
  sim.ans_second<-viterbi(sim.y.first_half, c(0.5,6), matrix(0.5,2,2))
  
  expect_equal(sim.ans_first[1:1e3], sim.ans_second)
})
