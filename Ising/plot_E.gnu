set terminal pdf
set output "kagome_E.pdf"

set xlabel font "Helvetica,25" 
set ylabel font "Helvetica,30" 
set xtics 10000
set origin 0.05,0.05
set rmargin 7.3
set size 0.97,0.85
set multiplot
set xlabel "MCS"
set ylabel "E"
set label "(b)" at 85000, -30 font "Helvetica, 35"
set style line 1 lt 1 lw 2 ps 2 linecolor rgb "black"


plot "kagome_Lx10Ly10_T0.001" u 0:2 lc rgb "web-blue" t "", \
  '' u 0:3 lc rgb "navy" t ""

pause mouse key
