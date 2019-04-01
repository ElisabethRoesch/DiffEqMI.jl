Multiple shooting (= Multiple Inits) for solving diffeq robustly.
I follow ideas of: F. Hamilton, “Parameter estimation in differential equations: A numerical study of shooting methods,”
SIAM Undergraduate Research Online, 2011.
Difference is: As a default, I observe not only one species but all. (they say only x)

I am doing only observation noise atm. Next goal is actual SDEs.

final goal: table with
  dim 1: optimizer
  dim 2: number shooting nodes
  dim 3: example system
  dim 4: noise level

also to do: test other noise distributions?
further work: somehow optimize number of shooting nodes
