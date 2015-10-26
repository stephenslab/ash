\name{mixfdr-package}
\alias{mixfdr-package}
\alias{mixfdr}
\docType{package}
\title{
Computes false discovery rates and effect sizes using normal mixtures
}
\description{
This package fits normal mixture models to data and uses them to compute effect size estimates and local and tail area false discovery rates. To make this precise, suppose you have many normally distributed z's, and each z[i] has mean delta[i]. This package will estimate delta[i] based on the z's (effect sizes), P(delta[i]=0|z[i]) (local false discovery rates) and P(delta[i]=0||z[i]|>z) (tail area false discovery rates).
}
\details{
\tabular{ll}{
Package: \tab mixfdr\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2009-07-21\cr
License: \tab GPL-2\cr
LazyLoad: \tab yes\cr
}
See the help file for \code{\link{mixFdr}} for an explanation and common usage.
}
\author{
Omkar Muralidharan, with many suggestions from Bradley Efron
Maintainer: Omkar Muralidharan <omkar@stanford.edu>
}
\references{
See papers at the author's website \url{http://stat.stanford.edu/~omkar}
}

\keyword{ package }
\keyword{ models }
\keyword{ smooth }
