HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd)) \
              $(patsubst %.md, %.html ,$(wildcard *.md))

all: html


html: $(HTML_FILES)

%.html: %.Rmd
	export R_LIBS_USER=../packrat/lib/*/*; R --slave -e "set.seed(100);rmarkdown::render('$<')"

%.html: %.md
	export R_LIBS_USER=../packrat/lib/*/*; R --slave -e "set.seed(100);rmarkdown::render('$<')"

.PHONY: clean
clean:
	$(RM) $(HTML_FILES)
	$(RM) -r figure/*
	$(RM) table/*.tex
