#' Random sampling from Left Truncated Inverse Gamma
#' 
#' @param n Numer of random draws, default to be 1. If \code{length(n)>1}, the length is taken to be the number required.
#' @param truncation Left truncation point, must be positive.
#' @param shape,rate Shape parameter of the Inverse Gamma distribution, must be positve
#' @return Scaler or a vector of random numbers from the Left Truncated Inverse Gamma.
#' @details The function takes advantage of the fact that if X ~ Gamma(a,b), then 1/X ~ IG(a,b). (See *rIG*)
#' 
#' The CDF of Right Truncated Gamma is given by
#' ```
#' G(x) = F(x)/F(1/truncation), F(x) is cdf of Gamma(a,b), 0<x<1/truncation
#' ```
#' Inverse CDF method is applied.
#' @export
rTIG <- function(n=1, truncation = 1, shape, rate){
  x_upp <- 1/truncation
  u <- runif(n, max=x_upp)
  Gx <- u*pgamma(x_upp,shape = shape, rate = rate)
  #inverse CDF
  r <- qgamma(Gx, shape = shape, rate = rate)
  return(1/r)
}