reset;
# SETS

# Set of nodes of the network
param n;
set V ordered := 1..n;

# Set of potential arcs of the network
set A := (V cross V) diff {(i,j) in V cross V: i = j};

# Set of demands
param o;
set K := 1..o;

# Set of Subsets
set POWERSET := 0 .. (2**n - 1);
set S {p in POWERSET} := {i in V: (p div 2**(ord(i)-1)) mod 2 = 1};

# PARAMETERS
param c{(i,j) in A: i <> j}, >= 0, default 10; # Cost of a device on arc (i,j)
param u{(i,j) in A: i <> j}, >= 0, default 1; # Max Capacity installable on arc (i,j)
param s{(i,j) in A: i <> j}, >= 0, default 10; # Cost of routing 1 on arc (i,j)

param src{K}, symbolic in V; # Source node of the demand k
param dest{K}, symbolic in V; # Destination node of the demand k
param demand{K}, >= 0; # Quantity of units to satisfy demand k

# VARIABLES
var x{A, K}, binary;
var y{A}, >= 0, integer;
var z{A}, binary;

# OBJECTIVE FUNCTION
minimize cost:
	sum{k in K, (i,j) in A} s[i,j] * x[i,j,k] + sum{(i,j) in A} c[i,j] * y[i,j];
	
# CONSTRAINT
subject to balance_source{i in V, k in K: i = src[k]}:
	sum{(i,j) in A} x[i,j,k] - sum{(j,i) in A} x[j,i,k] = demand[k];

subject to balance_destination{i in V, k in K: i = dest[k]}:
	sum{(i,j) in A} x[i,j,k] - sum{(j,i) in A} x[j,i,k] = -demand[k];
	
subject to balance_intermediate{i in V, k in K: i <> src[k] and i <> dest[k]}:
	sum{(i,j) in A} x[i,j,k] - sum{(j,i) in A} x[j,i,k] = 0;	

subject to linking_variable_xy {(i,j) in A}:
	sum{k in K} x[i,j,k] <= y[i,j];

subject to capacity {(i,j) in A}:
	y[i,j] <= u[i,j];
	
subject to linking_variable_yz {(i,j) in A}:
	y[i,j] >= z[i,j];
	
subject to linking_variable_capacity {(i,j) in A}:
	y[i,j] <= u[i,j] * z[i,j];
	
subject to biconnectivity {k in K, p in POWERSET diff {2**n-1}: (p div 2**(1-1)) mod 2 = 1}:
	sum{(i,j) in A: i in S[p] and j in V diff S[p]} z[i,j] >= 2;

	