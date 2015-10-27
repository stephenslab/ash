`groupProbs` <-
function(z,m){
	e = m
	mu = e$mu
	pi = c(e$pi)
	sig = e$sig
	phiMat = matDens(z,mu,sig)
	dens = (phiMat %*% pi)[,1]
	gpProbs = phiMat / matrix(dens, nrow(phiMat), ncol(phiMat), byrow = FALSE) * matrix(pi, nrow(phiMat), ncol(phiMat), byrow =TRUE)
	}

