#-----------------
# MASTER PROBLEM |
#-----------------

# SETS
param n_i := 3;
set I := 1..n_i;	#Types of Small Rolls

param n_j;
set J:=1..n_j; # Set of Patterns
param a{I,J}, default 0; 	# Patterns Matrix
							# Initially it contains only the initial feasible patterns

# PARAMETERS
param w{I}, >= 0; # Width of the small roll i
param b{I}, >= 0; # Demand of the small roll i

# VARIABLES
var x{J}, >= 0; # Number of large roll cut according to j-th pattern
				# In the original formulation it was integer, but LPRM 
				# is the LR of the original problem
				
# OBJECTIVE FUNCTION
minimize largerolls:
	sum {j in J} x[j];
	
# CONSTRAINTS

# For each type of small roll, adjust the number of large
# roll cut in every pattern so to satisfy the demand
subject to demand{i in I}:
	sum{j in J} a[i,j]*x[j] >= b[i];
