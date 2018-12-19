#!/usr/bin/gnuplot
#
# Creates a version of a plot, which looks nice for inclusion on web pages

reset

set term pdfcairo size 12,8 font "Arial-Bold,35"
set output 'sysbench_performance.pdf'

set border
set lmargin at screen 0.1
set rmargin at screen 0.95
set tics nomirror

#define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set logscale x 2
#set xtics 0,,1024 font "Arial-Bold,35"
set ytics font "Arial-Bold,35"

# color definitions
set style line 1 lc rgb '#5e9c36' pt 6 ps 3 lt 2 lw 6 # --- magenta
set style line 2 lc rgb '#fb8761' pt 7 ps 3 lt 2 lw 6 # --- green
set style line 3 lc rgb '#cb4679' pt 1 ps 3 lt 2 lw 6 # --- orange

set key top center box font "Arial-Bold,35" width 1 height 1 maxcols 3 maxrows 1  spacing 1
set key reverse Left
set key outside

set xlabel 'Guest Memory (GB)'
set ylabel 'Total Migration Time (ms)'
set xrange [128:1100]
set yrange [0:14]

plot 'sysbench_performance.dat' u (2**$1):2 t 'Baseline' w lp ls 1, \
     ''                  u (2**$1):3 t 'mWarp' w lp ls 2, \
     ''                  u (2**$1):4 t 'CRIU' w lp ls 3
