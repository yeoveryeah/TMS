#' Bayesian Transition Matrix Generation from Beta Distribution
#'
#' @param S Vector of the state values. Each element of S must be either 1 or 2 indicating the state value.
#' @param shape1,shape2 non-negative parameters of the Beta distribution
#' @return A `2 x 2` transition matrix with row sum being 1.
#' @description Calculate transition matrix given state transition histories.
#' @details The conjugate prior of transition probability p_12 and p_21 are iid Beta(shape1, shape2).
#'
#'  The independent posterior follows Beta distribution given number of transitions among states.
#' @export
transition <- function(S, shape1, shape2){
  tran.tab <- trans.num(S)
  n_12 <- tran.tab$n12;n_11 <-tran.tab$n11
  n_21 <- tran.tab$n21;n_22 <-tran.tab$n22
  #Posterior
  p12 <- rbeta(1,shape1+n_12, shape2+n_11)
  p21 <- rbeta(1,shape1+n_21, shape2+n_22)

  return(list(p12=p12, p21=p21))
}

