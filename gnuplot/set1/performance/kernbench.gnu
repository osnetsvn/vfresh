#!/usr/bin/gnuplot

# Output to PNG, with Verdana 8pt font
#set terminal pngcairo nocrop enhanced font "verdana,8" size 640,300

reset

set term pdfcairo size 12,8 enhanced font "Arial-Bold,40"
set output 'kernbench_vFresh.pdf

# Don't show the legend in the chart
set key top center box font "Arial-Bold,40" width -1 height 1 maxcols 2 maxrows 1  spacing 1
set key reverse Left
set key outside

set offset -0.7,-0.4,0,0

# Thinner, filled bars
set boxwidth 1
set style data histograms
set style fill solid 1.00 border lt -1

# Set a title and Y label. The X label is obviously months, so we don't set it.
#set title "Number of registrations per month" font ",14" tc rgb "#606060"
set ylabel "Execution Time (seconds)"

# Rotate X labels and get rid of the small stripes at the top (nomirror)
set border
set lmargin at screen 0.14
set rmargin at screen 0.95
set tics nomirror

#set xtics nomirror rotate by -45

# Show human-readable Y-axis. E.g. "100 k" instead of 100000.
#set format y '%.0s %c'

# Replace small stripes on the Y-axis with a horizontal gridlines
set tic scale 0
set grid ytics lc rgb "#808080"

# Manual set the Y-axis range
set yrange [0:200]
set ytics 0,50,200 font "Arial-Bold,40"
set xtics font "Arial-Bold,40" rotate by -15 offset 0,0
#set xtics offset 2

#set output "6.png"
plot "kernbench.dat" using 2:xticlabels(1) lt rgb "#406090" t 'Permormance', \
	'' 		using 3 lt rgb "#cb4679" t 'CPU Utilization (%)'
