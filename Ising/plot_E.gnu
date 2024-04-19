set terminal pdf
set output "kagome_E.pdf"

set xlabel font "Helvetica,25" 
set xtics font "Helvetica,23" 
set ytics font "Helvetica,25" 
set ytics (-1,0)
set ylabel font "Helvetica,27" 
set yrange [-1.1:0.1]
set xtics 2000
set origin 0.05,0.05
set rmargin 7.3
set size 0.97,0.95
set multiplot
set xlabel "MCS"
set ylabel "E/|E_g|"
set label "(b)" at 8500, -0.05 font "Helvetica, 35"

plot "kagome_Lx10Ly10_T0.001" u 0:($2/-$3) lc rgb "web-blue" t "", \
  '' u (-$3/$3) lc rgb "navy" t ""

pause mouse key
