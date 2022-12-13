PDFLATEXFLAGS := -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape

.PHONY: split cover_letter.pdf

paper.pdf: paper.tex *.tex bibliography.bib bios/* figs/* model_data/* tables/*
	pdflatex $(PDFLATEXFLAGS) $<

split: paper.pdf
	gs -sDEVICE=pdfwrite \
		-dNOPAUSE \
		-dBATCH \
		-dSAFER \
		-dFirstPage=1 \
		-dLastPage=16 \
		-sOutputFile=paper_no_app.pdf $<
	
	gs -sDEVICE=pdfwrite \
		-dNOPAUSE \
		-dBATCH \
		-dSAFER \
		-dFirstPage=17 \
		-dLastPage=18 \
		-sOutputFile=appendix.pdf $<