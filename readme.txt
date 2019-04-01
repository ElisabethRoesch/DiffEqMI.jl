Multiple shooting (= Multiple Inits = MI) for solving diffeq robustly.
I follow ideas of: F. Hamilton, “Parameter estimation in differential equations: A numerical study of shooting methods,”
SIAM Undergraduate Research Online, 2011.
Difference is: As a default, I observe not only one species but all. (they say only x)

I am doing only observation noise atm. Next goal is actual SDEs.

final goal: table with
  dim 1: optimizer
  dim 2: number shooting nodes
  dim 3: example system
  dim 4: noise level

also to do:
- use https://github.com/JuliaNLSolvers/LsqFit.jl/blob/master/src/levenberg_marquardt.jl
  problem atm: "restricted by compatibility requirements with Atom [c52e3926] to versions: 0.1.0-0.1.2"
- test other noise
  sde wiener process
- test other systems
- somehow optimize number of re-init would be cool
