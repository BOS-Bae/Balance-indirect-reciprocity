set terminal pdf
set output "L4_prob_N30.pdf"

set xlabel font "Helvetica,25" 
set xtics font "Helvetica,20"
set ylabel font "Helvetica,25" 
set ytics font "Helvetica,20"
set key at 0.9, 0.95
set key font "Helvetica,20"
set multiplot
set lmargin -0.4
set rmargin -0.3
set xlabel "q"
set xrange [0:1]
set yrange [0:1]
set style line 1 lt 1 lw 2 ps 2 linecolor rgb "black"

set style data points
p "prob_L4_N30.dat" u 2:3:4 lc rgb "red" w yerrorbars t "", \
	'' u 2:3 w lp lw 2 lc rgb "red" t "<o>", \
	'' u 2:5:6 lc rgb "green" w yerrorbars t "", \
	'' u 2:5 w lp lw 2 lc rgb "green" t "P(<o>=1)"
pause mouse key
