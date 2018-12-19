#!/usr/bin/gnuplot
#
# Creates a version of a plot, which looks nice for inclusion on web pages

reset

set term pdfcairo size 12,28 font "Arial-Bold,35"
set output 'qsortps_multiplot.pdf'

set border
set lmargin at screen 0.1
set rmargin at screen 0.97
set tics nomirror

TOP=0.98
DY = 0.31

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set style line 1 lc rgb '#472c7a' lt 1 lw 5 # --- purple

set xrange [1:300]
set yrange [120:200]

#set key top center box font "Arial-Bold,35" width -1 height 1 maxcols 1 maxrows 2 spacing 1
#set key reverse Left
#set key outside

set xtics font "Arial-Bold,35"

set multiplot
set offset 0,0,graph 0.02, graph 0.02

set key bottom right font "Arial-Bold,35"
set xlabel 'Time (seconds)'
unset ylabel
set tmargin at screen TOP-2*DY
set bmargin at screen TOP-3*DY
set ytics 120,20,200 font "Arial-Bold,35"
plot 'qsortps_1GB_nested_precopy_hyperfresh.dat' u 1:2 t 'Hyperfresh' w lp ls 1


set xtics format ''
unset xlabel
set ylabel 'Quicksorts per second' offset 1
set tmargin at screen TOP-DY
set bmargin at screen TOP-2*DY
set ytics 120,20,200 font "Arial-Bold,35"
plot 'qsortps_1GB_nested_precopy_disable_rate_limit.dat' u 1:2 t 'Optimized Pre-copy Live Migration' w lp ls 1

unset ylabel
set tmargin at screen TOP
set bmargin at screen TOP-DY
set ytics 120,20,200 font "Arial-Bold,35"
plot 'qsortps_1GB_nested_precopy.dat' u 1:2 t 'Pre-copy Live Migration' w lp ls 1

unset multiplot; set output
