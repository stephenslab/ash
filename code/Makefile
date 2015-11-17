dsc:	../output/dsc-shrink-files/res.RData	../output/dsc-znull-files/res.znull.RData	../output/dsc-robust-files/dsc_robust.RData

../output/dsc-shrink-files/res.RData:
	export R_LIBS_USER=../../packrat/lib/*/*; cd dsc-shrink; R CMD BATCH run_dsc.R

../output/dsc-robust-files/dsc_robust.RData:
	export R_LIBS_USER=../../packrat/lib/*/*; cd dsc-robust; R CMD BATCH run_dsc_robust.R
