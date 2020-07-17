#' Singular Variance Ratio Statistics
#'
#' @param y_sd Vector of standardized observations
#' @param q Scaler, the period on which Variance Ratio Test is based
#' @return q-period variance ratio statistics
#' @description Calculate variance ratio given series y to test random-walk hypothesis
#' @details If y_sd follow a random walk, the returned value should be 1.
#' @export
VR.stat <- function(y_sd, q){
  if(! length(y_sd)>=q) stop("Insufficient data length")
  # 1-period and q-period return series
  r_1 <- diff(y_sd, lag = 1)
  r_q <- diff(y_sd, lag = q)
  var_q <- var(r_q)
  if(var_q == 0){
    stop("Zero variance on denominator")
  }else{
    ans <- var_q/(q*var(r_1))
  }
  ans
}
