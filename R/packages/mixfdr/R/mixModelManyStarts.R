`mixModelManyStarts` <-
function(x, J, N, starts = NA, maxiter = 1000, tol = 0.001, p = NA, muInt = NA, sigInt = 1, theonull = FALSE){
	
# try different starting points
	# getStartsNew
	# all null
	# random
	# choose highest penalized likelihood

	if(any(is.na(starts))){
	starts = array(0, dim=c(5, J, 3))
	sigMAD = median(abs(x))
	sigST = sigInt[1,1]
	if(sigInt[1,1]/sigMAD < 0.25) sigST = sigMAD/2
	starts[1,,] = getStartsNew(x,J, sigST)
	starts[2,,] = cbind(pi = c(0.99, rep(0.01,J-1)/(J-1)), mu = c(0, sample(x,J-1)), sig = rep(sigST,J))
	starts[3,,] = cbind(pi = c(0.99, rep(0.01,J-1)/(J-1)), mu = c(0, sample(x,J-1)), sig = rep(sigST,J))
	for(i in 4:5){
		starts[i,,1] = rep(1,J)/J
		starts[i,,2] = sample(x, J)
		starts[i,,3] = rep(sigST,J)	
	}
	}
	res = array(0, dim = c(dim(starts)[1], J, 3))
#	print(starts)
	for(i in 1:dim(starts)[1]){
		m = mixModelFitter(x, J, N, starts[i,,], maxiter, tol, p, muInt, sigInt)
		res[i,,1] = m$pi
		res[i,,2] = m$mu
		res[i,,3] = m$sig
	}
	
	penLogLik = function(params, x, N, p){
	pi = params[,1]
	mu = params[,2]
	sig = params[,3]
	ll = sum(log(dens.mixture(x, list(pi = pi, mu = mu, sig = sig))))
	alpha = N*p
	pen = sum((alpha-1)*log(pi))
	return(ll + pen)
	}
	
	plls = apply(res, 1, penLogLik, x, N, p)
	bestInd = which.max(plls)
	return(list(pi = res[bestInd,,1], mu = res[bestInd,,2], sigma = res[bestInd,,3], data = x))
}

