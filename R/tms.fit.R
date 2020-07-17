#' Posterior Inferencefor Two-State Markov Switching model
#'
#' @param y Vector of mixture Gaussian observation.
#' @param q Scaler, the period on which Variance Ratio Test is based
#' @param burn Integer number of initial iterations to discard as burn-in. The default value is `min(nsamples/10, 1000)`.
#' @param nsamples Number of posterior iterations (not including burn-in)
#' @param s.out Logical; if TRUE, it will return the latent state values
#' @param par.out Logical, if TRUE, it will return the posterior draws for parameters
#' @param tran_prior List of parameters for prior of transition probabilities(See \code{\link{transition}})
#' @param var_prior List of parameters for prior of state variance(See \code{\link{rIG}}).
#' @details The Gibbs Sampler will update latent state values, state variance and transition matrix in order.
#' @description Calculate posterior variance ratio statistics of standardized observations and randomized observations.
#' @return `nsampls x 2` matrix of variance ratio test of standardized observations and randomized observations.
#' @seealso \code{\link{hmm.gibbs}} for update at each iteration
#' @export
tms.fit <- function(y, q, burn, nsamples, s.out =FALSE, par.out=FALSE,
                      tran_prior=NULL, var_prior=NULL){
  n <- length(y)
  # default burn-in
  if(missing(burn)) burn <- min(floor(nsamples/10), 1e3)
  #Storage:
  par_names <-c("sigma1", "sigma2", "p12", "p21") #sampling scale
  ntheta <- length(par_names)
  Theta <- matrix(NA, nsamples, ntheta) #parameter
  colnames(Theta) <- par_names
  theta.acc <- rep(0,ntheta)
  names(theta.acc) <- par_names
  VR_samples <- matrix(0,nsamples,2) #VR Statistics
  colnames(VR_samples) <- c("VR", "VR_star")
  if(s.out) S <- matrix(NA, nsamples, n)

  #prior specification:
  if (is.null(tran_prior)){
    #default prior: transition~Beta(1,1);
    tran_prior=list(shape1=1, shape2=1)
  }else{
    if(!all(sort(names(tran_prior)) ==
            sort(c("shape1","shape2")))){
      stop("prior must a list elemnets shape1 and shape2")
    }
  }
  if (is.null(var_prior)){
    #default prior: sigma1^2 ~ IG(1/2,1/2)
    var_prior=list(shape=1/2,rate=1/2)
  }else{
    if(!all(sort(names(var_prior)) ==
            sort(c("shape","rate")))){
      stop("prior must a list elemnets shape and rate")
    }
  }

  #initial values:
  p12_init <- rbeta(1,tran_prior$shape1,tran_prior$shape2)
  p21_init <- rbeta(1,tran_prior$shape1,tran_prior$shape2)
  p_matrix <- matrix(c(1-p12_init,p12_init,p21_init,1-p21_init),nrow = 2,byrow = TRUE)

  v1_init <- 1/rgamma(1, var_prior$shape, var_prior$rate)
  v2_init <- v1_init*rTIG(n=1,truncation=1,shape= var_prior$shape, rate=var_prior$rate)
  var <- c(v1=v1_init,v2=v2_init)

  #Start the Gibbs Sampler
  for(ii in 1:(nsamples+burn)){
    hmm.ups <- hmm.gibbs(y=y,var = var,p_matrix = p_matrix,tran_prior = tran_prior,
                         var_prior = var_prior,q=q,s.out = s.out)
    #arrange for next sample
    p12 <- hmm.ups$p12; p21 <- hmm.ups$p21
    p_matrix <- matrix(c(1-p12,p12,p21,1-p21),nrow = 2,byrow = TRUE)

    if(ii-burn > 0){
      VR_samples[ii-burn,] <- c(hmm.ups$VR, hmm.ups$VR_star)
      if(s.out){
        S[ii-burn,] <- hmm.ups$S
      }
      if(par.out){
        Theta[ii-burn,] <- c(hmm.ups$sigma1,hmm.ups$sigma2, hmm.ups$p12, hmm.ups$p21)
      }
    }
  }
    # Ouput
    if(par.out || s.out){
      out <- list(VR=VR_samples)
    }else{
      out <- VR_samples
    }
    if(s.out){
      out <- c(out, list(S=S))
    }
    if(par.out){
      out <- c(out, list(Theta = Theta))
    }
  out
}
