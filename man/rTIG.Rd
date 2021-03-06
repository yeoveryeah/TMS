% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rTIG.R
\name{rTIG}
\alias{rTIG}
\title{Random sampling from Left Truncated Inverse Gamma}
\usage{
rTIG(n = 1, truncation = 1, shape, rate)
}
\arguments{
\item{n}{Numer of random draws, default to be 1. If \code{length(n)>1}, the length is taken to be the number required.}

\item{truncation}{Left truncation point, must be positive.}

\item{shape, rate}{Shape parameter of the Inverse Gamma distribution, must be positve}
}
\value{
Scaler or a vector of random numbers from the Left Truncated Inverse Gamma.
}
\description{
Random sampling from Left Truncated Inverse Gamma
}
\details{
The function takes advantage of the fact that if X ~ Gamma(a,b), then 1/X ~ IG(a,b). (See \emph{rIG})

The CDF of Right Truncated Gamma is given by\preformatted{G(x) = F(x)/F(1/truncation), F(x) is cdf of Gamma(a,b), 0<x<1/truncation
}

Inverse CDF method is applied.
}
