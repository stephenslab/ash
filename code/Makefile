dsc-shrink:	../output/dsc-shrink-files/res.RData	
dsc-null:	../output/dsc-znull-files/res.znull.RData	
dsc-opt:	../output/dsc-opt-files/dsc_opt.RData

../output/dsc-shrink-files/res.RData:
	export R_LIBS_USER=../../packrat/lib/*/*; cd dsc-shrink; R CMD BATCH run_dsc.R

../output/dsc-znull-files/res.znull.RData:
	export R_LIBS_USER=../../packrat/lib/*/*; cd dsc-shrink; R CMD BATCH run_dsc_znull.R

../output/dsc-opt-files/dsc_opt.RData:
	export R_LIBS_USER=../../packrat/lib/*/*; cd dsc-opt; R CMD BATCH run_dsc_opt.R
