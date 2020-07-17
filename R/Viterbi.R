#' Viterbi Algorithm
#'
#' @param y Vector of mixture Gaussian observation.
#' @param var Vector of variance for observation at each state.
#' @param p_matrix Transition matrix with `(i,j)` indicates transition probability from state i to state j
#' @return Vector of state values, each entry can be either 1 or 2.
#' @description Viterbi algorithm to produce the most likely state values given observation values.

#' @export
viterbi <- function(y, var, p_matrix){
  t <- length(y)#number of observation
  k <- dim(p_matrix)[2]
  #Initialize return series
  s_star <- rep(0,t)
  #Initialize backward indicator matrix
  bpointer <- matrix(NA,t,k)
  delta <- matrix(NA,t,k)

  #Initialize:
  delta[1,] = dnorm(y[1], sd=sqrt(var),log = TRUE)
  for (r in 2:t){
    for (c in 1:k){ #At state c at time r
      a_tj = delta[r-1,]+log(p_matrix[,c])+dnorm(y[r], sd=sqrt(var[c]),log=TRUE)
      #The delta entry:maximum log_p among log_p based on previous state
      # a_t() calculation
      delta[r,c] = max(a_tj)
      #bpointer: which state is most likely based on the previous state
      bpointer[r,c] = which.max(a_tj)
    }
  }
  #State series terminate at the state of:
  s_star[t]= which.max(delta[t,])
  #Find the latent state series backwards
  for (i in 1:(t-1)){
    s_star[t-i] =bpointer[t-i+1,s_star[t-i+1]]
  }
  s_star
}
