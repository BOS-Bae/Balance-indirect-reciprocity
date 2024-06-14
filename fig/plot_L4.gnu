set terminal pdf
set output "fig6b.pdf"
set xlabel font "Helvetica,40" 
set xtics font "Helvetica,37"
set ylabel font "Helvetica,40" 
set ytics font "Helvetica,40"
set ytics (0.6,0.7,0.8,0.9,1)
set ytics ("0.6"0.6, ""0.7, ""0.8, ""0.9, "1"1)
set key font "Helvetica,25"
set log x 
set log y
set origin 0.05,0.05
set rmargin 7.3
set size 0.95,0.95
set multiplot
set xlabel "N"
set ylabel "η/N"
set xrange [3:100]
set yrange [0.55:1.1]
set label "(b)" at 5, 0.625 font "Helvetica, 40"
set style line 1 lt 1 lw 2 ps 2 linecolor rgb "black"

set style data points
set key right top
plot "L4_N100_s200_cluster" u 1:2:3 w yerrorbars lc rgb "black" pt 7 ps 1.0 t "", \
	 '' u 1:2 w lp lw 2 lc rgb "black" t ""
pause mouse key
