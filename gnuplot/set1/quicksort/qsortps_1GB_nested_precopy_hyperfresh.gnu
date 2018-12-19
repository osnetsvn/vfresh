#!/usr/bin/gnuplot
#
# Creates a version of a plot, which looks nice for inclusion on web pages

reset

set term pdfcairo size 12,8 font "Arial-Bold,35"
set output 'qsortps_1GB_nested_precopy_hyperfresh.pdf'

set border
set lmargin at screen 0.12
set rmargin at screen 0.95
set tics nomirror

#define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set xtics 0,50,300 font "Arial-Bold,35"
set ytics font "Arial-Bold,35"

# color definitions
set style line 1 lc rgb '#3b518b' lt 1 lw 5 # --- magenta

set key top center box font "Arial-Bold,35" width -1 height 1 maxcols 2 maxrows 2  spacing 1
set key reverse Left
set key outside

set xlabel 'Time (seconds)'
set ylabel 'Quicksorts per second'
set xrange [0:300]
set yrange [100:200]

plot 'qsortps_1GB_nested_precopy_hyperfresh.dat' u 1:2 t 'Quicksorts per second' w lp ls 1
