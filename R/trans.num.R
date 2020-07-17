#' State Transition Steps for Two-Satet Makov Chian
#'
#' @param S Vector of the state values. Each element of S must be either 1 or 2 indicating the state values.
#' @description Count the transitions happend in S.
#' @return A list of the number of transitions of all four possible transition.
#' @export
trans.num <- function(S){
  S_pair <- table(paste0(head(S,-1), tail(S,-1)))
  #check wehter all transition occcurs
  if(! dim(S_pair) == 4){
    all_tran <- c("11","12","22","21")
    missing <- all_tran[!all_tran %in% dimnames(S_pair)[[1]]]
    S_pair[missing] <- 0
  }
  n_12 <- as.numeric(S_pair["12"]);n_11 <-as.numeric(S_pair["11"])
  n_21 <- as.numeric(S_pair["21"]);n_22 <-as.numeric(S_pair["22"])
  return(list(n12 = n_12, n11 = n_11, n21=n_21, n22 =n_22))
}
