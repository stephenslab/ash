`getStartsNew` <-
function(x,J, noiseSD = 1){
	# going to have equally
	# one big group in the middle
	pi = rep(1/J,J)
	mid = floor(median(1:J))
	pi[mid] = 0.75
	if(J!=1) pi[-mid] = 0.25/(J-1)
	pi = pi/sum(pi)
	q = quantile(x, c(0,cumsum(pi)))	
	mu = sig = 1:J
	for(i in 1:J){
		dat = x[x<=q[i+1] & x>=q[i]]
		mu[i] = mean(dat)
		sig[i] = noiseSD
	}
	starts = cbind(pi,mu,sig)
	tmp = starts[mid,]
	starts[mid,]= starts[1,]
	starts[1,] = tmp
	return(starts)
}

