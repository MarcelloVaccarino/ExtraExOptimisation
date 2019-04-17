# SETS

param n;
set V := 1..n; # Set of nodes

set A := {i in V, j in V: i <> j}; # Set of arcs

param nc;
set CUTSETS := 1..nc;

set Sstar{CUTSETS} within V;

# PARAMETERS
param c{A}, >= 0; # Cost of Arc i,j

# VARIABLES
var x{A}, >= 0; # Relaxation of binary variable x: 1 if arc i,j is taken; 0 otherwise

# OBJECTIVE FUNCTIONS
minimize costs:
	sum{(i,j) in A} c[i,j]*x[i,j];
	
# CONSTRAINTS
subject to degree_in {i in V}:
	sum{(i,j) in A} x[i,j] = 1;
	
subject to degree_out {i in V}:
	sum{(j,i) in A} x[j,i] = 1;
	
subject to cutset {k in CUTSETS}:
	sum{(i,j) in A: i in Sstar[k] and j in V diff Sstar[k]} x[i,j] >= 1;