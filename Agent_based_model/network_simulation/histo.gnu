set ytics font "Helvetica, 15"
set xtics font "Helvetica, 23"
set key font "Helvetica, 20"

set style data histogram
set style histogram clustered
set style histogram errorbars gap 1 lw 1
set style fill solid 0.25
set boxwidth 1 relative
set yrange [0.26:0.45]

p "Leading_game_L4.dat" u 5:6:xtic(4) lc rgb "blue" t "mutant", \
	"" u 2:3 lc rgb "green" t "L4 (resident)"
	
pause mouse key
