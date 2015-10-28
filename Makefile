.PHONY:	all output analysis paper

all:	output analysis paper

output:	
	cd code && $(MAKE)

analysis:
	cd analysis && $(MAKE)

paper:
	cd paper && $(MAKE)

