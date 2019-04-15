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
param c{(i,j) in A: i <> j}, >= 0, default 0; # Cost of a device on arc (i,j)
param u{(i,j) in A: i <> j}, >= 0, default 0; # Max Capacity installable on arc (i,j)
param s{(i,j) in A: i <> j}, >= 0, default 0; # Cost of routing 1 on arc (i,j)

param src{K}, symbolic in V; # Source node of the demand k
param dest{K}, symbolic in V; # Destination node of the demand k
param demand{K}, >= 0; # Quantity of units to satisfy demand k

# VARIABLES
var x{A, K}, binary; # 1 if arc (i,j) is chosen for demand k; 0 otherwise
var y{A, K}, >= 0; # N° of devices installed on arc (i,j) for demand k;

# OBJECTIVE FUNCTION
minimize costs:
	sum{k in K, (i,j) in A: i <> j} ( (c[i,j] + s[i,j]) * y[i,j,k] );
	
# CONSTRAINTS
subject to arc_capacity{(i,j) in A: i <> j}:
	sum{k in K} y[i,j,k] <= u[i,j];

subject to balance_intermediate {k in K, i in V: i <> src[k] and i <> dest[k]}:
	sum{(i,j) in A: i <> j} y[i,j,k] - sum{(j,i) in A: i <> j} y[j,i,k] = 0;
	
subject to linking_variable {(i,j) in A, k in K: i <> j}:
	y[i,j,k] <= x[i,j,k] * u [i,j];
	
subject to biconnectivity {k in K, p in POWERSET diff {2**n-1}: (p div 2**(1-1)) mod 2 = 1}:
	sum{(i,j) in A: i in S[p] and j in V diff S[p]} x[i,j,k] >= 2;
	
subject to force_twopath_source {k in K, (i,j) in A: i = src[k]}:
	y[i,j,k] >=  demand[k] * x[i,j,k];
	
subject to force_twopath_destination {k in K, (j,i) in A: i = dest[k]}:
	y[j,i,k] >=  demand[k] * x[j,i,k];
	