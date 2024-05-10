set terminal pdf
set output "L4_paradise_N30.pdf"

f(x) = a*(x**b)
fit f(x) "frac_L4_L6.dat" u ($2/$1):3 via a,b

set xlabel font "Helvetica,25" 
set xtics font "Helvetica,20"
set ylabel font "Helvetica,25" 
set ytics font "Helvetica,20"
set key at 0.4, 0.95
set key font "Helvetica,20"
set multiplot
set lmargin -0.4
set rmargin -0.3
set xlabel "fraction"
set xrange [0:1]
set yrange [0:1]
set style line 1 lt 1 lw 2 ps 2 linecolor rgb "black"

set style data points
p "frac_L4_N30.dat" u ($2/$1):3:4 lc rgb "red" pt 2 ps 0.5 w yerrorbars t "", \
	f(x) t "0.96x^{1.6}" dt 2 lw 3 lc rgb "blue", \
	'' u ($2/$1):3 w lp lw 2 lc rgb "red" t "<o>", \
	'' u ($2/$1):5:6 lc rgb "green" pt 2 ps 0.5 w yerrorbars t "", \
	'' u ($2/$1):5 w lp lw 2 lc rgb "green" t "P(<o>=1)"
pause mouse key
