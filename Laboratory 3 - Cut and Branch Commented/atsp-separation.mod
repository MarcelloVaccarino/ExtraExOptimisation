
# SETS AND PARAMETERS
param x_star{A}, default 0;
set A_star := {(i,j) in A: x_star[i,j] > 0};

param source symbolic in V;
param target symbolic in V;
# VARIABLES
var y{A_star}, binary; # 1 if (i,j) is in the cut, 0 otherwise
var z{i in V}, binary; # 1 if node i is in the subset, 0 otherwise

# OBJECTIVE FUNCTION
minimize capacity:
	sum{(i,j) in A_star} y[i,j] * x_star[i,j];
	
# CONSTRAINTS

subject to z_source:
	z[source] = 1;
	
subject to z_target:
	z[target] = 0;

# For non-terminal nodes i,j: 
# if i is in S and j is in V/S, 
# then the edge (i,j) is counted in the cut
subject to cut {(i,j) in A_star: i <> source and j <> target}:
	y[i,j] >= z[i] - z[j];
	
# If i is in V/S, 
# then the edge (source,i) is counted in the cut
subject to c_source {(i,j) in A_star: i = source and j <> source}:
	y[i,j] <= 1 - z[j];

# If u is in S, 
# then the edge (u,target) is counted in the cut 
subject to c_target {(i,j) in A_star: j = target and i <> target}:
	y[i,j] >= z[i];


