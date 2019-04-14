#---------------------#
# PRICING SUB-PROBLEM #
#---------------------#
# The Pricing sub-problem is transformed in to a Graph problem
# in order to actually verify that the vector Alpha actually represents

# a feasible pairing.
#
# Each Node is a Flight Leg
# Each Arc from node i1 to node i2 corresponds to a feasible precedence
#	1. Destination airport of i1 must be the origin of i2
#	2. Force 1 hour of rest period between the flights
# 
# Check parameter g
param source symbolic in I; 
param target symbolic in I;
param ystar{I};

# G in R^(I cross I) = Incidence matrix of the graph
# 	g(i1,i2) =	| 1 if exists arc (i1,i2)
#				| 0 otherwise
# See ColumnGeneration-i.run for its construction

param g{I,I}, default 0;

# VARIABLES
var alpha{I}, binary;
var z{I,I}, binary;
#	z(i1,i2) = 	| 1 if arc (i1,i2) is included in the pairing
#				| 0 otherwise

# objective function

# The Pairing with the lowest reduced cost is also the Longest one.
# Intuitively, considering the longest possible pairings allows the
# problem to find a smaller amount of Pairings in order to cover all
# flights, since the Pairings cover the maximum possible number of 
# flights.
maximize LongestPath:
	sum{i in I} ystar[i] * alpha[i];
	
# constraints

# A Source can be chosen only if the Flight is a possible Source (g)
# and if it is included in the pairing.
subject to balanceSource:
	sum{i in I} z[source, i] * g[source, i] = alpha[source];

# A Source can be chosen only if the Flight is a possible Target (g)
# and if it is included in the pairing.
subject to balanceTarget:
	sum{i in I} z[i, target] * g[i, target] = alpha[target];

# Balance within the current Pairing
subject to balance {i in I: i <> source and i <> target}:
	sum{i1 in I} z[i1, i] * g[i1, i] - sum{i1 in I} z[i,i1]*g[i, i1] = 0;

# Flights can be chosen only if they are reachable (g)
# and if they are part of the current pairing
subject to activation {i in I: i <> source and i <> target}:
	sum{i1 in I} z[i,i1] * g[i,i1] = alpha[i];