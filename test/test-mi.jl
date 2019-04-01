
push!(LOAD_PATH,"/Users/eroesch/github/DiffEqMI.jl/src/")
include("../src/DiffEqMI.jl")
using OrdinaryDiffEq, Optim
########################### in by user ##########################
true_init = [2.; 0.]
true_params = [ -2.0 ,-0.1,-0.1, 2.0]
total_tspan = (0., 3.)
datasize = 30
n_subs = 3
n_species = 2
#this we could maybe hide better
total_t =  range(total_tspan[1], total_tspan[2], length = datasize)
true_sys = DiffEqMI.diffeqflux_example(true_params)
prob = ODEProblem(true_sys, true_init, total_tspan)
ode_data = Array(solve(prob,Tsit5(),saveat=total_t))
noisy_data = DiffEqMI.add_noise(ode_data, 0.6)
##################### visualize true #############################
using Plots
plot(total_t, ode_data[1,:], label="ode data")
scatter!(total_t, noisy_data[1,:], label="ode data")
######################## start positions #########################
u0_start_values = [[2.; 0.], [1.; 0.], [1.; 0.]]
params_start_values = [ -2.0 ,-0.04,-0.5, 2.0]
x= vcat(u0_start_values...,params_start_values)
####################### init multi init  #########################
test =DiffEqMI.tester()
DiffEqMI.init_tester(
                test,
                DiffEqMI.diffeqflux_example,
                datasize,
                n_subs,
                n_species,
                total_tspan,
                u0_start_values,
                params_start_values)
function L2_loss_fct(params)
    return sum(abs2,noisy_data .- DiffEqMI.update_tester(test, params))
end
###################################################################
result_one = Optim.optimize(L2_loss_fct, x )
###################################################################
using Plots
species = 1
plot(total_t, ode_data[species,:], label="ode data")
scatter!(total_t, noisy_data[species,:], label="ode data")
start_sys = DiffEqMI.diffeqflux_example(params_start_values)
start_prob = ODEProblem(start_sys, u0_start_values[1], total_tspan)
start_ode_data = Array(solve(start_prob,Tsit5(),saveat=total_t))
plot!(total_t, start_ode_data[1,:], label="start optim")
plot!(total_t, test.sols[species,:], label="end sol")
###################################################################
