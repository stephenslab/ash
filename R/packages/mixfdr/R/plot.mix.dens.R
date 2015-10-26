`plot.mix.dens` <-
function(x, plot.subdens = TRUE, ...){
	z = x$data
	mi = min(z)
	ma = max(z)
	s = seq(mi - 1, ma + 1, by = 0.001)
	hist(z, pr = TRUE, ...)
	lines(s, dens.mixture(s,x), lwd = 2)
	J = length(x$mu)
	if(plot.subdens == TRUE){
	for(j in 1:J){
		lines(s, x$pi[j] * dnorm(s, x$mu[j],x$sigma[j]),col=min(3, j+1), lwd = 2)
	}	
	}
}

