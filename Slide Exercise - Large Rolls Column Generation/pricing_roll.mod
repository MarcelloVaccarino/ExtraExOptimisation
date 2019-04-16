#---------------------#
# PRICING SUB-PROBLEM #
#---------------------#

# PARAMETERS
param W;
param ystar{I};

# VARIABLES
var alpha{I}, integer, >= 0;

# OBJECTIVE FUNCTION
maximize reduced_cost:
	sum{i in I} ystar[i]*alpha[i];
	
# CONSTRAINT

# The new pattern must be feasible, i.e.
# must cut in such a way that it does not
# exceed the lenght of the Large Roll W
subject to largeroll:
	sum{i in I} w[i]*alpha[i] <= W;