# To check syntax:
# reset;
#-----------------
# MASTER PROBLEM |
#-----------------

# SETS
param n_i:=42; # Number of flights
param n_q:=9; # Number of the airports
set I:=1..n_i; # Set of the flights
set Q:=1..n_q; # Set of the airports

# PARAMETERS
param o{I}, symbolic in Q; # Origin airport of the flight 
param d{I}, symbolic in Q; # Destination airport of the flight
param s{I}; # Starting time of the flight
param l{I}; # Length of the flight

param n_j; # Number of pairings
set J:=1..n_j; # Set of pairings
param a{I,J},default 0; # Pairings matrix

# VARIABLES
var x{J}, >= 0;
# REMEMBER: The Master Problem is the Linear Relaxation of the 
# original problem, which means that the variable needs to be
# relaxed.

# OBJECTIVE FUNCTION: Minimize the overall number of Pairing chosen
# Since a crew needs to be instantiated for each Pairing, we want to
# choose the minimum number of possible pairing
minimize pairings:
	sum{j in J} x[j];
	
# CONSTRAINTS

# Ensure that the Pairing chosen actually covers all flights
subject to partitioning {i in I}:
	sum{j in J} a[i,j] * x[j] = 1;