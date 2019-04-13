reset;

# SETS

# Set of Nurses
param n;
set I := 1..n;

# Set of Patient plus Head Office: the head office has Tau = 0 in the dataset
param m;
set J ordered := 1..m;

# PARAMETERS
param t{J, J}, >= 0, default 0; # Time spent traveling from patient k to patient l
param tau{J}, default 0; # Time spent at patient k
param v{I}, >= 0; # Maximum hours the nurse can work

# Set of Patiens
set P ordered := {j in J: tau[j] <> 0};

# Subsets of P
set POWERSET := 0 .. (2**card(P) - 1);
set S {o in POWERSET} := {p in P: (o div 2**(ord(p)-1)) mod 2 = 1};

# VARIABLES
var x{I,P}, binary; # 1 if nurses i is assigned to patient k
var y{I,J,J}, binary; # 1 if nurses i travels between patient k and patient l

# OBJECTIVE FUNCTIONS
minimize time:
	sum{i in I, k in J, l in J} t[k,l] * y[i,k,l];

# CONSTRAINTS
subject to assignment {p in P}:
	sum{i in I} x[i,p] = 1;

subject to balance {i in I, k in P}:
	sum{l in J: l <> k} y[i,k,l] = sum{l in J: l <> k} y[i,l,k];

subject to headoffice_start {i in I, k in J: tau[k] = 0}:
	sum{l in P} y[i,k,l] = 1;

subject to headoffice_end {i in I, k in J: tau[k] = 0}:
	sum{l in P} y[i,l,k] = 1;
	
subject to linking_variable {i in I, z in J, k in P: tau[z] = 0}:
	sum{l in P: l <> k} y[i,l,k] + y[i,z,k] = x[i,k];

subject to hours {i in I}:
	sum{k in J, l in J: k <> l} t[k,l] * y[i,k,l] + sum{p in P} x[i,p] * tau[p] <= v[i];

subject to subtour_elimination {i in I, o in POWERSET diff {2**card(P)-1}: (o div 2**(1-1)) mod 2 = 1 and card(S[o]) >= 2}:
	sum{l in S[o], k in S[o]} y[i,k,l] <= sum{k in S[o]} x[i,k];
	