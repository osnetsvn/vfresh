#!/usr/bin/gnuplot

# Output to PNG, with Verdana 8pt font
#set terminal pngcairo nocrop enhanced font "verdana,8" size 640,300

reset

set term pdfcairo size 12,8 enhanced font "Arial-Bold,35"
set output 'quicksort.pdf

# Don't show the legend in the chart
set nokey 

# Thinner, filled bars
set boxwidth 0.3
set style fill solid 1.00 border lt -1 

# Set a title and Y label. The X label is obviously months, so we don't set it.
#set title "Number of registrations per month" font ",14" tc rgb "#606060"
set ylabel "Runtime (seconds)"

# Rotate X labels and get rid of the small stripes at the top (nomirror)
set border
set lmargin at screen 0.1
set rmargin at screen 0.95
set tics nomirror

#set xtics nomirror rotate by -45

# Show human-readable Y-axis. E.g. "100 k" instead of 100000.
#set format y '%.0s %c'

# Replace small stripes on the Y-axis with a horizontal gridlines
set tic scale 0
set grid ytics lc rgb "#808080"

# Manual set the Y-axis range
set yrange [0:75]
set ytics 0,15,75 font "Arial-Bold,35"
set xtics font "Arial-Bold,35"

#set output "6.png"
plot "quicksort.dat" using 2:xticlabels(1) with boxes lt rgb "#cb4679"
