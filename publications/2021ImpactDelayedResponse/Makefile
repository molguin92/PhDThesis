SHELL := /bin/bash

document = paper
diffbranch = master
diffdoc = diff
PDFLATEX = pdflatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape
LATEXDIFF = latexdiff --verbose -t INVISIBLE --subtype COLOR --config="PICTUREENV=(?:picture|DIFnomarkup|itemize|enumerate|description)[\w\d*@]*"

all: nofontfigs pdf

pdf: FORCE
	${PDFLATEX} ${document}
	bibtex ${document} 
	${PDFLATEX} ${document} 
	${PDFLATEX} ${document}

clean: FORCE
	for suffix in .ps .log .aux .out .dvi .bbl .blg -blx.bib .run.xml .synctex.gz ; do \
		rm -f ${document}$$suffix ; \
	done
	
gen_diff: FORCE
	git show ${diffbranch}:${document}.tex > ${document}_old.tex
	${LATEXDIFF} ${document}_old.tex ${document}.tex > ${diffdoc}.tex

diff_pdf: FORCE
	${PDFLATEX} ${diffdoc}
	bibtex ${diffdoc} 
	${PDFLATEX} ${diffdoc} 
	${PDFLATEX} ${diffdoc}

FORCE: