reset;
# SETS

# Cities
set C;

# Hubs (subset of the cities)
param p;
set P within C := 1..p;

# Connections between cities
set E := {i in C, j in C: i<>j};


# PARAMETERS
param t{E}, >= 0, integer, default 0; #Number of passenger from city i to city j
param d{E}, >= 0, integer; #Distance between airports
param alpha; #Cost multiplier Hub-Hub
param beta; #Cost multiplier Hub-City / City-Hub

# VARIABLES
var x{C}, binary; # 1 if city c is Hub, 0 otherwise
var z{E,E}, integer; # Number of passanger going through (i,j) in order to travel from k to l
var w{E,E}, binary; # 1 if arc (i,j) is chosen for travel (k,l)

var y{E}, binary; #Linearization variable for product x[i] * x[j]
var u{E,E}, >= 0; #Linearization variable for product z[i,j,k,l] * y[i,j]

param z_UB = sum{(k,l) in E} t[k,l];

# OBJECTIVE FUNCTION
minimize costs: 
	sum{(k,l) in E} sum{(i,j) in E} (u[i,j,k,l] * d[i,j] * alpha +  (z[i,j,k,l] - u[i,j,k,l]) * d[i,j] * beta);


# CONSTRAINTS
subject to max_hubs:
	sum {i in C} x[i] <= p;
	
subject to allowed_travels {(i,j) in E, (k,l) in E}:
	w[i,j,k,l] <= x[i] + x[j];
	
subject to link_variable_zw {(i,j) in E, (k,l) in E}:
	z[i,j,k,l] <= w[i,j,k,l] * t[i,j];

subject to flow_balance_source {(k,l) in E, i in C: i = k}:
	sum{j in C: i <> j} z[i,j,k,l] - sum{j in C: i <> j} z[j,i,k,l] = t[k,l];
	
subject to flow_balance_destination {(k,l) in E, i in C: i = l}:
	sum{j in C: i <> j} z[i,j,k,l] - sum{j in C: i <> j} z[j,i,k,l] = - t[k,l];
	
subject to flow_balance_intermediate {(k,l) in E, i in C: i <> l and i <> k}:
	sum{j in C: i <> j} z[i,j,k,l] - sum{j in C: i <> j} z[j,i,k,l] = 0;

subject to linearization_xx_1 {(i,j) in E}:
	y[i,j] >= x[i] + x[j] - 1;
	
subject to linearization_xx_2 {(i,j) in E}:
	y[i,j] <= x[i];
	
subject to linearization_xx_3 {(i,j) in E}: 
	y[i,j] <= x[j];
	
subject to linearization_yz_1 {(k,l) in E, (i,j) in E}:
	u[i,j,k,l] <= z_UB * y[i,j];
	
subject to linearization_yz_2 {(k,l) in E, (i,j) in E}:
	u[i,j,k,l] <= z[i,j,k,l];
	
subject to linearization_yz_3 {(k,l) in E, (i,j) in E}:
	u[i,j,k,l] >= z[i,j,k,l] - (1 - y[i,j]) * z_UB;