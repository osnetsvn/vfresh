#!/usr/bin/gnuplot

set term pdfcairo size 12,8 enhanced font "Arial-Bold,35"
set output 'check.pdf'

set style histogram columnstacked
set boxwidth 0.6 relative
plot for [COL=2:4] 'date_mins.tsv' using COL title columnheader
