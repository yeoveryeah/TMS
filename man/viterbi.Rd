% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Viterbi.R
\name{viterbi}
\alias{viterbi}
\title{Viterbi Algorithm}
\usage{
viterbi(y, var, p_matrix)
}
\arguments{
\item{y}{Vector of mixture Gaussian observation.}

\item{var}{Vector of variance for observation at each state.}

\item{p_matrix}{Transition matrix with \verb{(i,j)} indicates transition probability from state i to state j}
}
\value{
Vector of state values, each entry can be either 1 or 2.
}
\description{
Viterbi algorithm to produce the most likely state values given observation values.
}
