
context("VR.pval")

test_that("`VR.pval()` gives same results as doing it from scratch",{
  ncases <- 10
  test_cases <- matrix(sample(1:(2*ncases)), ncol = 2, nrow = ncases)
  ans <- 0
  for(ii in 1:ncases){
    cell_case <- test_cases[ii,]
    if(cell_case[1]>cell_case[2]){
      ans  <- ans +1
    }
  }
  ans <- ans/ncases
  expect_equal(VR.pval(vr_t = test_cases),ans)
})

