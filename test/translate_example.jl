
push!(LOAD_PATH,"/Users/eroesch/github/DiffEqMI.jl/src/")
include("../src/DiffEqMI.jl")
using OrdinaryDiffEq

u0 = Float32[2.; 0.]
tspan = (0.0f0, 3.f0)

a= ODEProblem(DiffEqMI.diffeqflux_example([ -2.0 ,-0.1,-0.1, 2.0]),u0,tspan)
b= ODEProblem(DiffEqMI.diffeqflux_example_old([-0.1 2.0; -2.0 -0.1]),u0,tspan)

sola = Array(solve(a,Tsit5()))
solb = Array(solve(b,Tsit5()))
