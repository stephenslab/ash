`tailFDRMixModel` <-
function(z, m, nullGroups = NA){
	e = m
	if(any(is.na(nullGroups))){
		 nullGroups = rep(FALSE, length(e$mu))
		 nullGroups[1] = TRUE
	}
	# for each group, compute P(|z|>z)
	# P(Z > z) + P(Z < -z)
	# P(Z > (z - mu)/sigma) + P(Z < (-z - mu)/sigma)
	
	A = matrix(z, length(z), length(e$mu))
	ri = A - matrix(e$mu, length(z), length(e$mu), byrow = TRUE)
	ri = ri/matrix(e$sig, length(z), length(e$sig), byrow = TRUE)
	le = -A - matrix(e$mu, length(z), length(e$mu), byrow = TRUE)
	le = le/matrix(e$sig, length(z), length(e$sig), byrow = TRUE)
	pRi = 1 - pnorm(ri)
	pLe = pnorm(le)
	pMix2sd = (pRi + pLe)*matrix(e$pi, length(z), length(e$pi), byrow = TRUE)
	nullProb = rowSums(matrix(pMix2sd[,nullGroups],ncol = sum(nullGroups)))
	overallProb = rowSums(pMix2sd)
	twoSided = ((nullProb/overallProb)*(z>=0) + rep(sum(e$pi[nullGroups]), length(z)) *(z<0))
	ppRi = pRi*matrix(e$pi, length(z), length(e$pi), byrow = TRUE)
	right = rowSums(matrix(ppRi[,nullGroups],ncol = sum(nullGroups)))/rowSums(ppRi)
	ppRi = pnorm(ri)*matrix(e$pi, length(z), length(e$pi), byrow = TRUE)
	left = rowSums(matrix(ppRi[,nullGroups],ncol = sum(nullGroups)))/rowSums(ppRi)
	return(list(FDRTwoSided = twoSided, FDRleft = left, FDRright = right))
}

