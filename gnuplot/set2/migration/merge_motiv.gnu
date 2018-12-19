#!/usr/bin/env gnuplot

### n: change this parameter to equal the number of data sets to be plotted
n = 2
# l: left margin in pixels
l = 75.0
# k: key height in pixels (right margin)
k = 150.0
# m: margin between plots
m = 40.0
# p: plot width
p = 300.0
# w: width of output in pixels
w = p*n + m*(n-1) + l + k

### functions to help set top/bottom margins
lft(i,n,w,l,k) = (l+(w-l-k)*(i-1)/n)/w
rgt(i,n,w,l,k) = (l+(w-l-k)*i/n - m)/w

### first set up some basic plot parameters
set term pdfcairo size 22,10 font "Arial-Bold,25"
set output 'merge_motiv.pdf'

set ylabel 'Replacement Time (ms)'
set xlabel 'Guest Memory (GB)'

set multiplot layout 1,(n+1) title #'Main title'

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set xtics 0,1,5 font "Arial-Bold,25"
set ytics font "Arial-Bold,25"

set style line 1 lc rgb '#cb4679' pt 1 ps 2 lt 1 lw 5 # --- magenta
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 5 # --- green
set style line 3 lc rgb '#0072bd' pt 2 ps 2 lt 1 lw 5 # --- dark purple
set style line 4 lc rgb '#8b1a0e' pt 4 ps 2 lt 1 lw 5 # --- red

### First plot
# change only plot command here
currentplot = 1
set lmargin at screen lft(currentplot,n,w,l,k)
set rmargin at screen rgt(currentplot,n,w,l,k)

set xrange [0:5]
set yrange [0:1300]

unset key
plot 'idle_guest_migration.dat' u 1:2 t 'Inter-host' w lp ls 1, \
     ''                  u 1:3 t 'Intra-host non-nested' w lp ls 2, \
     ''                  u 1:4 t 'Intra-host nested (pv-pv)' w lp ls 3, \
     ''                  u 1:5 t 'Intra-host nested (pt-pv)' w lp ls 4

set xlabel 'Guest Memory (GB)'
set ylabel 'Replacement Time (ms)'

### Middle data plot (commented out for this example)
# copy and paste this code to make more middle plots
#currentplot = currentplot + 1
#set lmargin at screen lft(currentplot,n,w,l,k)
#set rmargin at screen rgt(currentplot,n,w,l,k)
#unset title
#replot

### Last data plot
# change only plot command here
currentplot = currentplot + 1
set lmargin at screen lft(currentplot,n,w,l,k)
set rmargin at screen rgt(currentplot,n,w,l,k)
replot

### Key plot
#set lmargin at screen rgt(n,n,w,l,k)
#set rmargin at screen 1

set key top center box font "Arial-Bold,35" width 0.4 height 0.5 maxcols 4 maxrows 1  spacing 1
set key reverse Left
set key outside

set border

set tics nomirror
set xtics 0,1,5 font "Arial-Bold,35"
set ytics font "Arial-Bold,35"

# color definitions
set style line 1 lc rgb '#cb4679' pt 1 ps 2 lt 1 lw 5 # --- magenta
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 5 # --- green
set style line 3 lc rgb '#0072bd' pt 2 ps 2 lt 1 lw 5 # --- dark purple
set style line 4 lc rgb '#8b1a0e' pt 4 ps 2 lt 1 lw 5 # --- red

set xlabel 'Guest Memory (GB)'
set ylabel 'Replacement Time (ms)'
set xrange [0:5]
set yrange [0:3500]

plot 'busy_guest_migration.dat' u 1:2 t 'Inter-host' w lp ls 1, \
     ''                  u 1:3 t 'Intra-host non-nested' w lp ls 2, \
     ''                  u 1:4 t 'Intra-host nested (pv-pv)' w lp ls 3, \
     ''                  u 1:5 t 'Intra-host nested (pt-pv)' w lp ls 4

unset multiplot
