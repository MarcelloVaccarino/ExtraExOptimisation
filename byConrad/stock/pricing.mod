# SETS & PARAMS

param W;			# width of the big roll

param m;			# num of different small rolls
set I := 1..m;
param w{I};		# width
param b{I};		# demand

# VARS
var alpha {I}, integer, >= 0;

# MODEL

minimize reduced_cost:
	1 - sum {i in I} y_star[i] * alpha[i];

s.t. constraint:
	sum {i in I} w[i] * alpha[i] >= W;
