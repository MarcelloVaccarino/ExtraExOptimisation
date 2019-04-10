# SETS

set C;

set E := {(i, j) in C cross C: i <> j};

set N :=  1 .. 2 ** card(C) - 1;

set P {n in N} = {i in C: (n div 2 ^ (i-1)) mod 2 = 1};

#PARAM
param t{(i,j) in E}, default 0;

param d{(i,j) in E};

param p;

param a;

param b;

param M := sum {(i, j) in E} t[i, j];

# VARS

# 1 if i is a hub
var y{i in C}, binary;

# active edges
var x{(i,j) in E}, binary;

#num of travellers on edge k,l that are travelling from i to j 
var w{(i,j) in E, (k, l) in E} >= 0;

# 1 if cost on edge i,j is b, 0 if its a
var z{(i,j) in E}, binary;

# multiplication linearisation
var u{(i,j) in E, (k,l) in E} >= 0;

# MODEL

minimize transportation_cost:
	sum {(k,l) in E} (
		sum {(i,j) in E} (
			d[i, j] * (b*u[i,j,k,l] + a*(w[i,j,k,l] - u[i,j,k,l]))
		)
	);

# u[i,j,k,l] = z[k,l] * w[i,j,k,l]
	s.t. z_upperbound{(i,j) in E, (k, l) in E}: 
		u[i,j,k,l] <= M * z[i,j];

	s.t. w_upperbound{(i,j) in E, (k, l) in E}: 
		u[i,j,k,l] <= w[i,j,k,l];

	s.t. u_lowerbound{(i,j) in E, (k, l) in E}: 
		u[i,j,k,l] >= w[i,j,k,l] - (1 - z[i,j]) * M;

s.t. num_hubs: sum{i in C} y[i] <= p;

s.t. closure_x_w {(k, l) in E}:
	sum{(i, j) in E} w[i,j,k,l] <= M * x[k, l];

# travel cost
	s.t. i_upperbound{(i,j) in E}: z[i,j] <= y[i];

	s.t. j_upperbound{(i,j) in E}: z[i,j] <= y[i];

	s.t. lowerbound{(i,j) in E}: z[i,j] >= y[i] + y[j] - 1;

s.t. closure_x_y {(i, j) in E}:
	x[i,j] <= y[i] + y[j];

s.t. cut{(i, j) in E, n in N: i in P[n] and j not in P[n]}: 
	sum{k in P[n], l in C diff P[n]} w[i,j,k,l] = t[i, j];

s.t. single_assignement{i in C}: 
	sum{j in C: (i,j) in E} x[i,j] <= 1 + card(C) * y[i]; 




