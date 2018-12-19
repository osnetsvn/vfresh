#!/usr/bin/gnuplot
#
# Creates a version of a plot, which looks nice for inclusion on web pages

reset

set term pdfcairo size 12,8 font "Arial-Bold,35"
set output 'memory_usage_process_migration_tmt.pdf'

set border
set lmargin at screen 0.14
set rmargin at screen 0.95
set tics nomirror

#define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set xtics 0,250,1200 font "Arial-Bold,35"
set ytics font "Arial-Bold,35"

# color definitions
set style line 1 lc rgb '#cb4679' pt 1 ps 3 lt 2 lw 6 # --- magenta
set style line 2 lc rgb '#fb8761' pt 7 ps 3 lt 2 lw 6 # --- orange

set key top center box font "Arial-Bold,35" width 2 height 1 maxcols 2 maxrows 1 spacing 1
set key reverse Left
set key outside

set xlabel 'Total Memory Usage (MB)'
set ylabel 'Total Migration Time (s)'
set xrange [0:1200]
set yrange [0:3]

plot 'memory_usage_process_migration_tmt.dat' u 1:3 t 'CRIU' w lp ls 1, \
     ''                  u 1:2 t 'mWarp' w lp ls 2, \
