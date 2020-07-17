#' Ramdom sampling from the Inverse-Gamma distribution
#'
#' @param n Numer of random draws, default to be 1. If \code{length(n)>1}, the length is taken to be the number required.
#' @param y Vector of mixture Gaussian observation.
#' @param S Vector of the state values. Each element of S must be either 1 or 2 indicating the state value.
#' @param prior_par List of shape and rate parameter values of priors.
#' @return List of posterior variance for each state.
#' @details The Inverse-Gamma distribution here with shape parameter `a` and scale parameter `b` has PDF
#' ```
#' f(x | shape = a, rate = b) = cst * x^(a + 1) * exp(-b/x),   cst = b^a/Gamma(a).
#' ```
#' The distribution is proper only when `a,b > 0`, but these values are unrestricted here since improper priors can be useful for Bayesian inference.  When either `a,b <= 0` the function sets `cst = 1` in the expression above.
#'
#' The function takes advantage of the fact that if X ~ Gamma(a,b), then 1/X ~ IG(a,b).
#' @seealso \code{\link{rTIG}}
#' @export
rIG <- function(n=1, y, S, prior_par=list(shape=1/2,rate=1/2)){
  #Generate sigma1 from posterior:
  N_1 <- length(y)
  Y_1 <- y/sqrt(S)
  shape_post1 <- prior_par$shape+N_1/2
  rate_post1 <- prior_par$rate+sum(Y_1^2)/2
  v1 <- 1/rgamma(n, shape = shape_post1, rate = rate_post1)

  #Generate sigma2 from posterior:
  Y_2 <- y*(S-1)/sqrt(v1)
  N_2 <- sum(S-1)
  shape_post2 <- prior_par$shape+N_2/2
  rate_post2 <- prior_par$rate+sum(Y_2^2)/2
  gamma_bar <- rTIG(n,truncation =1, shape=shape_post2,rate = rate_post2)
  v2 <- v1*gamma_bar
  return(list(v1 = v1, v2 = v2))
}


