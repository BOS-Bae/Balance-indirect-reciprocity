set xlabel font "Helvetica,20" 
set xtics font "Helvetica,15"
set ylabel font "Helvetica,20" 
set ytics font "Helvetica,15"
set key font "Helvetica,17"
set key at graph 0.25, graph 1.0
set log y
set format y "10^{%L}"
set multiplot
set xlabel "p"
set xrange [0.1:1]
set size 0.97,0.90
set origin 0.05,0.05

set style data points
p "L6_fixation.dat" u 1:10:11 w yerrorbars lc rgb "navy" pt 7 ps 1.5  t "N=23", \
	 '' u 1:10 w lp lw 2 lc rgb "navy" t "", \
  "L6_fixation.dat" u 1:8:9 w yerrorbars lc rgb "blue" pt 7 ps 1.5  t "N=21", \
	 '' u 1:8 w lp lw 2 lc rgb "blue" t "", \
  "L6_fixation.dat" u 1:6:7 w yerrorbars lc rgb "medium-blue" pt 7 ps 1.5  t "N=19", \
	 '' u 1:6 w lp lw 2 lc rgb "medium-blue" t "", \
  "L6_fixation.dat" u 1:4:5 w yerrorbars lc rgb "royalblue" pt 7 ps 1.5  t "N=17", \
	 '' u 1:4 w lp lw 2 lc rgb "royalblue" t "", \
  "L6_fixation.dat" u 1:2:3 w yerrorbars lc rgb "skyblue" pt 7 ps 1.5  t "N=15", \
	 '' u 1:2 w lp lw 2 lc rgb "skyblue" t ""
pause mouse key


