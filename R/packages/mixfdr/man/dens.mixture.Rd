\name{dens.mixture}
\alias{dens.mixture}
\alias{effectSize}
\alias{fdrMixModel}
\alias{groupProbs}
\alias{plot.mix.dens}
\alias{tailFDRMixModel}
\title{Calculate fdrs/effect sizes/densities from a mixture model}

\description{
  These functions are used to calculate various quantities derived from a mixture model (fdr,FDR, effectSize, etc.). They are useful if you have a mixture model and you want to calculate, for instance, the fdr estimate on a new data point. They are also very useful for plotting.
}
\usage{
dens.mixture(x, m)
groupProbs(z, m)

effectSize(z, m, noiseSD = NA)
fdrMixModel(z, m, nullGroups = NA)
tailFDRMixModel(z, m, nullGroups = NA)

plot.mix.dens(x, plot.subdens = TRUE, ...)
}
\arguments{
  \item{x}{A vector of new data points for which things are to be calculated.}
  \item{z}{A vector of new data points for which things are to be calculated. The same as \code{x}, just different notation.}
  \item{m}{A mixture model, as returned by \code{\link{mixFdr}}. You can make your own: it should be a list with elements pi, mu, sigma. Each should be a J vector with the appropriate parameter values. Some functions also need another element data, which contains the data the model was fitted on.}
  \item{nullGroups}{A J-length boolean vector indicating which groups should be counted in the null. If NA just takes the first group}
  \item{noiseSD}{The sampling variance (see details for where this comes in the model). If NA, taken from \code{m$noiseSD} if present there, otherwise \code{min(m$sig)}.}
  \item{plot.subdens}{Plot the subdensities?}
  \item{...}{Arguments to pass to \code{hist}. Note \code{prob=TRUE} is already being passed.} 
}
\details{
  \code{dens.mixture} computes the mixture density at each \code{x[i]}
  
  \code{groupProbs} computes the posterior probability that each \code{z[i]} came from each group of the mixture model.
  
  \code{effectSize} computes the posterior mean and variance when \code{z[i]} is observed. The model is that \code{z[i]} is Normal(delta[i],noiseSD), and delta[i] have a normal mixture prior (so that \code{z[i]} have the marginal density given by \code{m}). \code{effectSize} calculates the posterior mean and variance for delta[i] given \code{z[i]}. If \code{noiseSD} is too big (bigger than any of \code{m$sig}) then \code{effectSize} basically increases those \code{m$sig} to be at least \code{noiseSD} and returns a warning.
  
  \code{fdrMixModel} calculates the local false discovery rate (fdr). This is P(delta[i]==0|z[i]), or more generall P(delta[i] null|z[i]).

  \code{tailFDRMixModel} calculates the tail area false discovery rate (FDR). This is P(delta[i]==0||z[i]|>z) (two-sided) or P(delta[i]==0|z[i]>z) (right) or P(delta[i]==0|z[i]<z) (left). \code{tailFDRMixModel} computes all three.
  
  \code{plot.mix.dens} plots a histogram of \code{m$data} and overlays the density curve (with the group subdensities if required).
}
\value{
 \code{dens.mixture} returns a vector of density values.
  
  \code{groupProbs} returns a \code{length(z)} by \code{J} matrix of posterior probabilities.
  
  \code{effectSize} returns a matrix, first column effect sizes, second column posterior variances.
  
  \code{fdrMixModel} returns a vector of fdr's.

  \code{tailFDRMixModel} returns a list. \code{FDRTwoSided}, \code{FDRleft}, \code{FDRright} have two-sided, left and right FDRs respectively.
  
}
\references{See papers at the author's website \url{http://stat.stanford.edu/~omkar}}
\author{Omkar Muralidharan}

\seealso{ \code{\link{mixFdr}} }
\examples{

z = rnorm(10000)
m = mixFdr(z, plots = FALSE)
s = seq(-5,5,by=0.01)
plot(s, dens.mixture(s,m), t = 'l', main = "Mixture Density")
plot(s, groupProbs(s,m)[,1], t = 'l', main = "Prob of being from group 1")
plot(s, effectSize(s,m)[,1], t = 'l', main  = "Effect Size")
plot(s, effectSize(s,m)[,2], t = 'l', main = "Posterior Effect Var")
plot(s, fdrMixModel(s,m), t = 'l', main = "fdr")
plot(s, tailFDRMixModel(s,m)$FDRT, t = 'l', main = "two-sided FDR")
plot.mix.dens(m, TRUE, br = 100)
}
\keyword{ models }
\keyword{ smooth }