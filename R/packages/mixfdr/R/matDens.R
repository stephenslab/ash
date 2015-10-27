`matDens` <-
function(x, mu, sig){
	n = length(x)
	J = length(mu)
	res = matrix(x, n, J) - matrix(mu, n, J, byrow = TRUE)
	ss = matrix(1/sig,n,J,byrow=TRUE)
	res = res * ss # divide each column j by sigma[j]
	res = dnorm(0) * exp(-0.5 * res^2) #stupid pi renaming nonsense
	res = res * ss # divide again
	return(res)
#	return(matDensC(x,mu,sig))
}

