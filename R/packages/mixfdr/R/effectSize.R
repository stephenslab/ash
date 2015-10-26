`effectSize` <-
function(z, m, noiseSD = NA){
	e = m
	if(!is.null(m$noiseSD) && is.na(noiseSD)){
		noiseSD = m$noiseSD
	}else{
		if(is.na(noiseSD)) noiseSD = min(m$sig)	
	}
	sig = noiseSD
	if(any(e$sig<sig)) warning(paste("Marginal variance of a group is less than noise variance, this is impossible under the model."))
	gpProb = groupProbs(z,e)
	priorVar = pmax(e$sig^2 - sig^2,0)
	postVars = 1/((1/priorVar) + (1/sig^2)) * (priorVar != 0)
	postMeans =  matrix(z, length(z),length(e$mu),byrow=FALSE)/sig^2
	postMeans = postMeans + matrix((e$mu)/(priorVar),length(z),length(e$mu),byrow=TRUE)
	postMeans = postMeans * matrix(postVars, length(z), length(e$mu), byrow= TRUE)
	postMeans[is.nan(postMeans)] = 0
	postMeans = postMeans + matrix((priorVar ==0)*e$mu, length(z), length(e$mu), byrow = TRUE)
	postMeansSq = postMeans^2 + matrix(postVars, length(z), length(e$mu), byrow = TRUE)
	EdeltZ = rowSums(postMeans * gpProb)
	VdeltZ = rowSums(postMeansSq * gpProb) - EdeltZ^2
	return(cbind(Edz = EdeltZ, Vdz = VdeltZ))
}

