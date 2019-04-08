# SETS 

# Servers
set N; 

# Requests
set R = 1..100;

# PARAM
param c{N};

param mu{N};

param tau;

param p{R} default 1;

# VARS

# number of VM per server
var x{N}, integer, >= 0;

# Server - VM adjacency 
var w{N, R}, binary;

# OBJ
minimize cost:
	sum {i in N} c[i] * x[i] 
	+ sum{r in R} p[r] * (1 - sum {i in N} w[i,r]);

# CONSTRAINTS
s.t. memory{i in N}:
	x[i] <= mu[i];

s.t. service {i in N}:
	sum{r in R} w[i,r] <= mu[i] * x[i];

s.t. assignemnt {r in R}:
	sum {i in N} w[i,r] <= 1;

s.t. delay {i in N}:
	mu[i] * x[i] - sum {r in R} w[i,r] >= 1 / tau;


