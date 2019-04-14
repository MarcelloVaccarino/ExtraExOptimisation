#---------------------
# SEPARATION PROBLEM |
#---------------------

# SETS
# Set are imported from the Primal Problem

# PARAMETERS

# Index parameter that identifies the Knapsack
# considered for this instance of the Separation 
# Problem
param j_bar symbolic within J;

# Current optimal solution of the Primal Problem
# It is indexed only on the set of Items since
# the .run file calls the Separation Problem once
# for each Knapsack j (which therefore is unique and 
# constant in this formulation).
param x_star{I}, >=0, <= 1;

# VARIABLES

var z{i in I}, binary;

# OBJECTIVE FUNCTION
# Find the Cover Inequality that is not satisfied by
# the optimal solution of the current Primal Problem
# by minimizing (maximizing 1 minus) the violation of 
# the Cover Inequality:
# 	
#	sum {i in C} x[i,j] <= card(C) - 1;
#				   |||
#	sum {i in C} (1 - x[i,j]) => 1
maximize violationObj: 
	1 - sum{i in I} (1 - x_star[i])*z[i];
	
# CONSTRAINTS

# All items i chosen for the Cover Inequality must satisfies
# the Cover property of exceeding the knapsack capacity
subject to violatedCover:
	sum{i in I} w[i,j_bar]*z[i] >= b[j_bar] + 1;