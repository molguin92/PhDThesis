#!/usr/bin/env bash +ex

gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/kapa.pdf" -dFirstPage=1 -dLastPage=100 -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperA.pdf" -dFirstPage=101 -dLastPage=108 -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperB.pdf" -dFirstPage=109 -dLastPage=124 -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperC.pdf" -dFirstPage=125 -dLastPage=158 -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperD.pdf" -dFirstPage=159 -dLastPage=176 -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperE.pdf" -dFirstPage=177 -dLastPage=194 -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperF.pdf" -dFirstPage=195 -dLastPage=231 -sDEVICE=pdfwrite "MAIN.pdf"
