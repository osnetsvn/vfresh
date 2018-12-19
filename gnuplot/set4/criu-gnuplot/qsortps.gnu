#!/usr/bin/gnuplot
#
# Creates a version of a plot, which looks nice for inclusion on web pages

reset

set term pdfcairo size 25,5 font "Arial-Bold,35"
set output 'qsortps.pdf'

set border
set lmargin at screen 0.13
set rmargin at screen 0.95
set tics nomirror

#define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set xtics 0,50,300 font "Arial-Bold,35"
set ytics font "Arial-Bold,35"

# color definitions
set style line 1 lc rgb '#cb4679' pt 1 ps 3 lt 2 lw 6 # --- magenta
set style line 2 lc rgb '#fb8761' pt 7 ps 3 lt 2 lw 6 # --- orange

set key top center box font "Arial-Bold,35" width 1.5 height 1 maxcols 3 maxrows 1  spacing 1
set key reverse Left
set key outside

set xlabel 'Time (s)'
set ylabel 'Quicksorts per second'
set xrange [0:70]
set yrange [150:200]

plot 'qsortps.dat' u 1:3 t 'Optimized Pre-copy' w lp ls 1, \
     ''            u 1:2 t 'Hyperfresh' w lp ls 2
