\name{calibrateP}
\alias{calibrateP}
\alias{getStartsNew}
\alias{matDens}
\alias{mixModelFitter}
\alias{mixModelManyStarts}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{Internal Utility Functions}
\description{
  These functions are used by mixfdr to calculate various things. calibrateP is used to calibrate the penalization, and getStartsNew gets a reasonable starting point for the fitting. matDens computes a density matrix. mixModelFitter is the workhorse model fitter, and mixModelManyStarts is used to try various starting points.
}
\usage{
calibrateP(m, B = 25)
getStartsNew(x, J, noiseSD = 1)
matDens(x, mu, sig)
mixModelFitter(x, J, N, starts, maxiter, tol, p, muInt, sigInt)
mixModelManyStarts(x, J, N, starts = NA, maxiter = 1000, tol = 0.001, p = NA, muInt = NA, sigInt = 1, theonull = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{m}{A mixture model, that is, a list with pi, mu and sigma vectors of the same length, and a data vector}
  \item{B}{Number of bootstrap datasets to generate for each candidate penalization}
  \item{x}{Data to fit on. For \code{matDens}, any vector of points to calculate the densities on}
  \item{mu}{A vector of means}
  \item{sig}{A vector of standard deviations. Should be the same length as mu}
  \item{J}{Number of mixture components}
  \item{noiseSD}{The sampling standard deviation}
  \item{N}{Somewhat confusingly, the penalization parameter. Called P by  functions intended for user use}
  \item{starts}{A matrix of starts. The matrix should be J x 3, with column 1 for pi, 2 for mu, and 3 for sigma. For \code{mixModelManyStarts}, this should be an array, with dimension (num starts, J, 3). }
  \item{maxiter}{Max number of iterations}
  \item{tol}{Convergence tolerance}
  \item{p}{Penalization vector. Must be of length J. Nearly always (1,0,...,0)}
  \item{muInt}{mu constraints, a J x 2 matrix. \code{mu[j]} will be forced to lie in \code{[mu[j,1],mu[j,2]}.\code{Inf} and \code{-Inf} allowed. If missing, each row will be \code{[-Inf,Inf]}}
  \item{sigInt}{sigma constraints, similar to muInt. First column should be positive. For \code{mixModelManyStarts}, if a constant s, each row will be \code{[s,Inf]}}
  \item{theonull}{Use the theoretical null? If true, sets \code{muInt[1,] = 0} and \code{sigInt[1,] = 1}}
}

\details{
	These functions are not intended for user use, with the possible exception of \code{calibrateP}. Most people will want to use \code{\link{mixFdr}} and/or one of the utilities like \code{\link{effectSize}}.

	\code{calibrateP} perturbs the null standard deviation of the supplied model and fits many models with many penalizations to try and see which penalization is best when the true model is "close" to the supplied model. It can be quite slow. 
	
	\code{getStartsNew} finds a decent starting point by dividing up the data into J quantile groups, with the middle group larger than the others. It then calculates the within group mean and sd to use as mu and sigma starting points.
	
	\code{matDens} is a faster way to compute \code{dnorm(x[i],mu[j],sig[j])} for all \code{i} and \code{j}
	
	\code{mixModelFitter} fits the mixture model with the EM algorithm. It is fairly quick.
	
	\code{mixModelManyStarts} fits many mixture models (with different starting points) and chooses the one with the highest penalized likelihood.
 
}
\value{
 \code{calibrateP} returns a penalization. \code{getStartsNew} returns a start matrix. \code{matDens} returns a matrix \code{M} with \code{M[i,j] = dnorm(x[i],mu[j],sig[j])}. \code{mixModelFitter} and \code{mixModelManyStarts} return mixture models - lists with pi, mu, sigma, and data elements.
}
\references{See papers at the author's website \url{http://stat.stanford.edu/~omkar}}
\author{Omkar Muralidharan}
\seealso{ \code{\link{mixfdr}}, \code{\link{effectSize}} }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ models }
