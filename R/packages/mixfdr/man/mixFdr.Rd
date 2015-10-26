\name{mixFdr}
\alias{mixFdr}
\title{ Fit a mixture model and use it to estimate fdr/FDR/effect sizes}
\description{
This is the main function for this package. It fits a normal mixture model and uses it to estimate fdr's, FDR's and effect sizes.
}
\usage{
mixFdr(x, J = 3, P = NA, noiseSD = NA, theonull = FALSE, calibrate = FALSE, plots = TRUE, nearlyNull = 0.2, starts = NA, p = NA, maxIter = 1000, tol = 0.001, nocheck = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ The data. A numeric vector. For example, a vector of transformed t-statistics.}
  \item{J}{ The number of mixture components. }
  \item{P}{ The penalization parameter. If \code{NA} and \code{calibrate} is \code{FALSE}, will be \code{length(x)/5}. If \code{calibrate = TRUE}, chosen by calibration. A higher \code{P} pushes the model toward one big null group, so the center is fit more closely.}
  \item{noiseSD}{ The sampling noise (see details). For transformed t-statistics, or transformed p-values, take this to be 1 at least to start. If \code{NA}, fit using a combination of the mixture model and the median of absolute devations estimator. Note that it is hard to estimate both \code{noiseSD} and the empirical null accurately at the same time. If your data is overdispersed, and you try to estimate both, you'll probably end up with \code{noiseSD} being about as large as the empirical null sd. This is not a problem for fdr/FDR's but it can be a problem for effect sizes (if the signal is known to be sparse, it's ok. }
  \item{theonull}{ Use the theoretical N(0,1) null? }
  \item{calibrate}{ Choose \code{P} by calibration? Note that calibration can be quite slow. }
  \item{plots}{ Produce plots? }
  \item{nearlyNull}{ How big does \code{abs(mu[j])} need to be for a group to be considered non-null? 0 will ensure that only the first group is null. }
  \item{starts}{ An optional matrix of starting points. This is passed straight to \code{\link{mixModelManyStarts}}, see that page for more information.}
  \item{p}{ The penalization shape parameter, a vector of length \code{J}. The penalty on the mixture proportions is Dirichlet(P*p). Nearly always (1,0,...,0)}
  \item{maxIter}{ Maximum number of iterations. }
  \item{tol}{ Convergence tolerance }
  \item{nocheck}{ If \code{FALSE}, \code{mixFdr} will fit an empirical null model and warn you if the fitted model is very different. Set \code{TRUE} if you know what you're doing and need things to be faster.}
}
\details{
  This function estimates effect sizes, fdr's and FDR's. If you don't want to get into the details, run it with defaults (perhaps using \code{theonull} to fit a theoretical or empirical null). The object returned has the estimates, see "Value".

  Here is a short explanation of the mixture model - for a full account, see the papers on the author's website. Suppose we have z[i]~Normal(delta[i],  noiseSD). We want to estimate delta[i], P(delta[i]=0|z[i]), and P(delta[i]=0||z[i]|>z) (effect size, fdr, FDR). Given a prior for delta we can do this. The mixture model \emph{fits} the prior based on the data, using a J group normal mixture model. A theoretical null means the first mixture component is a point mass at 0. An empirical null allows the first mixture component to vary. The mixture proportions are given a Dirichlet(P*p) penalty to stabilize them and to fit empirical nulls if required.
  
  The upshot here is that no matter what the options, the density corresponding to the fitted model needs to fit the data well for any inference to be trustworthy. Look at the histogram plot produced by \code{mixFdr}. If the density doesn't fit well, particularly near the center, try using an empirical null (\code{theonull=FALSE}), increasing the number of groups, calibrating the penalization (or experimenting with it).
  
  If you need to incorporate \code{mixFdr}'s estimates into another procedure, \code{mixFdr} may be too slow. See \code{\link{mixModelFitter}} for the workhorse fitting function, which is much faster.
  
  }
\value{
  A list of objects. They can be divided into the fitted model, and derived estimates. \emph{The fitted model parameters are for the marginals density NOT the prior on delta}. 
  \item{pi }{Mixture proportions}
  \item{mu }{Mean of each mixture component}
  \item{sigma}{Sd of each mixture component}
  \item{noiseSD}{Fitted or supplied sampling SD}
  \item{converged}{Did the EM converge?}
  \item{nIter}{How many iterations}
  \item{fdr}{local false discovery rate estimates for each case}
  \item{FDRTwoSided}{Two sided FDR estimates for each case}
  \item{FDRLeft}{Left-tail FDR estimates for each case}
  \item{FDRRight}{Right-tail FDR estimates for each case}
  \item{effectSize}{Effect size estimates for each case}
  \item{effectPostVar}{Estimates of the posterior variance of the effect size for each case}
  \item{call}{The call}
  \item{data}{The supplied data}
}
\references{ See papers at the author's website \url{http://stat.stanford.edu/~omkar} }
\author{Omkar Muralidharan}
\seealso{ \code{\link{effectSize}}, \code{\link{mixModelFitter}} }
\examples{

## A simple workflow

z = c(rnorm(10000, 0.1, 1.2), rnorm(1000, 3, 1)) # null, alternative
m = mixFdr(z, theonull = TRUE)

# uh-oh, warning
# Just visually, the fit is not so good near the center
# Let's try an empirical null 

m = mixFdr(z)

# Better. But see how the effect size estimate changes with noiseSD. 

# We usually want:
m$fdr
m$effectSize
m$FDRTwoSided

# Suppose we have data with known noise level 1

 z = c(rnorm(1000), rnorm(100,3,1))
 m = mixFdr(z, J = 3, noiseSD = 1)
 delta = m$effectSize
 fdrs = m$fdr
 
# Suppose we wanted fdr and effect size curves
# then we could do

 s = seq(-5,5,by=0.01)
 effCurve = effectSize(s,m)[,1]
 fdrCurve = fdrMixModel(s,m,abs(m$mu - m$mu[1])<=0.2) # this tells it which indices to consider null

# compare to the Bayes estimator for this problem
 mTrue = list(pi = c(10,1)/11, mu = c(0,3), sig = c(1,1))
# note that the model parameters are in terms of the MARGINAL not of the prior
 trueEff = effectSize(s,mTrue)[,1]
 trueFdr = fdrMixModel(s,mTrue,c(TRUE,FALSE))
 par(mfrow = c(2,1))
 plot(s, trueEff, t = 'l', main = "Effect Size - Black is true", xlab = "z", ylab = "E(delta|z)", ylim = c(-3,3))
 lines(s, effCurve, col = 2)
 plot(s, trueFdr, t = 'l', main = "fdr - Black is true", xlab = "z", ylab = "fdr", ylim = c(0,1))
 lines(s, fdrCurve, col = 2)


}

\keyword{ models }
\keyword{ smooth }