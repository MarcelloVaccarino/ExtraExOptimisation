# SETS & PARAMS

param y_star{I};

# VARS
var alpha {I}, integer, >= 0;

# MODEL

minimize reduced_cost:
	1 - sum {i in I} y_star[i] * alpha[i];

s.t. knapsack:
	sum {i in I} w[i] * alpha[i] >= W;
