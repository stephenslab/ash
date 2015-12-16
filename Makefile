.PHONY:	all clean output analysis paper

all:	output analysis paper

clean:	
	cd analysis && $(MAKE) clean

output:	
	cd code && $(MAKE)

analysis:
	cd analysis && $(MAKE)

paper:
	cd paper && $(MAKE)

