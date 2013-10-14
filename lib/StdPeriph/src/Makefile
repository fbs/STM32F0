all: pdf

pdf: doxy.conf
	doxygen doxy.conf
	cd latex; make -s > /dev/null
	mkdir -p ../../../doc
	cp latex/refman.pdf ../../../doc/StdPeriph.pdf
	rm -rf latex
