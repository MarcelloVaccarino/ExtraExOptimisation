# SETS & PARAMS

param W;			# width of the big roll

param m;			# num of different small rolls
set I := 1..m;
param w[I];			# width
param b[i];			# demand

param n;			# num of different patterns	
set J := 1..n;		

param  a {I, J};	# [TODO] generate patterns

# VARS
var x {j in J}, >= 0; 	# relaxation

# MODEL

minimize master_rolls:
	sum {j in J} x[j];

s.t. demand {i in I}:
	sum {j in J} a[i, j] * x[j] >= b[i]}
