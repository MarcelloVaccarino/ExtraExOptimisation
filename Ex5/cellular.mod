param m;
set I := 1..m;		# Test points
param p {I};		# Transmission power

param n;
set S := 1..n;		# Base stations' candidates sites
param c {S}; 		# Activation cost

param g {I, S};		# Transmission gain

param SIRmin;
param Pmax;

# VARIABLES

var p {I, J}, >= 0, <= Pmax;	# Transmission power (between 0 and pmax) 
								# 	installed between TS i and BS j
var y {S}, integer;				# Activation of site j	

# MODEL

minimize cost:
	sum {j in S} c[j] * y[j];

s.t. closure {i in I, j in S}:
	p[i, j] <= y[j]

/* Mixed integer nonlinear programming formulation of the problem
s.t. quality_nonlinear {I, S}:
	g[i, j] * p[i, j] / sum {h in I diff {i}} g[h, j] * p[h, j] >= SIRmin; */

s.t. quality_linear {I, S}:
	g[i, j] * p[i, j] >= SIRmin * sum {h in I diff {i}} g[h, j] * p[h, j];
