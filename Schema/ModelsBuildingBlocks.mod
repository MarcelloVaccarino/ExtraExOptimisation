# +-----------------------------+
# |  Binary Knapsack condition  |
# +-----------------------------+

set N; 			# Objects
param p {N}; 	# Profit for each obj
param w {N}; 	# Weight for each obj
param b; 		# Knapsack max total weight

var x {N}, binary;

maximize profit:
	sum {i in N} p[i] * x[i];

s.t. weight_limit:
	sum {i in N} w[i] * x[i];

# cover set constraint

set K :=  1 .. 2 ** card(N);

set P {k in K} = 
	{i in N: (k div 2 ^ (i-1)) mod 2 = 1};

s.t. cover_ineq {k in K: sum{i in P[k]} w[i] >= b}:
	sum{i in P[k]} (1 - x[i]) >= 1;

# +----------------------+
# |  Assingment Problem  |
# +----------------------+

set N; 				# Jobs
set M; 				# Machines
param c {N, M}; 	# Cost of assignemt

var x {N, M}, binary;

minimize cost:
	sum {i in N, j in M} c[i, j] * x[i, j];

s.t. assignemt {i in N}:
	sum {j in M} x[i, j] <= 1;

# +---------+
# |  Sets   |
# +---------+

set M; 					# Finite groundset
set N; 					# Subsets' indexes
set M{j in N} within M; # Collection of subsets

var x {N}, binary;		# 1 if M[j] is selected

# ---- COVER of M ----
# Each node is covered at LEAST once, i.e.:
# Union {i in N} M[i] = M;
# COVER problem: find a cover of minimum total cost

param c {N}; 	# Cost for each set

minimize cost: sum {j in N} c[j] * x[j];

s.t. cover_constraint {i in M}:
	sum {j in N: i in M[j]} x[j] >= 1;

# ---- PACKING of M ----
# Each node is covered at MOST once, i.e.:
# Inter {i in N, j in N: i<>j} M[i] inter M[j] = {};
# PACKING problem: find a packing of max total profit

param p {N}; 	# Profit for each set

maximize profit: sum {j in N} p[j] * x[j];

s.t. packing_constraint {i in M}:
	sum {j in N: i in M[j]} x[j] <= 1;

# ---- PARTITIONING of M ----
# Each node is covered EXACLY once, i.e.:
# is both a cover and a packing

# lab 3 - flight
[TODO]

# +---------------------+
# |  Facility Location  |
# +---------------------+

param m;			# Number of clients
set M = 1..m; 		# Clients
set N;				# Candidates sites
param f {N}; 		# Activation cost
param c {M, N}; 	# Transportation cost

var x {M, N}, integer, >= 0;	# Fraction of demand of client i served by depot j
var y {N}, binary; 	# Depot activation

minimize cost:
	sum {j in N} f[j]*y[j] + sum{i in M, j in N} c[i,j]*x[i,j];

s.t. assignement {i in M}:
	sum {j in M} x[i,j] >= 1;

# ---- Uncapacitated version ----

s.t. closure {i in M, j in N}:
	x[i,j] <= y[j];

# ---- Capacitated FL variant: ----
param d {M}			# demand of client i 
param k {N}			# capacity of depot j

s.t. capacity {j in N}:
	sum {i in M} d[i] * x[i,j] <= k[j] * y[j];

# +----------------------------------------+
# |  Asymmetric Traveling Salesman Problem |
# +----------------------------------------+
/* determine a Hamiltonian circuit (tour), 
   i.e., a circuit that visits exactly once each 
   node and comes back to the starting node, 
   of minimum total cost. */

# SETS and PARAMETERS
set V ordered; 	# Nodes
set A;			# Edges
param c {A}; 	# Cost of using an adge

# Powerset constraction
param n := card(V); 
set POWERSET := 0 .. (2**n - 1);
set S{k in POWERSET} := 
	{i in V : (k div 2**(ord(i)-1)) mod 2 = 1};

# VARS
var x {A}, binary;

# MODEL

maximize cost: 
	sum {(i,j) in A} c[i,j] * x[i,j];

s.t. deg_in {i in V}:
	sum {j in V: (i,j) in A} x[i,j] = 1;

s.t. deg_out {i in V}:
	sum {j in V: (j,i) in A} x[j,i] = 1;

/* to grant there are no isoleted components in the tour
   two ALTERNATIVE methods: */

# CUT-SET inequalities
s.t. cut_set 
	{k in POWERSET: card(S[k])<=n-1 and card(S[k])>=1}:
	sum {i in S[k], j in V diff S[k]: (i,j) in E} x[i,j] >= 1; 

# SUBTOUR ELIMINATION cnstraint
s.t. subtour_elimination 
	{k in POWERSET: card(S[k])<=n-1 and card(S[k])>=2}: 
	sum {i in S[k], j in S[k]: (i,j) in A} x[i,j] <= card(S[k] - 1);

# +---------------------------------------+
# |  Symmetric Traveling Salesman Problem |
# +---------------------------------------+
[TODO]

/*
# +--------------+
# |  Scheduling  |
# +--------------+

Determine an optimal schedule so as to 
minimize the time needed to complete all products, 
while satisfying all deadlines

Hypothesis: 
	- products cannot be processed simultaneously on the same machine
	- the execution of a product on a machine cannot be interrupted (non-preemptive scheduling)
*/

set M;		# Machines
set N;		# Products

var y {i in M, j in M, k in M: j < k} binary;
# y[i,j,k] = 1 if product i is processed before product j on machine k, and 
# y[i,j,k] = 0 otherwise

[TODO]

