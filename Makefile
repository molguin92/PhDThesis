DOCNAME := MAIN

SOURCES := $(DOCNAME).tex $(wildcard ./body/*.tex) $(wildcard ./body/**/*.tex)
PDFTEX := pdflatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape

.PHONY : clean

MAIN.pdf : $(SOURCES)
	$(PDFTEX) $<
	bibtex $(DOCNAME)
	$(PDFTEX) $<
	$(PDFTEX) $<

clean :
	rm -f *.pdf *.aux *-blx.bib *.bbl *.blg *.dvi *.log *.out *.run.xml *.synctex.gz *.toc
	rm -f body/*.aux
	rm -f body/**/*.aux
