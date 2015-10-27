`mixFdr` <-
function(x, J = 3, P = NA, noiseSD = NA, theonull = FALSE, calibrate = FALSE, plots= TRUE, nearlyNull = 0.2, starts = NA, p = NA, maxIter = 1000, tol = 0.001, nocheck = FALSE){
# try lower sigma threshhold	
# warn if
	# uncalibrated
	# empirical null is substantially different
	# pi0 is small
 
# return
	# model parameters
	# effect size estimates
	# fdr estimates
	# plot
	
# calibration code
		
		muInt = sigInt = NA
		sigma = noiseSD
		n = length(x)	
		if(any(is.na(p))) p = c(1, rep(0,J-1))	
		if(any(is.na(muInt))){
			muInt = matrix(0,J,2)
			muInt[,1] = -Inf
			muInt[,2] = Inf		
		}  	
		if(any(is.na(sigInt)) | any(is.null(dim(sigInt)))){
			left = sigma
			if(is.na(sigma)) left = 0.1
			sigInt = matrix(0,J,2)
			sigInt[,1] = left
			sigInt[,2] = Inf
		}
		if(theonull){
			muInt[1,1] = muInt[1,2] = 0
			sigInt[1,1] = sigInt[1,2] = 1	
		}
		if(is.na(P)){
			P = length(x)/5
			if(!calibrate && !theonull){
				warning("Using uncalibrated default penalization P,  which can give misleading results for empirical nulls. Consider rerunning with calibrate = TRUE and using the resulting penalization","\n")
				}
		}
		if(!is.na(sigma)){
			warning(paste("Assuming known noise noiseSD = ",sigma,". If needed rerun with noiseSD = NA to fit noiseSD."))
			
		if(!theonull){
			warning("Note that using known noiseSD constrains the null to have sd at least noiseSD. If underdispersion is suspected, rerun with noiseSD = NA.")
			}
		}
		
		cat("Fitting preliminary model", "\n")
		m =  mixModelManyStarts(x, J, P, starts, maxIter, tol, p, muInt, sigInt, theonull)
		m$noiseSD = min(median(abs(x-m$mu[1]))/0.6745, m$sig)
		if(calibrate == TRUE){
			cat("Calibrating penalization (slow)", "\n")
			cat("To avoid this step next time, note the calibrated penalization parameter and supply it to the function.", "\n")
			# Calibrate
			P = calibrateP(m, B = 25)
			cat("Calibrated penalization is", P, "\n")
		}
		
		if(is.na(noiseSD)){
			cat("Fitting noiseSD\n")
			if(theonull){ 
				cat("Theoretical null, so using noiseSD = 1\n")
				sigma = 1
			}
			sigma = min(median(abs(x-m$mu[1]))/0.6745, m$sig[1])
		}
		
		cat("Fitting final model","\n")
		# using fitted sigma
				sigInt = matrix(0,J,2)
				sigInt[,1] = sigma
				sigInt[,2] = Inf
				if(theonull) sigInt[1,1] = sigInt[1,2] = 1
		m = mixModelManyStarts(x, J, P, starts, maxIter, tol, p, muInt, sigInt, theonull)
	
		# if pi0 is small (<0.85) throw a warning
		if(m$pi[1]<0.85){
			warning("Null proportion pi0 is small. Consider increasing penalization and/or using an empirical null.")
		}
		

		if((theonull | !is.na(noiseSD)) && !nocheck){
			# Check if empirical nulls are significantly different
			# if so, throw a warning
				p = c(1, rep(0,J-1))	
			
				muInt = matrix(0,J,2)
				muInt[,1] = -Inf
				muInt[,2] = Inf		
			  	
			
				left = sigma/2
				sigInt = matrix(0,J,2)
				sigInt[,1] = left
				sigInt[,2] = Inf
			

			mEmp = mixModelManyStarts(x, J, P, NA, maxIter, tol, p, muInt, sigInt, theonull = FALSE)
			sigNew = min(median(abs(x-m$mu[1]))/0.6745, mEmp$sig[1])

				left = sigNew
				sigInt = matrix(0,J,2)
				sigInt[,1] = left
				sigInt[,2] = Inf

			mEmp = mixModelManyStarts(x, J, P, starts, maxIter, tol, p, muInt, sigInt, theonull = FALSE)
			
			diffr =   log( dnorm(2.5, m$mu[1], m$sig[1]) / dnorm(2.5, mEmp$mu[1], mEmp$sig[1])  ) 
			if(abs(diffr) > abs(log(3))) warning("Using an empirical null with a fitted noiseSD gives a substantially different model. Consider rerunning with theonull = FALSE and noiseSD = NA.")  
		}
		
		# calculate junk and return it
		nullGroups = abs(m$mu - m$mu[1])<=nearlyNull
		fdrX = fdrMixModel(x, m, nullGroups)
		FDRX = tailFDRMixModel(x, m, nullGroups)
		EffSize = effectSize(x, m, sigma)
		
		res = list(pi = m$pi, mu = m$mu, sigma = m$sigma, noiseSD = sigma, converged = m$converged, nIter = m$nIter, fdr = fdrX, FDRTwoSided = FDRX$FDRTwoSided, FDRLeft = FDRX$FDRleft, FDRRight = FDRX$FDRright, effectSize = EffSize[,1], effectPostVar = EffSize[,2], call = match.call(), data = x)
		
		# plot
		if(plots){
		par(mfrow=c(1,3))
		xl = paste(J, "Groups;","pi0 = ",round(sum(m$pi[nullGroups]),3),", mu0 = ", round(m$mu[1],3), ", \n sig0 = ", round(m$sig[1],3), ", noiseSD = ", round(sigma,3))
		
		
		z = x
		mi = min(z)
		ma = max(z)
		s = seq(mi - 1, ma + 1, by = 0.001)
		hist(z, pr = TRUE, br = 50, main = "Mixture Model Fit", xlab = xl, ylab = "Density")
		lines(s, dens.mixture(s,res), lwd = 2)
		phiMat = matDens(s, m$mu, m$sig) * matrix(m$pi, length(s), J, byrow = TRUE)
		nullDens = rowSums(matrix(phiMat[,nullGroups], length(s), sum(nullGroups)))
		altDens = rowSums(matrix(phiMat[,!nullGroups], length(s), sum(!nullGroups)))
		lines(s, nullDens, lwd = 2, col = 2)
		lines(s, altDens, lwd = 2, col = 3)
		
		legend("topleft", legend = c("Mixture", "Null", "Alternative"), lwd = 2, col = c(1,2,3))
		o = order(res$data)
		plot(res$data[o], res$effectSize[o], t = 'l', main = "Effect Size Estimates", xlab = "z", ylab = "delta.hat")
		abline(0,1, lty = 3)
		plot(res$data[o], res$fdr[o], t = 'l', main = "fdr/FDR curves", xlab = "z", ylim = c(0,1), ylab = "fdr/FDR", col = 1)
		lines(res$data[o], res$FDRTwoSided[o], col = 2)
		legend("bottomleft", legend = c("fdr", "FDR 2 Sided"), col = c(1,2), lwd = c(1,1))
	}
	cat("\n")
	cat("Fitted Model: J = ",J," groups\n", sep = "")
	cat("----------------------------\n")
	cat("null?\t", format(nullGroups, digits = 4, justify="left"),"\n\n", sep = "\t")
	cat("pi =\t", format(round(res$pi,4), justify="left"),"\n\n", sep = "\t")
	cat("mu = \t", format(round(res$mu,4), digits = 4, justify="left"),"\n\n", sep = "\t")
	cat("sigma = ", format(round(res$sigma,4), digits = 4, justify="left"),"\n\n", sep = "\t")
	cat("noiseSD = ", format(round(res$noiseSD,4),digits=4, justify="left"),"\n\n\n", sep = "\t")
	
	return(res)	
}

