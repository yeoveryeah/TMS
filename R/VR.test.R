#' Bayesian Statistics for Variance Ratio Test
#'
#' @param y Vector of mixture Gaussian observation.
#' @param sigma Vector of standard deviation at each state.Same length as y.
#' @param q Scalar, the period on which Variance Ratio Test is based
#' @return List of variance ratio statistic of y and randomized realizations.
#' @description Calculate variance ratio statistics for mixture Gaussian observations and its randomized realizations.
#' @details To keep the information contained in sigma, the randomization will be a product of sigma and random draws from standard normal distribution.
#' @export
VR.test <- function(y, sigma, q){
  if(! length(y)==length(sigma)) stop("non-equal length of y and sigma")
  if(! length(y) >q) stop("Insufficient data length")
  #standardized y
  y_stan <- y/sigma
  vr <- VR.stat(y_sd=y_stan, q=q) #VR Statistics

  #randomized normal realizations
  n <- length(y)
  z <- rnorm(n)
  y_star <- z*sigma
  vr_star <- VR.stat(y_sd = y_star, q= q) #VR Statistics
  return(list(VR = vr, VR_star =vr_star))
}






