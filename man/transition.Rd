% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transition.R
\name{transition}
\alias{transition}
\title{Bayesian Transition Matrix Generation from Beta Distribution}
\usage{
transition(S, shape1, shape2)
}
\arguments{
\item{S}{Vector of the state values. Each element of S must be either 1 or 2 indicating the state value.}

\item{shape1, shape2}{non-negative parameters of the Beta distribution}
}
\value{
A \verb{2 x 2} transition matrix with row sum being 1.
}
\description{
Calculate transition matrix given state transition histories.
}
\details{
The conjugate prior of transition probability p_12 and p_21 are iid Beta(shape1, shape2).

The independent posterior follows Beta distribution given number of transitions among states.
}
