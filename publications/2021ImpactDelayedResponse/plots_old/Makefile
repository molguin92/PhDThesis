# remove fonts from MatplotLib figures
nofontsfigs: FORCE
	rm -rf ./nofonts
	mkdir ./nofonts
	for pdf in $(wildcard *.pdf) ; do \
		pdf2svg $$pdf ./nofonts/$$pdf.svg && \
		inkscape --export-pdf=./nofonts/$$pdf ./nofonts/$$pdf.svg && \
		rm -f ./nofonts/$$pdf.svg ; \
	done

FORCE: