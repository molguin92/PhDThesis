document=paper
PDFLATEX=pdflatex -synctex=1 -interaction=nonstopmode -file-line-error -pdf

all: nofontfigs pdf

pdf: FORCE
	${PDFLATEX} ${document}
	bibtex ${document} 
	${PDFLATEX} ${document} 
	${PDFLATEX} ${document}

nofontfigs: FORCE
	$(MAKE) -C ./plots/comparison/

clean: FORCE
	for suffix in .ps .log .aux .out .dvi .bbl .blg -blx.bib .run.xml .synctex.gz ; do \
		rm -f ${document}$$suffix ; \
	done

FORCE:
