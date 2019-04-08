param m;
param n;

set I := 1..n;
set P := 1..m;
set E := {(k,l) in ({0} union P) cross ({0} union P): k <> l};
set J {p in P} := I;
set N {p in P} := I diff J[p];
set H := 1..2^m-1;
set S {h in H} := {p in P: h mod 2^(p-1) = 1};

param tau{P};
param v{I};
param t{E};

var w{I, P union {0}} binary;
var x{i in I, (p,k) in E} binary;

minimize travel_time:
	sum {i in I} ( sum {(p,k) in E} t[p,k] * x[i,p,k] + sum {p in P} tau[p] * w[i,p]);

s.t. served{i in I, p in P}:
	sum{k in P: (p,k) in E} x[i,p,k] >= w[i,p];
	
s.t. assignement {p in P}:
	sum {i in I} w[i,p]= 1;

s.t. closure1 {i in P, (p,k) in E}:
	x[i,p,k] <= w[i,p];

s.t. closure2 {i in P, (p,k) in E}:
	x[i,p,k] <= w[i,k];

s.t. start {i in I}:
	sum {p in P} x[i,0,p] = 1;

s.t. arrival {i in I}:
	sum {p in P} x[i,p,0] = 1;

s.t. path{i in I, p in P union {0}}:
	sum {k in P: (p,k) in E} x[i,p,k] = sum {k in P: (p,k) in E} x[i,k,p];

s.t. subtour_elimination {i in I, h in H: card(S[h])>=2}:
	sum {l in S[h], k in S[h]: l<>k} x[i,l,k] <= sum {k in S[h]} w[i,k] - 1;

s.t. available_time {i in I}:
	sum {(p,k) in E} t[p,k] * x[i,p,k] + sum {p in P} tau[p] * w[i,p] <= v[i];

s.t. skill{p in P, i in N[p]}:
	w[i,p] <= 0;
