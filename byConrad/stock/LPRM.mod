# SETS & PARAMS

param W;			# width of the big roll

param m;			# num of different small rolls
set I := 1..m;
param w[I];			# width
param b[i];			# demand

set J;				# index set of patterns	
param  a {I, J};	

# VARS
var x {j in J}, >= 0;	# not integer, is a relaxation 

# MODEL

minimize master_rolls:
	sum {j in J} x[j];

s.t. demand {i in I}:
	sum {j in J} a[i, j] * x[j] >= b[i]}
