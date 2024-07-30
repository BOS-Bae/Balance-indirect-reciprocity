set terminal pdf
set output "Exe_L4_paradise.pdf"

set xlabel font "Helvetica,25" 
set xtics font "Helvetica,20"
set ylabel font "Helvetica,25" 
set ytics font "Helvetica,20"
set key font "Helvetica,20"
set multiplot
set lmargin -0.4
set rmargin -0.3
set xlabel "N"

set style data points
p "Execution_L4.dat" u 1:4 w lp lw 2 lc rgb "blue" t "paradise"

pause mouse key
