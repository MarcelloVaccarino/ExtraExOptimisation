#-----------------
# PRIMAL PROBLEM |
#-----------------

# SETS

# Set of |I| different items
param m;
set I := 1..m;

# Set of |J| different knapsacks
param n;
set J := 1..n;

# Set of the added Cover parameters at each iteration
# It is managed in the .run file:
# 	1. Increasing the parameter nc;
# 	2. Adding the binary vector correspondent to the new cover in C
#	3. Adding the capacity of the new cover in J_bar
param nc >= 0;
set CUTS := 1..nc;

# PARAMETERS
param c{I,J}; 	# Cost of item i in knapsack j
param w{I,J}; 	# Weight of item i in knapsack j
param b{J};		# Capacity of knapsack j

set C{CUTS} within I;	#Set of the added Covers (initially empty, nc=0);
param J_bar{CUTS} symbolic within J;	# Set of the capacities of the added cover (initially empty, nc=0)

# VARIABLES
# Remember: The Primal Problem is the LR of the original problem,
# therefore x is not a binary variable, but it's relaxation:
var x{I,J}, >= 0, <= 1; # 1 if item i is inserted in knapsack j
						# 0 otherwise

# OBJECTIVE FUNCTION
minimize cost: 
	sum{i in I, j in J} c[i,j] * x[i,j];
	
# CONSTRAINTS

# Each item can be assigned only to one knapsack
subject to assignment {i in I}:
	sum{j in J} x[i,j] = 1;

# All items i inserted in knapsack j cannot exceed its capacity
subject to capacity {j in J}:
	sum{i in I} w[i,j]*x[i,j] <= b[j];

# Cover inequalities added so far: file .run adds them
subject to cover_inequality {k in CUTS}:
	sum{i in C[k]} x[i,J_bar[k]] <= card(C[k]) - 1;