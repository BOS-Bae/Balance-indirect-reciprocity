set terminal pdf
set output "L6_histo.pdf"
set style data histograms
set style fill solid border 0.5
set ytics (1,10,100,1000,10000,100000)
n=150
set log y
set format y "10^{%L}"

set xtics font "Helvetica,25"
set ytics font "Helvetica,20"
max=1.0
min=0.0
width=(max-min)/n
hist(x,width)=width*floor(x/width)+width/2.0
set boxwidth width*0.9
set yrange [0:]

set size 0.95,0.92
set origin 0.05,0.05

set xrange [min:max]
set label "(a)" at 0.8,10000 font "Helvetica, 35"
p "N4L6e-4t_histo.dat" u (hist($1,width)):(1.0) smooth freq w boxes lc rgb "black" t ""

pause mouse key
