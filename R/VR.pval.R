#' P-Values for Bayesian Variance Ratio Test
#'
#' @param vr_t Matrix with each row being the result from each sweep of Gibbs sampler
#' @return p-value of variance ratio test.
#' @details After Gibbs sampler, the p-value is given by
#' ```
#' #(VR>VR_star)/M
#' ```
#' @description Calculate p-values for statistics based on Bayesian Inference for variance ratio test.
#' @export
VR.pval <- function(vr_t){
  logi <- apply(vr_t, 1, function(x) x[1]>x[2])
  mean(logi)
}
