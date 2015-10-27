`mixModelFitter` <-
function(x, J, N, starts, maxiter, tol, p, muInt, sigInt){

				
		EMstep = function(x, pi, mu, sig, N, p, muInt, sigInt){
				n = length(x)
				J = length(mu)
				
				# E-step	
				phiMat = matDens(x,mu,sig)
				denominators = (phiMat %*% pi)[,1]
				G = phiMat * ((1/denominators) %o% pi)
				tG = t(G)
				
				# M-step
				numeratorsMu = (tG %*% x)[,1]
				zplusj = rowSums(tG)
				newMu = (numeratorsMu/zplusj)
				newSig = tG %*% (x*x) / zplusj - newMu^2
				
				newMu = pmax(pmin(muInt[,2],newMu),muInt[,1])
				newSig = pmax(pmin(sigInt[,2], sqrt(newSig)), sigInt[,1])
				newPi = (N*p - 1 + zplusj)/(sum(zplusj) + N - J)
				if(N<0) newPi = zplusj/sum(zplusj)
				newPi = (newPi+0.001)
				newPi = pmax(0,pmin(newPi,1))
				newPi = newPi/sum(newPi)
				if(any(is.na(newPi), is.na(newMu), is.na(newSig))){
					print(pi)
					print(mu)
					print(sig)	
				}
				return(list(pi = newPi, mu = newMu, sigma = newSig)) 
			}
		
	# starting points	
		pi = starts[,1]
		mu = starts[,2]
		sigma = starts[,3]
	# that's it, do the loop	
		iter = 0
		converged = FALSE
		while(!converged && iter<maxiter){
			res = EMstep(x, pi, mu, sigma, N, p, muInt, sigInt)
			distance = sum((pi-res$pi)^2)+sum((mu-res$mu)^2) + sum((sigma-res$sigma)^2)
			if(is.na(distance)){
				print(starts)
				print(muInt)
				print(sigInt)	
			}
			if(distance<tol) converged = TRUE
			iter = iter + 1			
			pi = res$pi
			mu = res$mu
			sigma = res$sigma
		}
#		e = list(pi = pi, mu = mu, sigma = sigma, converged = converged, nIter = iter, data = x)
#		fdr = fdrMixModel(x, e, abs(e$mu-e$mu[1])<=nearlyNull)
		return(list(pi = pi, mu = mu, sigma = sigma, converged = converged, nIter = iter))
}

