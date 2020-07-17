#' Parameter Update at each Gibbs iteration
#'
#' @param y Vector of mixture Gaussian observation.
#' @param var List of state variance.
#' @param p_matrix Transition matrix with `(i,j) `entry being transition probability from state i to state j.
#' @param tran_prior List of parameters for transition probability priors(See \code{\link{transition}}).
#' @param var_prior List of parameters for prior of state variance(See \code{\link{rIG}}).
#' @param q Scaler, the period on which Variance Ratio Test is based
#' @param s.out Logical; if TRUE, it will return the latent state values
#' @return Either a `nsamples x 2` matrix of VR statistcs with each row corresponding to an MCMC update cycle, or a list with element VR and possibly `nsamples x 4` matrix of Theta and `nsamples x \code{length(y)}` matrix of S, if the parameter posterior and the latent state values are required
#' @description Calculate statistics reuqired for gibbs-sampling-augmented variance ratio test, the latent State series of the Markove Switching model, posterior parameter values and VR statistics for a single iteration of Gibbs sampler.
#' @export
hmm.gibbs <- function(y, var, p_matrix, tran_prior, var_prior,q, s.out=FALSE){
  #Update latent S_t
  S_t <- viterbi(y=y,var=var, p_matrix=p_matrix)

  #Update sigma1, and sigma2:
  var <- rIG(y=y, S=S_t)
  sigma <- sqrt(unlist(var, use.names = FALSE))

  #Update transition probabilities
  p_tran <- transition(S=S_t, shape1=tran_prior$shape1, shape2=tran_prior$shape2)
  p12 <- p_tran$p12;p21 <- p_tran$p21

  #VR statistics:
  sigma_t <- sapply(S_t, function(ii) sigma[ii])
  VR_stat <- VR.test(y=y, sigma=sigma_t, q=q)

  #Storage
  if(s.out){
    ans <- list(S=S_t, sigma1=sigma[1],sigma2=sigma[2],
                p12=p12,p21=p21,VR=VR_stat$VR,VR_star=VR_stat$VR_star)
  }else{
      ans <- c(sigma, p_tran, VR_stat)
      names(ans) <- c("sigma1","sigma2", "p12","p21","VR","VR_star")
  }
  ans
}

