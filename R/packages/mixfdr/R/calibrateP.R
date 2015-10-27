`calibrateP` <-
function(m, B = 25){
	getSig0 = function(x, N, J, p, muInt, sigInt){
		starts = array(getStartsNew(x,J), dim = c(2, J, 3));
		starts[1,,] = getStartsNew(x,J)		
		starts[2,,] = cbind(pi = c(0.99, rep(0.01,J-1)/(J-1)), mu = c(0, sample(x,J-1)), sig = rep(sigInt[1,1],J))
		m = mixModelManyStarts(x, J = J, N = N, p = p, muInt = muInt, sigInt = sigInt, starts = starts)
		return(m$sig[1])	
	}
	
	rMixModel = function(n,m,pi0=NA, sig0 = NA){
	J = length(m$pi)	
	pi = m$pi
	if(!is.na(pi0)){
		pi[1] = pi0
		pi[-1] = pi[-1]*(1-pi0)/sum(pi[-1])	
	}
	mu = m$mu
	sig = m$sig
	if(!is.na(sig0)){
		 mu = mu*sqrt(sig0/sig[1])
		 sig[1] = sig0
	}	 
	gp = sample(J, n, rep = TRUE, prob = pi)
	z = rnorm(n)
	data = z * sig[gp] + mu[gp]
	return(data)
}


	N = length(m$data)	
	noiseSD = m$noiseSD
	sig0 = m$sig[1]
	sig0s = pmax(noiseSD,sig0*c(0.8,1,1.3,1.5))
	sig0s = unique(sig0s)

	Ps = seq(100, N/2, length = 20)
	
	data = array(0, dim = c(length(Ps), length(sig0s), B, N))
	cat("Calibration: Generating random data...")
	for(i in 1:length(sig0s)){
		a = rMixModel(N*B, m, sig0 = sig0s[i])	
		for(j in 1:length(Ps))
		data[j,i,,] = a
	}
				J = length(m$sig)
				p = c(1, rep(0,J-1))	
			
				muInt = matrix(0,J,2)
				muInt[,1] = -Inf
				muInt[,2] = Inf		
			  	
			
				sigInt = matrix(0,J,2)
				sigInt[,1] = noiseSD
				sigInt[,2] = Inf

	
	cat("done\n")
	cat(paste("Calibration: Testing ", length(Ps)," different penalization, each B = ",B," times\n",sep=""))
	res = array(0, dim = c(length(Ps), length(sig0s), B))
	for(i in 1:length(Ps)){
		res[i,,] = apply(data[i,,,], c(1,2), getSig0, N = Ps[i], J = J, p = p, muInt = muInt, sigInt = sigInt)
		cat(i,"")	
	}
	cat(" done \n")
	sig0res = array(sig0s, c(length(sig0s), length(Ps), B))
	sig0res = aperm(sig0res, c(2, 1, 3))
	acc = apply(abs(res-sig0res),1,sum)
	minP = which.min(acc)
	return(Ps[minP])	
}

