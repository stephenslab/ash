dsc:	../output/dsc-shrink-files/res.RData	../output/dsc-znull-files/res.znull.RData	../output/dsc-robust-files/dsc_robust.RData

../output/dsc-shrink-files/res.RData:
	cd dsc-shrink; R CMD BATCH run_dsc.R

../output/dsc-znull-files/res.znull.RData
	cd dsc-shrink; R CMD BATCH run_dsc_znull.R

../output/dsc-robust-files/dsc_robust.RData:
	cd dsc-robust; R CMD BATCH run_dsc_robust.R
