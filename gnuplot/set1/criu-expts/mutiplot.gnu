#!/usr/bin/gnuplot

set term pdfcairo size 12,12 font "Arial-Bold,25"
set output 'multiplot.pdf'

set style line 12 lc rgb '#808080' lt 0.5 lw 1
set grid back ls 12

set style line 1 lc rgb '#cb4679' pt 1 ps 3 lt 2 lw 5 # --- magenta
set style line 2 lc rgb '#fb8761' pt 6 ps 3 lt 2 lw 5 # --- green

set xrange [0:1100]
set multiplot layout 2,2

set xlabel 'Dirty Memory (MB)'
set ylabel 'Total Migration Time (s)'
set xrange [0:1100]
set yrange [0:3]

set key top center box font "Arial-Bold,25" width 2 height 0.5 maxcols 2 maxrows 1  spacing 1
set key reverse Left
set key outside
 
#set style arrow 1 head filled size screen 0.03,15,135 lt 2 lw 2
#set arrow 1 from screen .45, .84 to screen .65, .84 arrowstyle 1
#set arrow 2 from screen .87, .64 to screen .87, .3 arrowstyle 1
#set arrow 3 from screen .7, .15 to screen .4, .15 arrowstyle 1
#set arrow 4 from screen .35, .35 to screen .35, .7 arrowstyle 1
#set title "sin(x)"
plot 'busy_process_migration.dat' u 1:2 t 'CRIU' w lp ls 1, \
     ''                  u 1:3 t 'mWarp' w lp ls 2, \

#plot sin(x)
#set title "sin\'(x) = cos(x)"
plot cos(x)
#set title "sin\'\'\'(x) = cos\'\'(x) = -sin\'(x) = -cos(x)"
plot -cos(x)
#set title "sin\'\'(x) = cos\'(x) = -sin(x)"
plot -sin(x)
unset multiplot
