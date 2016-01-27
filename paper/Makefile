%.png:  %.pdf
	convert -density 300 $< $@


main.pdf:	main.tex ../analysis/figure/plot_lfsr.Rmd/plot_lfdr-1.png ../analysis/figure/plot_lfsr.Rmd/plot_lfsr-1.png ../analysis/figure/plot_lfsr.Rmd/plot_lfsr_s-1.png ../analysis/figure/plot_lfsr.Rmd/plot_lfsr_s_nn-1.png
	pdflatex main.tex; bibtex main.tex; pdflatex main.tex; pdflatex main.tex
