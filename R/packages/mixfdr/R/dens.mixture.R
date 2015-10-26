`dens.mixture` <-
function(x,m){
	mu = m$mu
	pi = c(m$pi)
	sig = m$sig
	phiMat = matDens(x,mu,sig)
	return((phiMat %*% pi)[,1])
}

