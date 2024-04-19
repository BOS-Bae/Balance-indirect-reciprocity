set terminal pdf
set output "kagome_m.pdf"

set xlabel font "Helvetica,25" 
set xtics font "Helvetica,23" 
set ytics font "Helvetica,25" 
set ylabel font "Helvetica,30" 
set xtics 2000
set origin 0.05,0.05
set rmargin 7.3
set size 0.97,0.95
set multiplot
set xlabel "MCS"
set ylabel "m"
set yrange [-1:1]
set label "(a)" at 8500, 0.755 font "Helvetica, 35"

plot "kagome_Lx10Ly10_T0.001" u 0:1 lc rgb "slateblue1" t ""

pause mouse key
