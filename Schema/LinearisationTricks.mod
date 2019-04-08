# +----------------------------+
# | Disjunction of constraints |
# +----------------------------+

set N;			# Set of variable indexes
set M;			# Set of disequations indexes
param a {N, M}; # A matrix
param b {M};	# b vector
param u {N};	# x vector's upperbound

var x{N}, integer, x >= 0;

# Hypothesis
s.t. x_upperbound {i in N}:
	x[i] <= u[i];

/* 
s.t. disjunction {i in N}:
	Or {j in M} a[i, j] * x[i] <= b[j]; */

# auxiliary param [CHECK]
param M1 := max {i in I, j in M} a[i, j] * u[i] <= b[j];
param M2 {i in N} := max {j in M} b[j];
param bigM := max {M1, M2};

# auxiliary variable
var y {M}, binary;

s.t. exclusion: 
	sum {j in M} y[j] = 1; 

s.t. closure {j in M}:
	sum {i in N} a[i, j] * x[i] - b[j] 
		<= bigM * (1 - y[j]);

# +----------------------------+
# | Linearisation of a product |
# +----------------------------+
# ---- Product of two binary variables ----
# z = y1 * y2;

var y1, binary; var y2, binary;
var z, binary; 		# Auxiliary variable

s.t. upperbound1: z <= y1;
s.t. upperbound2: z <= y2;
s.t. lowerbound : z >= y1 + y2 - 1;

# ---- Product of several binary variables ----
# z = Prod {i in N} y[i];

var y {N}, binary;
var z, binary; 		# Auxiliary variable

s.t. upperbound1 {i in N}: z <= y[i];
s.t. lowerbound: z >= sum {i in N} y[i] - (card(N) + 1);

# ---- Product of mixed variables ----
# z = x * y;

param u;
var x, >= 0, <= u;
var y, binary;
var z, >= 0, <= u;	# Auxiliary variable

s.t. y_upperbound: z <= u * y;
s.t. x_upperbound: z <= x;
s.t. lowerbound  : z >= x - (1 - y) * u;

# +-----------------------------+
# | Linearisation of a quotient |
# +-----------------------------+

param a;
param b;
var y > 0;	# NB: y must be strictly positive

# s.t. c : a / y >= b;
s.t. a >= b * y

# Obviusly, in case y < 0, we have
s.t. a <= b * y;

# +-------------------------------------+
# |  Functions' pice-wise linearisation |
# +-------------------------------------+

/* ---- arbitrary non-convex function ----

Let 
	min {f(x): Ax >= b, x >= 0}
be an optimisation problem where 
	f : [a, b] -> R 
is an arbitrary non convex function.

Clearly we would like to linearize the 
objective fuction. This can be done pice-wise.

Suppose x[1] < x[2] < ... < x[k].
Any x in [x[1], x[k]] and his immage f(x)
can be expressed as:
	x = sum {i in 1..k} lambda[i] * x[i];
	f(x) = sum {i in 1..k} lambda[i] * f(x[i]);

Where the lambda coeffic.ent are positive and sume 1,
i.e. the linear combination is affine (c.1).
The choice of lambda is also unique if we require:
that at most two consecutive λ[i] can be nonzero 
by introducing the auxiliary variable y and 
conditions (2) and (3) */

param k := 100;		# linearisation discretion
set K := 1..k;		# index set
param a; 			# domain lowerbound
param b;			# domain upperbound
param x {i in K} := ((b-a)/k) * i + a;

var u;
var y {K}, integer, >= 0;
var lambda {K} >= 0;

minimize obj_fun:
	sum {i in K} lambda[i] * f(x[i])**2;

s.t. avg: 
	u = sum {i in 1 .. k-1} 
		(lambda[i] * x[i] + lambda[i+1] * x[i+1]);

s.t. affine: 						   # (c.1)
	sum {i in K} lambda[i] = 1;

s.t. exclusive: sum {i in K} y[i] = 1; # (c.2)

s.t. low_boundary:  lambda[1] <= y[1]; # (c3.1)
s.t. high_boundary: lambda[k] <= y[k]; # (c3.2)
s.t. closure {i in 2..k}: 			   # (c3.3)
	lambda[i] <= y[i-1] + y[i];

# ---- minimisatio of convex function ----
/* In case of a minimisation of a convex fun.
(or resp. the maximisation of a concave fun.)
at every point u in [a, b], this function is 
equal to max {i in K} f(x[i]). Hence the
formulation can be significantly simplified.*/

var teta;

minimize teta;

s.t. {i in 1 .. k-1}:
	teta >= (x - x[i]) * (f(x[i+1]) / (x[i+1] - x[i]) - f(x[i]));
