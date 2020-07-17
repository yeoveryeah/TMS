context("transition")

 test_that("transition() will work for different unit test",{
   S = c(rep(1,3), 2,2, rep(1,4),rep(1,5))
   set.seed(5)
   p12 <- rbeta(1,1+1, 1+10)
   p21 <- rbeta(1,1+1, 1+1)
   set.seed(5)
   ans <- transition(S=S, shape1=1, shape2 = 1)
   expect_equal(ans,list(p12=p12, p21=p21))

 })
