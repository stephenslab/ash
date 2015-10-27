`fdrMixModel` <-
function(z,m, nullGroups = NA){
	e = m
	if(any(is.na(nullGroups))){
		 nullGroups = rep(FALSE, length(e$mu))
		 nullGroups[1] = TRUE
	}
	G = groupProbs(z,e)
	rowSums(matrix(G[,nullGroups],ncol = sum(nullGroups)))
}

