#!/usr/bin/gnuplot

set term pdfcairo size 14,8 font "Arial-Bold,20"
set output 'motiv.pdf'

set border 
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set xtics 0,1,5 font "Arial-Bold,20"
set ytics font "Arial-Bold,20"

# color definitions
set style line 1 lc rgb '#cb4679' pt 1 ps 2 lt 1 lw 5 # --- magenta
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 5 # --- green
set style line 3 lc rgb '#0072bd' pt 2 ps 2 lt 1 lw 5 # --- dark purple
set style line 4 lc rgb '#8b1a0e' pt 4 ps 2 lt 1 lw 5 # --- red
set style line 5 lc rgb '#fb8761' pt 7 ps 2 lt 1 lw 5 # --- orange

set multiplot layout 1,2 \
	margins 0.1,0.98,0.1,0.9 \
              spacing 0.08,0.08
#set lmargin 10
#set rmargin 1
#set tmargin 4
#set bmargin 4
#set format ''

set key at 5,1450

#set key center top box font "Arial-Bold,25" width 4 height 1 maxcols 3 maxrows 2  spacing 1
#set key reverse Left
#set key outside

#set bmargin at screen 50
#set key center center
set key top center box font "Arial-Bold,20" width 1.6 height 1 maxcols 2 maxrows 2 spacing 1.0
set border 
#unset tics
#unset xlabel
#unset ylabel
#set yrange [0:1]

set xlabel 'Guest Memory (GB)'
set ylabel 'Replacement Time (ms)'
set xrange [0:5]
set yrange [0:1300]

plot 'idle_guest_migration_with_hyperfresh.dat' u 1:2 t 'Inter-host' w lp ls 1, \
     ''                  u 1:3 t 'Intra-host non-nested' w lp ls 2, \
     ''                  u 1:4 t 'Intra-host nested (pv-pv)' w lp ls 3, \
     ''                  u 1:5 t 'Intra-host nested (pt-pv)' w lp ls 4, \
     ''                  u 1:6 t 'VFresh' w lp ls 5

unset key
set xlabel 'Guest Memory (GB)'
set ylabel 'Replacement Time (ms)'
set xrange [0:5]
set yrange [0:3500]

plot 'busy_guest_migration_with_hyperfresh.dat' u 1:2 t 'Inter-host' w lp ls 1, \
     ''                  u 1:3 t 'Intra-host non-nested' w lp ls 2, \
     ''                  u 1:4 t 'Intra-host nested (pv-pv)' w lp ls 3, \
     ''                  u 1:5 t 'Intra-host nested (pt-pv)' w lp ls 4, \
     ''                  u 1:6 t 'VFresh' w lp ls 5

unset multiplot
