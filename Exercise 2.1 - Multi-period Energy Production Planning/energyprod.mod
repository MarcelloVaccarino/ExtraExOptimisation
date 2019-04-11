reset;
# SETS

# Set of Time Periods
param i;
set T := 1..i;

# Set of Cost ranges
param j;
set S := 1..j;

# PARAMETERS
param c4;					#Cost of MW from abroad
param c{S}, >= 0, integer;	#Cost of MW in-house for each production range s
param d{T}, >= 0;			#Demand of MW for each time period t
param l{S}, >= 0;			#Threshold for price range s

param M := l[3];

# VARIABLES
var x{T}, >= 0; # Amount of Energy locally (in-house) produced in period t
var y{T}, >= 0; # Amount of Energy purchased from abroad in period t
var z{S,T}, binary; # 1 if in period t the locally produced energy is in the range s, 0 otherwise

#Linearization variable
var w{S,T}, >= 0;

# OBJECTIVE FUNCTION
minimize costs:
	sum{t in T} (c4 * y[t]) + sum{t in T, s in S} c[s]*w[s,t];

# CONSTRAINTS
subject to demand {t in T}:
	x[t] + y[t] >= d[t];
	
subject to max_purchasable_energy {t in T}:
	(x[1] + y[1]) * 0.133 >= y[t];

subject to pairwise_linear_1 {t in T}:
	x[t] <= l[1] + M * (1 - z[1,t]); 
	
subject to pairwise_linear_2 {t in T}:
	x[t] >= l[1]*z[2,t];

subject to pairwise_linear_3 {t in T}:
	x[t] <= l[2] + M * (1 - z[2,t]);

subject to pairwise_linear_4 {t in T}:
	x[t] >= l[2]*z[3,t];
	
subject to pairwise_linear_5 {t in T}:
	sum{s in S} z[s,t] = 1;
	
subject to linearization_1 {t in T, s in S}:
	w[s,t] <= M * z[s,t];
	
subject to linearization_2 {t in T, s in S}:
	w[s,t] <= x[t];
	
subject to linearization_3 {t in T, s in S}:
	w[s,t] >= x[t] - (1 - z[s,t]) * M;