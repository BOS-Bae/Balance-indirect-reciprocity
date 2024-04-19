set xlabel "p"
set xrange [0:0.48]
set yrange [0:1.0]
set key left top
set key font "Helvetica,15"
set title "LTD (30 realizations)"
plot "dat_LTD_N64" u 1:2 t "ρ" w lp, \
 "dat_LTD_N64" u 1:3 t "n_0" w lp, \
 "dat_LTD_N64" u 1:4 t "n_1" w lp, \
 "dat_LTD_N64" u 1:5 t "n_2" w lp, \
 "dat_LTD_N64" u 1:6 t "n_3" w lp
