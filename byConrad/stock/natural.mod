# SETS & PARAMS

param p;
set K := 1..p;		# index set of large rolls
param W;			# width of the big roll

param m;
set I := 1..m;		# index set of small rolls
param w{I};			# width
param b{I};			# demand

# VARS
var x {I, K}, integer, >= 0;	# number of times i-th small roll is cut in k-th large roll
var y {K}, binary; 				# 1 if the k-th large roll is cut, with k ∈ K

# MODEL

minimize master_rolls:
	sum {k in K} y[k];

s.t. demand {i in I}:
	sum {k in K} x[i, k] >= b[i];

s.t. closure {k in K}:
	sum {i in I} w[i] * x[i, k] <= W * y[k];