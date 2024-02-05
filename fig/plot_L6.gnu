f1(x) = a*(x**b)
fit f1(x) 'L6_N100_s200_cluster' u 1:2 via a,b

set xlabel font "Helvetica,30" 
set xtics font "Helvetica,30"
set ylabel font "Helvetica,30" 
set ytics font "Helvetica,30"
set key font "Helvetica,25"
set log x 
set log y
set origin 0.05,0.01
set rmargin 7.3
set size 0.95,0.95
set multiplot
set xlabel "N"
set ylabel "η/N"
set xrange [3:100]
set yrange [0.05:1]
set label "(a)" at 5, 0.07 font "Helvetica, 35"
set style line 1 lt 1 lw 2 ps 2 linecolor rgb "black"

set style data points
set key right top
plot "L6_N100_s200_cluster" u 1:2:3 w yerrorbars lc rgb "black" pt 7 ps 1.5  t "", \
	 '' u 1:2 w lp lw 2 lc rgb "black" t "", \
	 1.3*a*(x**b) t "slope=-{1/2}" dt 2 lw 3 lc rgb "black"
pause mouse key
